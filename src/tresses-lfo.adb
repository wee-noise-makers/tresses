with Tresses.DSP;
with Tresses.Resources;

package body Tresses.LFO is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.Phase := 0;
      This.Phase_Increment := 1;
      This.Rate := Param_Range'Last / 2;
      This.Amplitude := Param_Range'Last / 2;
   end Init;

   ----------
   -- Sync --
   ----------

   procedure Sync (This : in out Instance) is
   begin
      This.Phase := 0;
      This.Halt := False;
   end Sync;

   ---------------
   -- Set_Shape --
   ---------------

   procedure Set_Shape (This : in out Instance; S : Shape_Kind) is
   begin
      This.Shape := S;
   end Set_Shape;

   --------------
   -- Set_Rate --
   --------------

   procedure Set_Rate (This  : in out Instance;
                       R     : Param_Range;
                       Scale : U32 := 1)
   is

      Index : constant U16 := U16 (R) / 2**7;
      A : constant U32 := Resources.LUT_Lfo_Increments (Index);
      B : constant U32 := Resources.LUT_Lfo_Increments (Index + 1);

   begin
      This.Phase_Increment :=
        A + ((((B - A) / 2) * (U32 (R) and 16#7F#)) / 2**6);
      This.Phase_Increment := This.Phase_Increment * Scale;
   end Set_Rate;

   -------------------
   -- Set_Amplitude --
   -------------------

   procedure Set_Amplitude (This : in out Instance;
                            A    :        Param_Range)
   is
   begin
      This.Amplitude := A;
   end Set_Amplitude;

   ------------------
   -- Set_Amp_Mode --
   ------------------

   procedure Set_Amp_Mode (This : in out Instance;
                           Mode :        Amplitude_Kind)
   is
   begin
      This.Amp_Mode := Mode;
   end Set_Amp_Mode;

   -------------------
   -- Set_Loop_Mode --
   -------------------

   procedure Set_Loop_Mode (This : in out Instance;
                            Mode :        Loop_Kind)
   is
   begin
      This.Loop_Mode := Mode;
      if Mode = Repeat then
         This.Halt := False;
      end if;
   end Set_Loop_Mode;

   ------------
   -- Render --
   ------------

   function Render (This : in out Instance) return S16 is
      Sample : S32;

      type Wave_Access is access constant Resources.Table_257_S16;
      Wave : Wave_Access := null;

   begin

      if not This.Halt then
         if This.Loop_Mode = One_Shot
           and then
             This.Phase >
               (2 * 24 * Resources.WAV_Sine_Lfo'Length) - This.Phase_Increment
         then
            This.Halt := True;
         else
            This.Phase := This.Phase + This.Phase_Increment;
         end if;
      end if;

      Wave := (case This.Shape is
                  when Sine      => Resources.WAV_Sine_Lfo'Access,
                  when Triangle  => Resources.WAV_Triangle_Lfo'Access,
                  when Ramp_Up   => Resources.WAV_Ramp_Up_Lfo'Access,
                  when Ramp_Down => Resources.WAV_Ramp_Down_Lfo'Access,
                  when Exp_Up    => Resources.WAV_Exp_Up_Lfo'Access,
                  when Exp_Down  => Resources.WAV_Exp_Down_Lfo'Access);

      Sample := S32 (DSP.Interpolate824 (Wave.all, This.Phase));
      Sample := (Sample * S32 (This.Amplitude)) / 2**15;

      case This.Amp_Mode is
         when Positive => null;
         when Center => Sample := Sample - S32 (S16'Last / 2);
         when Negative => Sample := -Sample;
      end case;

      return S16 (Sample);
   end Render;

end Tresses.LFO;
