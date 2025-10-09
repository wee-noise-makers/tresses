with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;

package body Tresses.Drums.Generic_Waveform_Noise_Kick is

   -----------------
   -- Render_Kick --
   -----------------

   procedure Render_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env, Noise_Env         : in out Envelopes.AR.Instance;
      RNG                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Decay        : Param_Range renames Params (P_Decay);
      Noise        : Param_Range renames Params (P_Noise);
      Pitch_Offset : Param_Range renames Params (P_Punch);
      Pitch_Decay  : Param_Range renames Params (P_Punch_Decay);

      Offset_Pitch_Incr : U32;
      Sample : S32;
      Phase_Noise : S32;
      Phase_Modulation : U32;
      Phase_Incr_Delta : U32 := 0;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env,
               Do_Hold => False,
               Release_Speed => S_2_Seconds);
         Set_Attack (Env, 0);

         Init (Noise_Env,
               Do_Hold => False,
               Release_Speed => S_Quarter_Second);
         Set_Attack (Noise_Env, 0);

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (Noise_Env, Do_Strike.Velocity);

            Target_Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

            Offset_Pitch_Incr :=
              DSP.Compute_Phase_Increment
                (S16 (Add_Sat (Pitch, Octave * 5)));

            Phase_Increment :=
              DSP.Mix (Target_Phase_Increment,
                       Offset_Pitch_Incr,
                       Pitch_Offset);

            Phase := 0;

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Release (Env, Decay);

      Set_Release (Noise_Env,  Param_Range'Last / 10); -- 25 milliseconds

      Phase_Incr_Delta := (Phase_Increment - Target_Phase_Increment) /
        (Resources.SAMPLE_RATE / (1 +
         (U32 (Param_Range'Last - Pitch_Decay)) / 259));

      for Index in Buffer'Range loop

         if Phase_Increment > Target_Phase_Increment then
            Phase_Increment := Phase_Increment - Phase_Incr_Delta;
         end if;

         Phase := Phase + Phase_Increment;

         Render (Noise_Env);
         Phase_Noise :=
           (S32 (Tresses.Random.Get_Sample (RNG)) *
              S32 (Value (Noise_Env))) / 2**15;

         --  Modulate phase noise level
         Phase_Noise := (Phase_Noise * S32 (Noise)) / 2**15;

         --  S16 to U32
         Phase_Modulation := U32 (-S32 (S16'First) + Phase_Noise) * 2**15;

         Sample := S32 (DSP.Interpolate824 (Tone_Waveform.all,
                        Phase + Phase_Modulation));

         --  Amplitude envolope
         Render (Env);
         Sample := (Sample * Low_Pass (Env)) / 2**15;

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render_Kick;

end Tresses.Drums.Generic_Waveform_Noise_Kick;
