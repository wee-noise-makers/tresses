with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;

package body Tresses.Voices.Wave_Phaser is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Phase1, Phase2   : in out U32;
      Phase_Increment  : in out U32;
      Wave             :        Wave_Ref;
      Env              : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
   is
      Phaser  : Param_Range renames Params (P_Phaser);
      Fold    : Param_Range renames Params (P_Fold);
      Attack  : Param_Range renames Params (P_Attack);
      Release : Param_Range renames Params (P_Release);

      SampleA, SampleB : S32;
      Folded : S16;
      Phase_Increment2 : U32;

   begin
      if Do_Init then
         Do_Init := False;

         Phase1 := 0;
         Phase2 := 0;

         Init (Env, Do_Hold => True);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;
            On (Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;
            Off (Env);

         when None => null;
      end case;

      Phase_Increment := DSP.Compute_Phase_Increment (S16 (Pitch));
      Phase_Increment2 := Phase_Increment + U32 (Phaser) * 8;

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);

      for Index in Buffer'Range loop
         Phase1 := Phase1 + Phase_Increment;
         Phase2 := Phase2 + Phase_Increment2;
         SampleA := S32 (DSP.Interpolate824 (Wave.all, Phase1));
         SampleB := S32 (DSP.Interpolate824 (Wave.all, Phase2));

         --  Envolope
         Render (Env);
         SampleA := (SampleA + SampleB) / 2;

         Folded := DSP.Interpolate88 (Resources.WS_Sine_Fold,
                                      U16 (SampleA + 32_768));
         --  Mix clean and overdrive signals
         SampleA := S32 (DSP.Mix (S16 (SampleA), Folded, Fold));
         SampleA := (SampleA * S32 (Low_Pass (Env))) / 2**15;
         Buffer (Index) := S16 (SampleA);
      end loop;
   end Render;

end Tresses.Voices.Wave_Phaser;
