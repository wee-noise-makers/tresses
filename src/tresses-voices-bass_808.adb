with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Bass_808 is

   ---------------------
   -- Render_Bass_808 --
   ---------------------

   procedure Render_Bass_808
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env                    : in out Envelopes.AR.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Drive        : Param_Range renames Params (P_Drive);
      Pitch_Decay  : Param_Range renames Params (P_Punch);
      Attack       : Param_Range renames Params (P_Attack);
      Release      : Param_Range renames Params (P_Release);

      Phase_Incr_Delta : U32 := 0;

      Sample : S32;
      Fuzzed : S16;
      Drive_Amount : U32;
   begin
      if Do_Init then
         Do_Init := False;

         Set_Attack (Env, U7 (0));

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;
      end if;

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);

            Target_Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

            Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch + 2 * Octave));

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Phase_Incr_Delta := (Phase_Increment - Target_Phase_Increment) /
        (Resources.SAMPLE_RATE / (1 +
         (U32 (Param_Range'Last - Pitch_Decay)) / 259));

      --  Control curve: Drive to the power of 2
      Drive_Amount := U32 (Drive);
      Drive_Amount := Shift_Right (Drive_Amount**2, 15);
      Drive_Amount := Drive_Amount * 2;

      for Index in Buffer'Range loop

         if Phase_Increment > Target_Phase_Increment then
            Phase_Increment := Phase_Increment - Phase_Incr_Delta;
         end if;

         Phase := Phase + Phase_Increment;

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, Phase));
         --  Sample := Sample + S32 (Random.Get_Sample (Rng));

         --  Symmetrical soft clipping
         Fuzzed := DSP.Interpolate88
           (Resources.WS_Violent_Overdrive,
            U16 (Sample + 32_768));

         --  Mix clean and overdrive signals
         Sample := S32 (DSP.Mix (S16 (Sample), Fuzzed, U16 (Drive_Amount)));

         --  Amplitude envolope
         Render (Env);
         Sample := (Sample * Low_Pass (Env)) / 2**15;

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render_Bass_808;

end Tresses.Voices.Bass_808;
