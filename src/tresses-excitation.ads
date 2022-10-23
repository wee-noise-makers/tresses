
package Tresses.Excitation
with Preelaborate
is

   type Instance is private;

   procedure Init (This : in out Instance);

   procedure Set_Delay (This : in out Instance; Delayy : U16);

   procedure Set_Decay (This : in out Instance; Decay : U16);

   procedure Trigger (This : in out Instance; Level : S32);

   function Done (This : Instance) return Boolean;

   function Process (This : in out Instance) return S32;

private

   type Instance is record
      Delayy : U32 := 0;
      Decay  : U32 := 4093;
      Counter : S32 := 0;
      State : S32 := 0;
      Level : S32 := 0;
   end record;

end Tresses.Excitation;
