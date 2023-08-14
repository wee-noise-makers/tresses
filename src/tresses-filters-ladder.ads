package Tresses.Filters.Ladder
with Preelaborate
is

   type Instance is private;

   procedure Set_Cutoff (This : in out Instance; Cutoff : Param_Range)
     with Linker_Section => Code_Linker_Section;
   procedure Set_Resonance (This : in out Instance; Resonance : Param_Range)
     with Linker_Section => Code_Linker_Section;

   function Process (This : in out Instance; Input : S32) return S32
     with Linker_Section => Code_Linker_Section;

private

   type Instance is record
      Resonance : S32 := 0;
      Cutoff : S32 := 1;
      P0, P1, P2, P3, P32, P33, P34 : S32 := 0;
   end record;

end Tresses.Filters.Ladder;
