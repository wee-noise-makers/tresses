--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources;
with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.DSP;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

package body Tresses.Voices.Screech is

   --------------------
   -- Render_Screech --
   --------------------

   procedure Render_Screech
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AR.Instance;
      Filter          : in out Tresses.Filters.SVF.Instance;
      Phase           : in out U32;
      Pitch           :        Pitch_Range;
      Do_Init         : in out Boolean;
      Do_Strike       : in out Strike_State)
   is
      Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Pitch - 2 * Octave));

      Sample : S32;
      Cutoff, Cutoff_Offset : S32;
      Fuzzed : S16;
      Drive_Amount : U32;
   begin

      if Do_Init then
         Do_Init := False;

         Init (Env,
               Do_Hold => True,
               Attack_Curve  => Logarithmic,
               Attack_Speed  => S_Half_Second,
               Release_Curve => Logarithmic,
               Release_Speed => S_1_Seconds);

         Init (Filter);
         Set_Mode (Filter, Low_Pass);
         Set_Punch (Filter, U16'First);
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

      Set_Resonance (Filter, Param_Range'Last);

      --  Control curve: Drive to the power of 2
      Drive_Amount := U32 (Params (P_Drive));
      Drive_Amount := Shift_Right (Drive_Amount**2, 15);
      Drive_Amount := Drive_Amount * 2;

      for Index in Buffer'Range loop
         Render (Env);

         Phase := Phase + Phase_Increment;
         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Screech, Phase));

         --  Cutoff control, from 0 to +4 octaves
         Cutoff_Offset :=
           (S32 (Params (P_Cutoff)) * S32 (4 * Octave)) / 2**15;
         --  Modulate from envelope
         Cutoff_Offset := (S32 (Value (Env)) * Cutoff_Offset) / 2**15;

         Cutoff := DSP.Clip (S32 (Pitch) + Cutoff_Offset,
                             0, S32 (Param_Range'Last));

         Set_Frequency (Filter, Param_Range (Cutoff));

         --  Filter
         Sample := Process (Filter, Sample);

         --  Symetrical softcliping
         Fuzzed := DSP.Interpolate88
           (Resources.WS_Violent_Step_Overdrive,
            U16 (Sample + 32_768));

         --  Mix clean and overdrive signals
         Sample := S32 (DSP.Mix (S16 (Sample), Fuzzed, U16 (Drive_Amount)));

         Sample := Sample * Low_Pass (Env) / 2**15;

         Buffer (Index) := S16 (Sample);
      end loop;
   end Render_Screech;

end Tresses.Voices.Screech;
