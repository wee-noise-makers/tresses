with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

package body Tresses.Drums.Analog_Snare is

   -------------------------
   -- Render_Analog_Snare --
   -------------------------

   procedure Render_Analog_Snare
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Filter                 : in out Tresses.Filters.SVF.Instance;
      Tone_Env, Noise_Env             : in out Envelopes.AR.Instance;
      Rng                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Decay        : Param_Range renames Params (P_Decay);
      Noise        : Param_Range renames Params (P_Noise);
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
         Set_Attack (Tone_Env, 0);

         Init (Noise_Env,
               Do_Hold       => False,
               Attack_Speed  => S_Half_Second,
               Release_Speed => S_Half_Second);
         Set_Attack (Noise_Env, 20 * 2**8);

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;

         Init (Filter);
         Set_Mode (Filter, High_Pass);
         Set_Resonance (Filter, 0);
         Set_Frequency (Filter, Param_Range (MIDI_Pitch (MIDI.G3)));
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
              DSP.Compute_Phase_Increment (S16 (Pitch + Octave * 2));

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

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, Phase));
         Render (Tone_Env);
         Sample := (Sample * Low_Pass (Tone_Env)) / 2**15;

         Noise_Sample := S32 (Random.Get_Sample (Rng));
         Noise_Sample := Process (Filter, Noise_Sample);
         Render (Noise_Env);
         Noise_Sample := (Noise_Sample * S32 (Value (Noise_Env))) / 2**15;

         Sample := S32 (DSP.Mix (S16 (Sample), S16 (Noise_Sample),
                        U16 (Noise)));

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render_Analog_Snare;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_Analog_Snare (Buffer,
                           This.Params,
                           This.Phase,
                           This.Phase_Increment,
                           This.Target_Phase_Increment,
                           This.Filter,
                           This.Env1,
                           This.Env2,
                           This.Rng,
                           This.Pitch,
                           This.Do_Init,
                           This.Do_Strike);
   end Render;

end Tresses.Drums.Analog_Snare;
