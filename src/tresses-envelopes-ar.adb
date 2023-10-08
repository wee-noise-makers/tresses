--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Resources; use Tresses.Resources;
with Tresses.DSP;

package body Tresses.Envelopes.AR is

   ----------
   -- Init --
   ----------

   procedure Init (This          : in out Instance;
                   Do_Hold       :        Boolean;
                   Attack_Curve  : Curve         := Logarithmic;
                   Attack_Speed  : Segment_Speed := S_5_Seconds;
                   Release_Curve : Curve         := Exponential;
                   Release_Speed : Segment_Speed := S_10_Seconds)
   is
   begin
      This := (Do_Hold       => Do_Hold,
               Attack_Speed  => Attack_Speed,
               Release_Speed => Release_Speed,
               others => <>);

      This.LUT_Arr (Attack) :=
        (case Attack_Curve is
            when Linear      => Resources.LUT_Env_Linear'Access,
            when Logarithmic => Resources.LUT_Env_Log'Access,
            when Exponential => Resources.LUT_Env_Expo'Access);

      This.LUT_Arr (Release) :=
        (case Release_Curve is
            when Linear      => Resources.LUT_Env_Linear'Access,
            when Logarithmic => Resources.LUT_Env_Expo'Access,
            when Exponential => Resources.LUT_Env_Log'Access);
   end Init;

   -------------------
   -- Get_Increment --
   -------------------

   function Get_Increment (Speed : Segment_Speed; A : U7) return U32 is
   begin
      case Speed is
         when S_10_Seconds =>
            return LUT_Env_Increments_10seconds (U8 (A));
         when S_5_Seconds =>
            return LUT_Env_Increments_5seconds (U8 (A));
         when S_2_Seconds =>
            return LUT_Env_Increments_2seconds (U8 (A));
         when S_1_Seconds =>
            return LUT_Env_Increments_1seconds (U8 (A));
         when S_Half_Second =>
            return LUT_Env_Increments_Half_Second (U8 (A));
      end case;
   end Get_Increment;

   ----------------
   -- Set_Attack --
   ----------------

   procedure Set_Attack (This : in out Instance; A : U7) is
   begin
      This.Increment (Attack) := Get_Increment (This.Attack_Speed, A);
   end Set_Attack;

   -----------------
   -- Set_Release --
   -----------------

   procedure Set_Release (This : in out Instance; R : U7) is
   begin
      This.Increment (Release) := Get_Increment (This.Release_Speed, R);
   end Set_Release;

   ----------------
   -- Set_Attack --
   ----------------

   procedure Set_Attack (This : in out Instance; A : Param_Range) is
   begin
      Set_Attack (This, U7 (A / 2**8));
   end Set_Attack;

   -----------------
   -- Set_Release --
   -----------------

   procedure Set_Release (This : in out Instance; R : Param_Range) is
   begin
      Set_Release (This, U7 (R / 2**8));
   end Set_Release;

   --------
   -- On --
   --------

   procedure On (This : in out Instance; Velocity : Param_Range) is
   begin
      This.Target (Attack) := U16 (Velocity);
      This.Target (Hold) := U16 (Velocity);
      Trigger (This, Attack);
   end On;

   ---------
   -- Off --
   ---------

   procedure Off (This : in out Instance) is
   begin
      case This.Segement is
         when Attack | Hold =>
            Trigger (This, Release);
         when Release | Dead =>
            null;
      end case;
   end Off;

   -------------
   -- Trigger --
   -------------

   procedure Trigger (This : in out Instance; Seg : Segment_Kind) is
      Next_Segment : Segment_Kind := Seg;
   begin
      if Next_Segment = Dead then
         This.Value := 0;
      elsif Next_Segment = Hold and then not This.Do_Hold then
         Next_Segment := Segment_Kind'Succ (Hold);
      end if;

      This.A := This.Value;
      This.B := This.Target (Next_Segment);
      This.LUT := This.LUT_Arr (Next_Segment);

      This.Segement := Next_Segment;
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
                                DSP.Interpolate824 (This.LUT.all,
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
      This.LP := This.LP + ((S32 (This.Value) - This.LP) / 2**1);
      return Result;
   end Low_Pass;

end Tresses.Envelopes.AR;
