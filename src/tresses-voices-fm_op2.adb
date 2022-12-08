--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources;
with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;
with Tresses.DSP;

package body Tresses.Voices.FM_OP2 is

   ---------------
   -- Set_Decay --
   ---------------

   procedure Set_Decay (This : in out Instance; P0 : Param_Range) is
   begin
      This.Decay_Param := P0;
   end Set_Decay;

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position (This : in out Instance; P1 : Param_Range) is
   begin
      This.Position_Param := P1;
   end Set_Position;

   ------------
   -- Strike --
   ------------

   overriding
   procedure Strike (This : in out Instance) is
   begin
      This.Do_Strike := True;
   end Strike;

   ---------------
   -- Set_Pitch --
   ---------------

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range)
   is
   begin
      This.Pitch := Pitch;
   end Set_Pitch;

   ----------------
   -- Set_Attack --
   ----------------

   overriding
   procedure Set_Attack (This : in out Instance; A : U7) is
   begin
      Envelopes.AD.Set_Attack (This.Env, A);
   end Set_Attack;

   ---------------
   -- Set_Decay --
   ---------------

   overriding
   procedure Set_Decay (This : in out Instance; D : U7) is
   begin
      Envelopes.AD.Set_Decay (This.Env, D);
   end Set_Decay;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_FM_OP2 (Buffer,
                     This.Decay_Param, This.Position_Param,
                     This.Env,
                     This.Phase,
                     This.Modulator_Phase,
                     This.Pitch,
                     This.Do_Strike);
   end Render;

   --------------------
   -- Render_Plucked --
   --------------------

   procedure Render_FM_OP2
     (Buffer                      :    out Mono_Buffer;
      Param0, Param1              :        Param_Range;
      Env                         : in out Envelopes.AD.Instance;
      Phase                         : in out U32;
      Modulator_Phase             : in out U32;
      Pitch                       :        Pitch_Range;
      Do_Strike                   : in out Boolean)
   is
      Modulator_Pitch : constant S32 :=
        ((12 * 2**7) + S32 (Pitch) + (S32 (Param1 - 16_384) / 2));

      Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Pitch));

      Modulator_Phase_Increment : constant U32 :=
        DSP.Compute_Phase_Increment (S16 (Modulator_Pitch)) / 2;

      PM : U32;
      Sample : S32;
   begin

      if Do_Strike then
         Do_Strike := False;
         Trigger (Env, Attack);
      end if;

      for Index in Buffer'Range loop
         Phase := Phase + Phase_Increment;
         Modulator_Phase := Modulator_Phase + Modulator_Phase_Increment;

         PM := U32 (-S32 (S16'First) + S32 (DSP.Interpolate824
                    (Resources.WAV_Sine, Modulator_Phase)));
         PM := (PM * U32 (Param0)) * 2**2;

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, Phase + PM));
         Sample := (Sample * S32 (Render (Env))) / 2**15;
         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;
   end Render_FM_OP2;

end Tresses.Voices.FM_OP2;
