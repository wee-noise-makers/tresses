with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Wave_Echo is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Wave             :        Wave_Ref;
      Osc_Select       : in out U32;
      Retrig1          : in out U32;
      Retrig2          : in out U32;
      Phase1, Phase2   : in out U32;
      Pitch1, Pitch2   : in out Pitch_Range;
      Env1, Env2       : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
   is
      Time    : Param_Range renames Params (P_Time);
      Repeats : Param_Range renames Params (P_Repeats);
      Fold    : Param_Range renames Params (P_Fold);
      Release : Param_Range renames Params (P_Release);

      type Retrig_Info is record
         Time : U16;
         Velocity : Param_Range;
      end record
        with Size => 32;

      Ret1 : Retrig_Info with Address => Retrig1'Address;
      Ret2 : Retrig_Info with Address => Retrig2'Address;

      SampleA, SampleB : S32;
      Folded : S16;
      Phase_Increment_1, Phase_Increment_2 : U32;

      Min_Delay : constant := Resources.SAMPLE_RATE / 8;
      Variable_Delay : constant := Resources.SAMPLE_RATE; -- 1.0s
      Max_Delay : constant := Min_Delay + Variable_Delay;
      pragma Compile_Time_Error (Max_Delay >= U16'Last,
                                 "Max_Delay doesn't fit in U16");
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env1, Do_Hold => False, Release_Speed => S_2_Seconds);
         Set_Attack (Env1, 0);
         Set_Attack (Env1, 10);

         Init (Env2, Do_Hold => False, Release_Speed => S_2_Seconds);
         Set_Attack (Env2, 0);
         Set_Attack (Env2, 10);

         Pitch1 := 0;
         Pitch2 := 0;

         Phase1 := 0;
         Phase2 := 0;

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

      if Ret1.Time < Buffer'Length then
         On (Env1, Ret1.Velocity);
         Ret1.Velocity := DSP.Modulate (Ret1.Velocity, Repeats);
         Ret1.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
      else
         Ret1.Time := Ret1.Time - Buffer'Length;
      end if;

      if Ret2.Time < Buffer'Length then
         On (Env2, Ret2.Velocity);
         Ret2.Velocity := DSP.Modulate (Ret2.Velocity, Repeats);
         Ret2.Time := Min_Delay + DSP.Modulate (Variable_Delay, Time);
      else
         Ret2.Time := Ret2.Time - Buffer'Length;
      end if;

      Phase_Increment_1 := DSP.Compute_Phase_Increment (S16 (Pitch1));
      Phase_Increment_2 := DSP.Compute_Phase_Increment (S16 (Pitch2));

      for Index in Buffer'Range loop
         Phase1 := Phase1 + Phase_Increment_1;
         Phase2 := Phase2 + Phase_Increment_2;

         SampleA := S32 (DSP.Interpolate824 (Wave.all, Phase1));
         Folded := DSP.Interpolate88 (Resources.WS_Sine_Fold,
                                      U16 (SampleA + 32_768));
         --  Mix clean and folded signals
         SampleA := S32 (DSP.Mix (S16 (SampleA), Folded, Fold));

         SampleB := S32 (DSP.Interpolate824 (Wave.all, Phase2));
         Folded := DSP.Interpolate88 (Resources.WS_Sine_Fold,
                                      U16 (SampleB + 32_768));
         --  Mix clean and folded signals
         SampleB := S32 (DSP.Mix (S16 (SampleB), Folded, Fold));

         --  Envolopes
         Render (Env1);
         Render (Env2);

         SampleA := (SampleA * S32 (Low_Pass (Env1))) / 2**15;
         SampleB := (SampleB * S32 (Low_Pass (Env2))) / 2**15;
         Buffer (Index) := S16 ((SampleA + SampleB) / 2);
      end loop;

   end Render;

end Tresses.Voices.Wave_Echo;
