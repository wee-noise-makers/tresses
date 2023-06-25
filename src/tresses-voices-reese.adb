with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

package body Tresses.Voices.Reese is

   ------------------
   -- Render_Reese --
   ------------------

   procedure Render_Reese
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Filter1            : in out Filters.SVF.Instance;
      Env                : in out Envelopes.AR.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
   is

      Detune_Div : constant Param_Range :=
        Param_Range'Last / Param_Range (Semitone);

      Detune : constant Pitch_Range :=
        Pitch_Range (Params (P_Detune) / Detune_Div);

      Osc0_Pitch : constant Pitch_Range := Pitch;
      Osc1_Pitch : constant Pitch_Range := Sub_Sat (Pitch, Detune);

      Osc_Param : constant Param_Range := 2 * (Param_Range'Last / 3);

      Sample : S32;
   begin

      if Do_Init then
         Do_Init := False;

         Osc0.Set_Shape (Analog_Oscillator.Variable_Saw);
         Osc0.Set_Param (0, Osc_Param);

         Osc1.Set_Shape (Analog_Oscillator.Saw);
         Osc1.Set_Param (0, Osc_Param);

         Init (Env, Do_Hold => True);

         Filters.SVF.Init (Filter1);
         Filters.SVF.Set_Mode (Filter1, Filters.SVF.Low_Pass);
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
      Filters.SVF.Set_Frequency (Filter1, Params (P_Band_pass) / 2);

      Osc0.Set_Pitch (Osc0_Pitch);
      Osc0.Render (Buffer_A);

      Osc1.Set_Pitch (Osc1_Pitch);
      Osc1.Render (Buffer_B);

      for Idx in Buffer_A'Range loop
         --  Mix
         Sample := (S32 (Buffer_A (Idx)) + S32 (Buffer_B (Idx))) / 2;

         --  Apply filter
         Sample := Filters.SVF.Process (Filter1, Sample);

         --  Apply envelope
         Render (Env);
         Sample := (Sample * Low_Pass (Env)) / 2**15;

         Buffer_A (Idx) := S16 (Sample);
      end loop;
   end Render_Reese;

end Tresses.Voices.Reese;
