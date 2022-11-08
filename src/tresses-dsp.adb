with Ada.Unchecked_Conversion;
with Tresses.Resources; use Tresses.Resources;

package body Tresses.DSP is

   --------------------
   -- Interpolate824 --
   --------------------

   function Interpolate824 (T : Table_257_U16; Phase : U32) return U16 is
      P : constant U16 := U16 (Shift_Right (Phase, 24));
      A : constant U32 := U32 (T (P));
      B : constant U32 := U32 (T (P + 1));

      V : constant U32 :=
        Shift_Right (Shift_Right (Phase, 8) and 16#FFFF#, 16);
   begin
      return U16 (A + ((B - A) * V));
   end Interpolate824;

   --------------------
   -- Interpolate824 --
   --------------------

   function Interpolate824 (T : Table_257_S16; Phase : U32) return S16 is
      P : constant U16 := U16 (Shift_Right (Phase, 24));
      A : constant S32 := S32 (T (P));
      B : constant S32 := S32 (T (P + 1));

      V : constant S32 :=
        S32 (Shift_Right (Shift_Right (Phase, 8) and 16#FFFF#, 16));
   begin
      return S16 (A + ((B - A) * V));
   end Interpolate824;

   -------------------
   -- Interpolate88 --
   -------------------

   function Interpolate88 (T : Table_257_S16; Index : U16) return S16 is
      I : constant U16 := Shift_Right (Index, 8);
      A : constant S32 := S32 (T (I));
      B : constant S32 := S32 (T (I + 1));

      V : constant S32 := S32 (Index and 16#FF#) / 2**8;
   begin
      return S16 (A + ((B - A) * V));
   end Interpolate88;

   ---------------
   -- Crossfade --
   ---------------

   function Crossfade (Table_A, Table_B : Resources.Table_257_S16;
                       Phase            : U32;
                       Balance          : U16)
                       return S16
   is
      A : constant S32 := S32 (Interpolate824 (Table_A, Phase));
      B : constant S32 := S32 (Interpolate824 (Table_B, Phase));
   begin
      return S16 (A + ((B - A) * S32 (Balance)) / 2**16);
   end Crossfade;

   ----------
   -- Clip --
   ----------

   function Clip (V : S32; First, Last : S32) return S32
   is (S32'Min (S32'Max (V, First), Last));

   ----------
   -- Clip --
   ----------

   procedure Clip (V : in out S32; First, Last : S32) is
   begin
      V := Clip (V, First, Last);
   end Clip;

   --------------
   -- Clip_S16 --
   --------------

   procedure Clip_S16 (V : in out S32) is
   begin
      V := Clip_S16 (V);
   end Clip_S16;

   --------------
   -- Clip_S16 --
   --------------

   function Clip_S16 (V : S32) return S32
   is (Clip (V, -32_767, 32_767));

   ---------
   -- Mix --
   ---------

   function Mix (A, B, Balance : U16) return U16 is
   begin
      return U16 (Shift_Right (U32 (A) * (65_535 - U32 (Balance)) +
                    U32 (B) * U32 (Balance),
                  16));
   end Mix;

   -----------
   -- "and" --
   -----------

   function "and" (A : S32; B : U32) return S32 is
      function To_U32 is new Ada.Unchecked_Conversion (S32, U32);
      function To_S32 is new Ada.Unchecked_Conversion (U32, S32);
   begin
      return To_S32 (To_U32 (A) and B);
   end "and";

   -----------------------------
   -- Compute_Phase_Increment --
   -----------------------------

   function Compute_Phase_Increment (Pitch : S16) return U32 is
      Pitch_Table_Start : constant := 128 * 128;
      Octave : constant := 12 * 128;

      P : S16 := Pitch;

      Ref_Pitch : S32;
      Num_Shifts : Natural := 0;

      A, B, Phase_Increment : U32;
   begin
      if P >= Pitch_Table_Start then
         P := Pitch_Table_Start - 1;
      end if;

      Ref_Pitch := S32 (P) - Pitch_Table_Start;

      while Ref_Pitch < 0 loop
         Ref_Pitch := Ref_Pitch + Octave;
         Num_Shifts := Num_Shifts + 1;
      end loop;

      A := LUT_Oscillator_Increments (U8 (Ref_Pitch / 2**4));
      B := LUT_Oscillator_Increments (U8 (Ref_Pitch / 2**4) + 1);
      Phase_Increment  := A +
        U32 ((S32 (B - A) * (Ref_Pitch and 16#F#)) / 2**4);

      Phase_Increment := Shift_Right (Phase_Increment, Num_Shifts);

      return Phase_Increment;
   end Compute_Phase_Increment;

end Tresses.DSP;
