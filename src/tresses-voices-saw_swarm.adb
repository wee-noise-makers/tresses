--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Random; use Tresses.Random;
with Tresses.DSP;
with Tresses.Lookup_Tables;

package body Tresses.Voices.Saw_Swarm is

   ----------------
   -- Set_Cutoff --
   ----------------

   procedure Set_Detune (This : in out Instance; P0 : U16) is
   begin
      This.Detune_Param := P0;
   end Set_Detune;

   ---------------
   -- Set_Noise --
   ---------------

   procedure Set_High_Pass (This : in out Instance; P1 : U16) is
   begin
      This.High_Pass_Param := P1;
   end Set_High_Pass;

   ------------
   -- Strike --
   ------------

   procedure Strike (This : in out Instance) is
   begin
      This.Do_Strike := True;
   end Strike;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_Saw_Swarm (Buffer,
                        This.Detune_Param, This.High_Pass_Param,
                        This.Rng,
                        This.State,
                        This.Phase,
                        This.Pitch,
                        This.Do_Strike);
   end Render;

   ------------------
   -- Render_Snare --
   ------------------

   procedure Render_Saw_Swarm
     (Buffer                    :    out Mono_Buffer;
      Detune_Param, High_Pass_Param :        U16;
      Rng                       : in out Random.Instance;
      State                     : in out Saw_Swarm_State;
      Phase                     : in out U32;
      Pitch                     :        S16;
      Do_Strike                 : in out Boolean)
   is
      Increments : array (0 .. 6) of U32;

      Detune : S32;
   begin
      --  Clip to avoid interger overflow on Detune**2
      Detune := S32'Min (S32 (Detune_Param), 46_340);

      Detune := (Detune**2) / 2**9;

      for X in Increments'Range loop
         declare
            use DSP;

            Saw_Detune : constant S32 := Detune * S32 (X - 3);
            Detune_Integral : constant S16 := S16 (Saw_Detune / 2**16);
            Detune_Fractional : constant S32 := Saw_Detune and 16#FFFF#;

            Increment_A : constant S32 :=
              S32 (Compute_Phase_Increment (Pitch + Detune_Integral));
            Increment_B : constant S32 :=
              S32 (Compute_Phase_Increment (Pitch + Detune_Integral + 1));
         begin
            Increments (X) := U32
              (Increment_A +
                 (((Increment_B - Increment_A) * Detune_Fractional) / 2**16));
         end;
      end loop;

      if Do_Strike then

         Do_Strike := False;

         for Elt of State.Phase loop
            Elt := Get_Word (Rng);
         end loop;
      end if;

      declare
         HP_Cutoff : S32 := S32 (Pitch);
         F, Damp, Notch, HP, Sample : S32;
         BP : S32 renames State.BP;
         LP : S32 renames State.LP;

         Index : Natural := Buffer'First;

      begin
         if High_Pass_Param < 10_922 then
            HP_Cutoff := HP_Cutoff +
              (((S32 (High_Pass_Param) - 10_922) * 24) / 2**5);
         else
            HP_Cutoff := HP_Cutoff +
              (((S32 (High_Pass_Param) - 10_922) * 12) / 2**5);
         end if;

         if HP_Cutoff < 0 then
            HP_Cutoff := 0;
         elsif HP_Cutoff > 32_767 then
            HP_Cutoff := 32_767;
         end if;

         F := S32 (DSP.Interpolate824 (Lookup_Tables.SVF_Cutoff,
                                       Shift_Left (U32 (HP_Cutoff), 17)));

         Damp := S32 (Lookup_Tables.SVF_Damp (0));

         while Index <= Buffer'Last loop

            --  TODO: if (*sync++)

            Phase := Phase + Increments (0);
            State.Phase (0) := State.Phase (0) + Increments (1);
            State.Phase (1) := State.Phase (1) + Increments (2);
            State.Phase (2) := State.Phase (2) + Increments (3);
            State.Phase (3) := State.Phase (3) + Increments (4);
            State.Phase (4) := State.Phase (4) + Increments (5);
            State.Phase (5) := State.Phase (5) + Increments (6);

            Sample := -28_672;
            Sample := Sample + S32 (Shift_Right (Phase, 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (0), 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (1), 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (2), 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (3), 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (4), 19));
            Sample := Sample + S32 (Shift_Right (State.Phase (5), 19));
            Sample := S32 (DSP.Interpolate88
                           (Lookup_Tables.Moderate_Overdrive,
                              U16 (Sample + 32_768)));

            Notch := Sample - ((BP * Damp) / 2**15);
            LP := LP + ((F * BP) / 2**15);
            DSP.Clip_S16 (LP);

            HP := Notch - LP;
            BP := BP + ((F * HP) / 2**15);

            DSP.Clip_S16 (HP);
            Buffer (Index) := S16 (HP);
            Index := Index + 1;
         end loop;
      end;
   end Render_Saw_Swarm;

end Tresses.Voices.Saw_Swarm;
