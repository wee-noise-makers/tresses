with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Chip_Echo is

   ------------
   -- Render --
   ------------

   procedure Render
     (BufferA, BufferB :    out Mono_Buffer;
      Params           :        Param_Array;
      Osc_Select       : in out U32;
      Retrig1          : in out U32;
      Retrig2          : in out U32;
      Pitch1, Pitch2   : in out Pitch_Range;
      Osc1, Osc2       : in out Analog_Oscillator.Instance;
      Shape1, Shape2   :        Analog_Oscillator.Shape_Kind;
      Env1, Env2       : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
   is
      Time    : Param_Range renames Params (P_Time);
      Repeats : Param_Range renames Params (P_Repeats);
      ShapeP  : Param_Range renames Params (P_Shape);
      Release : Param_Range renames Params (P_Release);

      type Retrig_Info is record
         Time : U16;
         Velocity : Param_Range;
      end record
        with Size => 32;

      Ret1 : Retrig_Info with Address => Retrig1'Address;
      Ret2 : Retrig_Info with Address => Retrig2'Address;

      SampleA, SampleB : S32;

      Min_Delay : constant := Resources.SAMPLE_RATE / 8;
      Variable_Delay : constant := Resources.SAMPLE_RATE; -- 1.0s
      Max_Delay : constant := Min_Delay + Variable_Delay;
      pragma Compile_Time_Error (Max_Delay >= U16'Last,
                                 "Max_Delay doesn't fit in U16");
   begin
      if Do_Init then
         Do_Init := False;

         Analog_Oscillator.Init (Osc1);
         Analog_Oscillator.Set_Shape (Osc1, Shape1);
         Analog_Oscillator.Init (Osc2);
         Analog_Oscillator.Set_Shape (Osc2, Shape2);

         Init (Env1, Do_Hold => False, Release_Speed => S_2_Seconds);
         Set_Attack (Env1, 0);
         Set_Attack (Env1, 10);

         Init (Env2, Do_Hold => False, Release_Speed => S_2_Seconds);
         Set_Attack (Env2, 0);
         Set_Attack (Env2, 10);

         Pitch1 := 0;
         Pitch2 := 0;

         Osc_Select := 0;
         Ret1 := (Time => U16'Last, Velocity => 0);
         Ret2 := (Time => U16'Last, Velocity => 0);
      end if;

      Set_Release (Env1, Release);
      Set_Release (Env2, Release);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            if Osc_Select = 0 then
               Osc_Select := 1;
               On (Env1, Do_Strike.Velocity);
               Pitch1 := Pitch;
               Ret1.Velocity := DSP.Modulate (Do_Strike.Velocity, Repeats);
               Ret1.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
            else
               Osc_Select := 0;
               On (Env2, Do_Strike.Velocity);
               Pitch2 := Pitch;
               Ret2.Velocity := DSP.Modulate (Do_Strike.Velocity, Repeats);
               Ret2.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
            end if;

         when Off =>
            Do_Strike.Event := None;

            --  Don't care...

         when None => null;
      end case;

      if Ret1.Time < BufferA'Length then
         On (Env1, Ret1.Velocity);
         Ret1.Velocity := DSP.Modulate (Ret1.Velocity, Repeats);
         Ret1.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
      else
         Ret1.Time := Ret1.Time - BufferA'Length;
      end if;

      if Ret2.Time < BufferA'Length then
         On (Env2, Ret2.Velocity);
         Ret2.Velocity := DSP.Modulate (Ret2.Velocity, Repeats);
         Ret2.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
      else
         Ret2.Time := Ret2.Time - BufferA'Length;
      end if;

      Analog_Oscillator.Set_Pitch (Osc1, Pitch1);
      Analog_Oscillator.Set_Param (Osc1, 0, ShapeP);
      Analog_Oscillator.Render (Osc1, BufferA);

      Analog_Oscillator.Set_Pitch (Osc2, Pitch2);
      Analog_Oscillator.Set_Param (Osc2, 0, ShapeP);
      Analog_Oscillator.Render (Osc2, BufferB);

      for Index in BufferA'Range loop
         SampleA := S32 (BufferA (Index));
         SampleB := S32 (BufferB (Index));

         --  Envolopes
         Render (Env1);
         Render (Env2);

         SampleA := (SampleA * S32 (LoFi (Env1))) / 2**15;
         SampleB := (SampleB * S32 (LoFi (Env2))) / 2**15;
         BufferA (Index) := S16 ((SampleA + SampleB) / 2);
      end loop;

   end Render;

end Tresses.Voices.Chip_Echo;
