with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP; use Tresses.DSP;

package body Tresses.Drums.Generic_Waveform_Snare is

   -------------------------
   -- Render_Analog_Snare --
   -------------------------

   procedure Render_Snare
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Tone_Env, Noise_Env    : in out Envelopes.AR.Instance;
      Rng                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Decay        : Param_Range renames Params (P_Decay);
      Noise        : Param_Range renames Params (P_Snappy);
      Noise_Decay  : Param_Range renames Params (P_Noise_Decay);
      Pitch_Decay  : Param_Range renames Params (P_Punch);

      Phase_Incr_Delta : U32 := 0;

      Sample : S32;
      Noise_Sample  : S32;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Tone_Env,
               Do_Hold       => False,
               Attack_Speed  => S_Half_Second,
               Release_Speed => S_Half_Second);
         Set_Attack (Tone_Env, Param_Range'Last / 32);
         Set_Attack (Tone_Env, 0);

         Init (Noise_Env,
               Do_Hold       => False,
               Attack_Speed  => S_Half_Second,
               Release_Speed => S_Half_Second);
         Set_Attack (Noise_Env, Param_Range'Last / 32);
         Set_Attack (Noise_Env, 0);

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            Set_Release (Tone_Env, Param_Range'Last / 4 + (Decay / 2));
            On (Tone_Env, Do_Strike.Velocity);

            Set_Release (Noise_Env, Param_Range'Last / 4 + (Noise_Decay / 2));
            On (Noise_Env, Do_Strike.Velocity);

            Target_Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

            Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Add_Sat (Pitch, Octave * 2)));

         when Off =>
            Do_Strike.Event := None;

            Off (Tone_Env);
            Off (Noise_Env);

         when None => null;
      end case;

      Phase_Incr_Delta := (Phase_Increment - Target_Phase_Increment) /
        (Resources.SAMPLE_RATE / (1 +
         (U32 (Param_Range'Last - Pitch_Decay)) / 259));

      for Index in Buffer'Range loop

         if Phase_Increment > Target_Phase_Increment then
            Phase_Increment := Phase_Increment - Phase_Incr_Delta;
         end if;

         Phase := Phase + Phase_Increment;

         Sample := S32 (DSP.Interpolate824 (Tone_Waveform.all, Phase));
         Render (Tone_Env);
         Sample := (Sample * Low_Pass (Tone_Env)) / 2**15;

         Render (Noise_Env);
         Noise_Sample := S32 (Random.Get_Sample (Rng));
         Noise_Sample := (Noise_Sample * S32 (Value (Noise_Env))) / 2**15;

         Sample := Sample + S32 (Noise_Sample * S32 (Noise)) / 2**15;

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render_Snare;

end Tresses.Drums.Generic_Waveform_Snare;
