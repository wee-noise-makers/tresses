package Tresses.Random
with Preelaborate
is

   type Instance is private;

   procedure Seed (This : in out Instance; Seed : U32);

   function Get_Word (This : in out Instance) return U32;

   function Get_Sample (This : in out Instance) return S16;

   function Get_Float (This : in out Instance) return Float;

private

   type Instance is record
      State : U32 := 16#21#;
   end record;

end Tresses.Random;
