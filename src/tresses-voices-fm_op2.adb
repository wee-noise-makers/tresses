--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources;
with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;
with Tresses.DSP;

package body Tresses.Voices.FM_OP2 is

   --------------------
   -- Render_Plucked --
   --------------------

   procedure Render_FM_OP2
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AD.Instance;
      Phase           : in out U32;
      Modulator_Phase : in out U32;
      Pitch           :        Pitch_Range;
      Do_Strike       : in out Boolean)
   is
      Modulator_Pitch : constant S32 :=
        ((12 * 2**7) + S32 (Pitch) + (S32 (Params (2) - 16_384) / 2));

      Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Pitch));

      Modulator_Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Modulator_Pitch)) / 2;

      PM : U32;
      Sample : S32;
   begin

      Set_Attack (Env, Params (P_Attack));
      Set_Decay (Env, Params (P_Decay));

      if Do_Strike then
         Do_Strike := False;
         Trigger (Env, Attack);
      end if;

      for Index in Buffer'Range loop
         Phase := Phase + Phase_Increment;
         Modulator_Phase := Modulator_Phase + Modulator_Phase_Increment;

         PM := U32 (-S32 (S16'First) + S32 (DSP.Interpolate824
                    (Resources.WAV_Sine, Modulator_Phase)));
         PM := (PM * U32 (Params (1))) * 2**2;

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, Phase + PM));
         Sample := (Sample * S32 (Render (Env))) / 2**15;
         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;
   end Render_FM_OP2;

end Tresses.Voices.FM_OP2;
