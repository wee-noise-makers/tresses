--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources;
with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.DSP;

package body Tresses.Voices.FM_OP2 is

   -------------------
   -- Render_FM_OP2 --
   -------------------

   procedure Render_FM_OP2
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AR.Instance;
      Phase           : in out U32;
      Modulator_Phase : in out U32;
      Pitch           :        Pitch_Range;
      Do_Init         : in out Boolean;
      Do_Strike       : in out Strike_State)
   is
      Integral : constant U16 := U16 (Params (P_Detune) / 2**8);
      Fractional : constant U16 := U16 (Params (P_Detune)) and 255;

      A : constant S16 := S16 (Resources.LUT_Fm_Frequency_Quantizer
                               (U8 (Integral)));
      B : constant S16 := S16 (Resources.LUT_Fm_Frequency_Quantizer
                               (U8 (Integral + 1)));

      --  Quantize parameter for FM
      Detune : constant Param_Range :=
        Param_Range (A + (((B - A) * S16 (Fractional)) / 2**8));

      Modulator_Pitch : constant S32 :=
        ((12 * 2**7) + S32 (Pitch) + ((S32 (Detune) - 16_384) / 2));

      Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Pitch));

      Modulator_Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Modulator_Pitch)) / 2;

      PM : U32;
      Sample : S32;

   begin


      if Do_Init then
         Do_Init := False;

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

      Set_Attack (Env, Params (P_Attack));
      Set_Release (Env, Params (P_Release));

      for Index in Buffer'Range loop
         Phase := Phase + Phase_Increment;
         Modulator_Phase := Modulator_Phase + Modulator_Phase_Increment;

         PM := U32 (-S32 (S16'First) + S32 (DSP.Interpolate824
                    (Resources.WAV_Sine, Modulator_Phase)));
         PM := (PM * U32 (Params (P_Modulation))) * 2**2;

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, Phase + PM));
         Render (Env);
         Sample := (Sample * S32 (Low_Pass (Env))) / 2**15;
         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;
   end Render_FM_OP2;

end Tresses.Voices.FM_OP2;
