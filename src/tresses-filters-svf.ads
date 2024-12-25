
--  State Variable Filter

package Tresses.Filters.SVF
with Preelaborate
is

   type Mode_Kind is (Low_Pass, Band_Pass, High_Pass);

   type Instance is private;

   procedure Init (This : in out Instance)
     with Inline_Always;
   procedure Set_Frequency (This : in out Instance; Frequency : Param_Range)
     with Inline_Always;
   procedure Set_Resonance (This : in out Instance; Resonance : Param_Range)
     with Inline_Always;
   procedure Set_Punch (This : in out Instance; Punch : U16)
     with Inline_Always;
   procedure Set_Mode (This : in out Instance; Mode : Mode_Kind)
     with Inline_Always;

   function Process (This : in out Instance; Input : S32) return S32
     with Inline_Always;

private

   type Instance is record
      Dirty : Boolean := True;
      Frequency : Param_Range := 33 * 2**7;
      Resonance : Param_Range := 16384;
      Punch : S32 := 0;
      F : S32 := 0;
      Damp : S32 := 0;
      LP : S32 := 0;
      BP : S32 := 0;
      Mode : Mode_Kind := Band_Pass;
   end record;

end Tresses.Filters.SVF;
