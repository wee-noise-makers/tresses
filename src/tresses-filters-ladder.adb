with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Filters.Ladder is

   ----------------
   -- Set_Cutoff --
   ----------------

   procedure Set_Cutoff (This : in out Instance; Cutoff : Param_Range) is
   begin
      This.Cutoff := S32 (DSP.Interpolate824 (Resources.LUT_Svf_Cutoff,
                          Shift_Left (U32 (Cutoff), 17)));
   end Set_Cutoff;

   -------------------
   -- Set_Resonance --
   -------------------

   procedure Set_Resonance (This : in out Instance; Resonance : Param_Range) is
   begin
      This.Resonance := S32 (Resonance);
   end Set_Resonance;

   -------------
   -- Process --
   -------------

   function Process (This : in out Instance; Input : S32) return S32 is
      --  https://github.com/ddiakopoulos/MoogLadders/
      --    blob/master/src/MicrotrackerModel.h

      Output : S32;

      --  Coefficients (in fixed point Q0.15 format)
      C3  : constant S32 := 11826; -- 0.360891 * 2^15
      C32 : constant S32 := 13674; -- 0.417290 * 2^15
      C33 : constant S32 :=  5829; -- 0.177896 * 2^15
      C34 : constant S32 :=  1441; -- 0.0439725 * 2^15

      K : constant S32 := This.Resonance;

      function Tanh (X : S32) return S32
      is (S32 (DSP.Tanh (
          S16 (DSP.Clip (X, S32 (S16'First), S32 (S16'Last))))));
   begin
      Output := (This.P3 * C3) / 2**15;
      Output := Output + (This.P32 * C32) / 2**15;
      Output := Output + (This.P33 * C33) / 2**15;
      Output := Output + (This.P34 * C34) / 2**15;

      This.P34 := This.P33;
      This.P33 := This.P32;
      This.P32 := This.P3;

      This.P0 := This.P0 + ((Tanh (Input - ((K * Output) / 2**15))
                            - Tanh (This.P0)) * This.Cutoff) / 2**15;

      This.P1 := This.P1 +
        ((Tanh (This.P0) - Tanh (This.P1)) * This.Cutoff) / 2**15;

      This.P2 := This.P2 +
        ((Tanh (This.P1) - Tanh (This.P2)) * This.Cutoff) / 2**15;

      This.P3 := This.P3 +
        ((Tanh (This.P2) - Tanh (This.P3)) * This.Cutoff) / 2**15;

      return Output;
   end Process;

end Tresses.Filters.Ladder;
