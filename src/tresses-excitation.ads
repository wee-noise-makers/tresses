
package Tresses.Excitation
with Preelaborate
is

   type Instance is private;

   procedure Init (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Delay (This : in out Instance; Delayy : U16)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Decay (This : in out Instance; Decay : U16)
     with Linker_Section => Code_Linker_Section;

   procedure Trigger (This : in out Instance; Level : S32)
     with Linker_Section => Code_Linker_Section;

   function Done (This : Instance) return Boolean
     with Linker_Section => Code_Linker_Section;

   function Process (This : in out Instance) return S32
     with Linker_Section => Code_Linker_Section;

private

   type Instance is record
      Delayy : U32 := 0;
      Decay  : U32 := 4093;
      Counter : S32 := 0;
      State : S32 := 0;
      Level : S32 := 0;
   end record;

end Tresses.Excitation;
