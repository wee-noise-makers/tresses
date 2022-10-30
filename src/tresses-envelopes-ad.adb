--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources; use Tresses.Resources;
with Tresses.DSP;

package body Tresses.Envelopes.AD is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This := (others => <>);
   end Init;

   ----------------
   -- Set_Attack --
   ----------------

   procedure Set_Attack (This : in out Instance; A : U7) is
   begin
      This.Increment (Attack) := LUT_Env_Portamento_Increments (U8 (A));
   end Set_Attack;

   ---------------
   -- Set_Decay --
   ---------------

   procedure Set_Decay (This : in out Instance; D : U7) is
   begin
      This.Increment (Decay) := LUT_Env_Portamento_Increments (U8 (D));
   end Set_Decay;

   -------------
   -- Trigger --
   -------------

   procedure Trigger (This : in out Instance; Seg : Segment_Kind) is
   begin
      if Seg = Dead then
         This.Value := 0;
      end if;
      This.A := This.Value;
      This.B := This.Target (Seg);
      This.Segement := Seg;
      This.Phase := 0;
   end Trigger;

   ---------------------
   -- Current_Segment --
   ---------------------

   function Current_Segment (This : Instance) return Segment_Kind
   is (This.Segement);

   ------------
   -- Render --
   ------------

   function Render (This : in out Instance) return U16 is
      Increment : constant U32 := This.Increment (This.Segement);
   begin
      This.Phase := This.Phase + Increment;

      if This.Phase < Increment then
         This.Value := DSP.Mix (This.A, This.B, 65_535);
         Trigger (This, Segment_Kind'Succ (This.Segement));
      end if;

      if This.Increment (This.Segement) /= 0 then
         This.Value := DSP.Mix (This.A, This.B,
                                DSP.Interpolate824 (LUT_Env_Expo,
                                  This.Phase));
      end if;

      return This.Value;
   end Render;

   -----------
   -- Value --
   -----------

   function Value (This : Instance) return U16
   is (This.Value);

end Tresses.Envelopes.AD;
