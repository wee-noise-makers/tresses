
--  State Variable Filter

package Tresses.Filters.SVF
with Preelaborate
is

   type Mode_Kind is (Low_Pass, Band_Pass, High_Pass);

   type Instance is private;

   procedure Init (This : in out Instance);
   procedure Set_Frequency (This : in out Instance; Frequency : S16);
   procedure Set_Resonance (This : in out Instance; Resonance : S16);
   procedure Set_Punch (This : in out Instance; Punch : U16);
   procedure Set_Mode (This : in out Instance; Mode : Mode_Kind);

   function Process (This : in out Instance; Input : S32) return S32;

private

   type Instance is record
      Dirty : Boolean := True;
      Frequency : S16 := 33 * 2**7;
      Resonance : S16 := 16384;
      Punch : S32 := 0;
      F : S32 := 0;
      Damp : S32 := 0;
      LP : S32 := 0;
      BP : S32 := 0;
      Mode : Mode_Kind := Band_Pass;
   end record;

end Tresses.Filters.SVF;
