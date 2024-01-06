with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Acid is

   -----------------
   -- Render_Acid --
   -----------------

   procedure Render_Acid
     (Buffer             :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0               : in out Analog_Oscillator.Instance;
      F_Env              : in out Envelopes.AR.Instance;
      Filter             : in out Filters.Ladder.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
   is
      Cutoff    : constant Param_Range := Params (P_Cutoff);
      Resonance : constant Param_Range := Params (P_Resonance);
      F_EG_Int  : constant Param_Range := Params (P_F_EG_Int);
      F_Decay   : constant Param_Range := Params (P_F_Decay);

      Sample : S32;
      F_Env_Val, A_Env_Val : S32;
      Cutoff_Val  : S32;
   begin

      if Do_Init then
         Do_Init := False;

         Osc0.Set_Param (0, 0);
         Osc0.Set_Shape (Analog_Oscillator.Saw);

         --  Filter envelope
         Init (F_Env,
               Do_Hold => False,
               Attack_Speed => S_Half_Second,
               Release_Speed => S_5_Seconds);
         Set_Attack (F_Env, 0);
         Set_Release (F_Env, 0);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            Set_Attack (F_Env, F_Decay / 2);
            Set_Release (F_Env, F_Decay);
            On (F_Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;
            Off (F_Env);

         when None => null;
      end case;

      Osc0.Set_Pitch (Pitch);
      Osc0.Render (Buffer);

      Filters.Ladder.Set_Resonance (Filter, Resonance);

      for Idx in Buffer'Range loop
         F_Env_Val := S32 (Render (F_Env));
         A_Env_Val := Low_Pass (F_Env);

         --  Apply Filter envelope intensity control
         F_Env_Val := (F_Env_Val * S32 (F_EG_Int)) / 2**15;

         --  Apply filter envelope to cutoff
         Cutoff_Val := S32 (Cutoff / 2) + F_Env_Val / 8;

         Filters.Ladder.Set_Cutoff (Filter, Param_Range (Cutoff_Val));

         Sample := S32 (Buffer (Idx));
         Sample := Filters.Ladder.Process (Filter, Sample);

         --  Symetrical softcliping, always to the max
         Sample := S32 (DSP.Interpolate88
                        (Resources.WS_Extreme_Overdrive,
                           U16 (Sample + 32_768)));

         --  Apply amp envelope
         Sample := (Sample * A_Env_Val) / 2**15;

         Buffer (Idx) := S16 (Sample);
      end loop;

   end Render_Acid;

end Tresses.Voices.Acid;
