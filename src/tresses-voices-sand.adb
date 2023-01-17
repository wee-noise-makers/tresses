with Tresses.Resources;
with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.DSP;

package body Tresses.Voices.Sand is

   -----------------
   -- Render_Sand --
   -----------------

   procedure Render_Sand
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Filter1            : in out Filters.SVF.Instance;
      Env                : in out Envelopes.AR.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
   is
      Trig_Pitch : constant Pitch_Range := Pitch - (7 * Semitone + Octave);
      Pulse_Pitch : constant Pitch_Range := Pitch + Octave;

      Sample : S32;
   begin

      if Do_Init then
         Do_Init := False;

         Osc0.Set_Shape (Analog_Oscillator.Triangle_Fold);

         Osc1.Set_Shape (Analog_Oscillator.Square);
         Osc1.Set_Param (0, 0);

         Init (Env, Do_Hold => True);

         Filters.SVF.Init (Filter1);
         Filters.SVF.Set_Mode (Filter1, Filters.SVF.Band_Pass);
         Filters.SVF.Set_Resonance (Filter1, 0);
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

      Set_Attack (Env, Params (P_Attack));
      Set_Release (Env, Params (P_Release));

      --  Filter frequency control
      Filters.SVF.Set_Frequency (Filter1, S16 (Params (P_Band_pass)) / 2);

      --  Render Triangle
      Osc0.Set_Param (0, Params (P_Fold));
      Osc0.Set_Pitch (Trig_Pitch);
      Osc0.Render (Buffer_A);

      --  Render square
      Osc1.Set_Pitch (Pulse_Pitch);
      Osc1.Render (Buffer_B);

      for Idx in Buffer_A'Range loop
         --  Mix
         Sample := (S32 (Buffer_A (Idx)) + S32 (Buffer_B (Idx))) / 2;

         --  Apply filter
         Sample := Filters.SVF.Process (Filter1, Sample);

         --  Asymmetrical soft clipping
         if Sample > 0 then
            Sample := S32 (DSP.Interpolate88
                           (Resources.WS_Violent_Overdrive,
                              U16 (Sample + 32_768)));
         end if;

         --  Apply envelope
         Render (Env);
         Sample := (Sample * S32 (Low_Pass (Env))) / 2**15;

         Buffer_A (Idx) := S16 (Sample);
      end loop;
   end Render_Sand;

end Tresses.Voices.Sand;
