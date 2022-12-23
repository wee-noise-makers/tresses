package Tresses.Filters.Ladder
with Preelaborate
is

   type Instance is private;

   procedure Set_Cutoff (This : in out Instance; Cutoff : Param_Range);
   procedure Set_Resonance (This : in out Instance; Resonance : Param_Range);

   function Process (This : in out Instance; Input : S32) return S32;

private

   type Instance is record
      Resonance : S32 := 0;
      Cutoff : S32 := 1;
      P0, P1, P2, P3, P32, P33, P34 : S32 := 0;
   end record;

end Tresses.Filters.Ladder;
