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

   ----------------
   -- Set_Attack --
   ----------------

   procedure Set_Attack (This : in out Instance; A : Param_Range) is
   begin
      Set_Attack (This, U7 (A / 2**8));
   end Set_Attack;

   ---------------
   -- Set_Decay --
   ---------------

   procedure Set_Decay (This : in out Instance; D : Param_Range) is
   begin
      Set_Decay (This, U7 (D / 2**8));
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
      --  https://dsp.stackexchange.com/questions/2555/
      --   help-with-equations-for-exponential-adsr-envelope

      This.Phase := This.Phase + Increment;

      if This.Phase < Increment then
         --  We reached the end of the segment

         This.Value := This.B;

         --  Go to next segment
         Trigger (This, Segment_Kind'Succ (This.Segement));
      end if;

      if This.Increment (This.Segement) /= 0 then
         This.Value := DSP.Mix (This.A, This.B,
                                DSP.Interpolate824 (LUT_Env_Expo,
                                  This.Phase));
      end if;

      return This.Value;
   end Render;

   ------------
   -- Render --
   ------------

   procedure Render (This : in out Instance) is
      Unused : U16;
   begin
      Unused := Render (This);
   end Render;

   -----------
   -- Value --
   -----------

   function Value (This : Instance) return U16
   is (This.Value);

   --------------
   -- Low_Pass --
   --------------

   function Low_Pass (This : in out Instance) return S32 is
      Result : constant S32 := This.LP;
   begin
      This.LP := This.LP + ((S32 (This.Value) - This.LP) / 2**4);
      return Result;
   end Low_Pass;

end Tresses.Envelopes.AD;
