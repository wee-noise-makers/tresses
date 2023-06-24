with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

package body Tresses.Voices.House_Bass is

   -----------------------
   -- Render_House_Bass --
   -----------------------

   procedure Render_House_Bass
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Filter1            : in out Filters.SVF.Instance;
      Env, F_Env         : in out Envelopes.AR.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
   is
      Trig_Pitch : constant Pitch_Range := Pitch + Octave;
      Pulse_Pitch : constant Pitch_Range := Pitch;

      Cutoff : constant Param_Range := Param_Range (Pitch + 2 * Octave);
      Sample : S32;
   begin

      if Do_Init then
         Do_Init := False;

         Osc0.Set_Shape (Analog_Oscillator.Triangle_Fold);
         Osc0.Set_Param (0, 0);

         Osc1.Set_Shape (Analog_Oscillator.Sine);
         Osc1.Set_Param (0, 0);

         Init (Env, Do_Hold => True);

         Init (F_Env, Do_Hold => False);
         Set_Attack (F_Env, Param_Range (0));

         Filters.SVF.Init (Filter1);
         Filters.SVF.Set_Mode (Filter1, Filters.SVF.Low_Pass);
         Filters.SVF.Set_Resonance (Filter1, 0);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (F_Env, Do_Strike.Velocity / 8);

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Attack (Env, Params (P_Attack));
      Set_Release (Env, Params (P_Release));

      Set_Release (F_Env, Params (P_F_Release));

      Filters.SVF.Set_Resonance (Filter1, Param_Range'Last / 3);

      --  Render Triangle
      Osc0.Set_Param (0, Params (P_Fold));
      Osc0.Set_Pitch (Trig_Pitch);
      Osc0.Render (Buffer_A);

      --  Render square
      Osc1.Set_Pitch (Pulse_Pitch);
      Osc1.Render (Buffer_B);

      for Idx in Buffer_A'Range loop
         Render (Env);
         Render (F_Env);

         --  Filter frequency control
         Filters.SVF.Set_Frequency (Filter1,
                                    Cutoff + Param_Range (Value (F_Env)));

         --  Mix
         Sample := (S32 (Buffer_A (Idx)) + S32 (Buffer_B (Idx))) / 2;

         --  Apply filter
         Sample := Filters.SVF.Process (Filter1, Sample);

         --  Apply envelope
         Sample := (Sample * Low_Pass (Env)) / 2**15;

         Buffer_A (Idx) := S16 (Sample);
      end loop;
   end Render_House_Bass;

end Tresses.Voices.House_Bass;
