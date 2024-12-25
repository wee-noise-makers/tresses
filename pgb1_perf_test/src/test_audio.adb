with HAL; use HAL;
with Tresses; use Tresses;
with Tresses.Macro;
with RP.Timer; use RP.Timer;
with RP.Multicore.FIFO;
with Tresses.Resources;

package body Test_Audio is

   Osc : Tresses.Macro.Instance;

   Samples_Per_Buffer : constant := 128 * 2;

   Buffer_Time_Length_Us : constant Float :=
     (Float (Samples_Per_Buffer) / Tresses.Resources.SAMPLE_RATE_REAL)
       * 1_000_000.0;

   Buffer_A, Buffer_B : Tresses.Mono_Buffer (1 .. Samples_Per_Buffer);

   type Stereo_Point is record
      L, R : Tresses.Mono_Point;
   end record
     with Size => 32;

   type Stereo_Buffer is array (Buffer_A'Range) of Stereo_Point
     with Size => Samples_Per_Buffer * 32;

   type Buffer_Id is mod 2;

   Flip_Buffers : array (Buffer_Id) of Stereo_Buffer :=
     (others => (others => (0, 0)));
   Ready_To_Play : Buffer_Id := Buffer_Id'First;
   New_Buffer_Needed : Boolean := True
     with Volatile;

   type Mean_Count is mod 100;
   Mean_Values : array (Mean_Count) of UInt32 := (others => 0);
   Next_In : Mean_Count := Mean_Count'First;

   Trigger_Period : constant RP.Timer.Time := RP.Timer.Milliseconds (1000);
   Next_Trigger : RP.Timer.Time := RP.Timer.Clock + Trigger_Period;

   ---------------------
   -- Output_Callback --
   ---------------------

   procedure Output_Callback (Buffer             : out System.Address;
                              Stereo_Point_Count : out HAL.UInt32)
   is
      Selected_Buffer : constant Buffer_Id := Ready_To_Play;
   begin
      Buffer := Flip_Buffers (Selected_Buffer)'Address;
      Stereo_Point_Count := Flip_Buffers (Selected_Buffer)'Length;
      New_Buffer_Needed := True;
   end Output_Callback;

   ------------------------
   -- Reset_Measurements --
   ------------------------

   procedure Reset_Measurements is
   begin
      Last_Render_Time := 0;
      Max_Render_Time := 0;
      Min_Render_Time := UInt32'Last;
      Mean_Render_Time := 0;
      Mean_Values := (others => 0);
   end Reset_Measurements;

   ---------------
   -- Read_FIFO --
   ---------------

   procedure Read_FIFO is
      V : UInt32;
   begin
      while RP.Multicore.FIFO.Try_Pop (V) loop
         case V is
            when Cmd_Reset_Measurements =>
               Reset_Measurements;

            when Cmd_Next_Engine =>
               Osc.Next_Engine;

            when Cmd_Prev_Engine =>
               Osc.Prev_Engine;

            when others =>
               null;
         end case;
      end loop;
   end Read_FIFO;

   -------------------
   -- Update_Buffer --
   -------------------

   procedure Update_Buffer is

      Buffer_To_Write : Buffer_Id;
      T1, T2, Elapsed : RP.Timer.Time;
   begin

      --  Trigger a note at fixed intervals
      if Next_Trigger < RP.Timer.Clock then
         Next_Trigger := Next_Trigger + Trigger_Period;
         Osc.Note_On (Param_Range'Last);
      end if;

      Read_FIFO;

      --  Do we need to provide a new audio buffer?
      if New_Buffer_Needed then
         Buffer_To_Write := Ready_To_Play + 1;
         New_Buffer_Needed := False;

         --  Measure rendering time
         T1 := RP.Timer.Clock;
         Osc.Render (Buffer_A, Buffer_B);
         T2 := RP.Timer.Clock;

         Elapsed := T2 - T1;

         if Elapsed > Time (UInt32'Last) then
            Last_Render_Time := UInt32'Last;
            Last_CPU_Charge_Percent := 1.0;
         else
            Last_Render_Time := UInt32 (Elapsed);

            Last_CPU_Charge_Percent :=
              Float (Last_Render_Time) / Buffer_Time_Length_Us;
         end if;

         if Last_Render_Time > Max_Render_Time then
            Max_Render_Time := Last_Render_Time;
            Max_CPU_Charge_Percent :=
              Float (Max_Render_Time) / Buffer_Time_Length_Us;
         end if;

         if Last_Render_Time < Min_Render_Time then
            Min_Render_Time := Last_Render_Time;
         end if;

         Mean_Values (Next_In) := Last_Render_Time;
         Next_In := Next_In + 1;

         declare
            Sum : UInt64 := 0;
            Mean : UInt64;
         begin
            for Elt of Mean_Values loop
               Sum := Sum + UInt64 (Elt);
            end loop;

            Mean := Sum / Mean_Values'Length;

            if Mean > UInt64 (UInt32'Last) then
               Mean_Render_Time := UInt32'Last;
               Mean_CPU_Charge_Percent := 1.0;
            else
               Mean_Render_Time := UInt32 (Mean);
               Mean_CPU_Charge_Percent :=
                 Float (Mean_Render_Time) / Buffer_Time_Length_Us;
            end if;
         end;

         for Index in Stereo_Buffer'Range loop
            Flip_Buffers (Buffer_To_Write) (Index).L := Buffer_A (Index);
            Flip_Buffers (Buffer_To_Write) (Index).R := Buffer_A (Index);
         end loop;

         Ready_To_Play := Buffer_To_Write;
      end if;
   end Update_Buffer;

   ------------
   -- Engine --
   ------------

   function Engine return Tresses.Engines
   is (Osc.Engine);

begin
   Osc.Set_Engine (Tresses.Drum_Cymbal);
end Test_Audio;
