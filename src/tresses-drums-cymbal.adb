with Tresses.SVF; use Tresses.SVF;
with Tresses.Random; use Tresses.Random;
with Tresses.DSP;

package body Tresses.Drums.Cymbal is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.Do_Init := True;
   end Init;

   ----------------
   -- Set_Cutoff --
   ----------------

   procedure Set_Cutoff (This : in out Instance; P0 : U16) is
   begin
      This.Cutoff_Param := P0;
   end Set_Cutoff;

   ---------------
   -- Set_Noise --
   ---------------

   procedure Set_Noise (This : in out Instance; P1 : U16) is
   begin
      This.Noise_Param := P1;
   end Set_Noise;

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
      Render_Cymbal (Buffer,
                     This.Cutoff_Param, This.Noise_Param,
                     This.Filter0, This.Filter1,
                     This.State,
                     This.Phase,
                     This.Pitch,
                     This.Do_Init, This.Do_Strike);
      This.Do_Init := False;
      This.Do_Strike := False;
   end Render;

   ------------------
   -- Render_Snare --
   ------------------

   procedure Render_Cymbal
     (Buffer                    :    out Mono_Buffer;
      Cutoff_Param, Noise_Param :        U16;
      Filter0, Filter1          : in out SVF.Instance;
      State                     : in out Cymbal_State;
      Phase                     : in out U32;
      Pitch                     :        S16;
      Do_Init                   :        Boolean;
      Do_Strike                 :        Boolean)
   is
      pragma Unreferenced (Do_Strike);

      Increments : array (0 .. 6) of U32;
      Note : constant S32 := (40 * 2**7) + (S32 (Pitch) / 2**1);
      Root : U32;
   begin
      if Do_Init then

         Init (Filter0);
         Set_Mode (Filter0, Band_Pass);
         Set_Resonance (Filter0, 12_000);

         Init (Filter1);
         Set_Mode (Filter1, High_Pass);
         Set_Resonance (Filter1, 2_000);
      end if;

      Increments (0) := DSP.Compute_Phase_Increment (S16 (Note));

      Root := Shift_Right  (Increments (0), 10);
      Increments (1) :=  Shift_Left (Root * 24_273, 4);
      Increments (2) :=  Shift_Left (Root * 12_561, 4);
      Increments (3) :=  Shift_Left (Root * 18_417, 4);
      Increments (4) :=  Shift_Left (Root * 22_452, 4);
      Increments (5) :=  Shift_Left (Root * 31_858, 4);
      Increments (6) :=  Increments (0) * 24;

      declare
         Xfade : constant S32 := S32 (Noise_Param);
         Hat_Noise, Noise : S32;
         Index : Natural := Buffer'First;

      begin
         Set_Frequency (Filter0, S16 (Cutoff_Param / 2));
         Set_Frequency (Filter1, S16 (Cutoff_Param / 2));

         while Index <= Buffer'Last loop
            Phase := Phase + Increments (6);
            if Phase < Increments (6) then
               State.Last_Noise := Get_Sample (State.Rng);
            end if;

            State.Phase (0) := State.Phase (0) + Increments (0);
            State.Phase (1) := State.Phase (1) + Increments (1);
            State.Phase (2) := State.Phase (2) + Increments (2);
            State.Phase (3) := State.Phase (3) + Increments (3);
            State.Phase (4) := State.Phase (4) + Increments (4);
            State.Phase (5) := State.Phase (5) + Increments (5);

            Hat_Noise := 0;
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (0), 31));
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (1), 31));
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (2), 31));
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (3), 31));
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (4), 31));
            Hat_Noise := Hat_Noise + S32 (Shift_Left (State.Phase (5), 31));
            Hat_Noise := Hat_Noise - 3;
            Hat_Noise := Hat_Noise * 5_461;
            Hat_Noise := Process (Filter0, Hat_Noise);

            DSP.Clip_S16 (Hat_Noise);

            Noise := S32 (State.Last_Noise) - 32_768;
            Noise := Process (Filter1, Noise / 2**1);
            DSP.Clip_S16 (Noise);

            Buffer (Index) :=
              S16 (Hat_Noise + ((Noise - Hat_Noise) * Xfade) / 2**15);
            Index := Index + 1;
         end loop;
      end;
   end Render_Cymbal;

end Tresses.Drums.Cymbal;
