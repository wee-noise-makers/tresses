package Tresses.LFO
with Preelaborate
is

   type Shape_Kind is (Sine);

   type Instance
   is tagged record
      Shape       : Shape_Kind := Shape_Kind'First;
      Prev_Shape  : Shape_Kind := Shape_Kind'Last;

      Rate : Param_Range := Param_Range'Last / 2;
      Amplitude : Param_Range := Param_Range'Last / 2;

      Phase      : U32 := 0;
      Phase_Increment : U32 := 1;
   end record;

   procedure Init (This : in out Instance);

   procedure Sync (This : in out Instance);

   procedure Set_Shape (This : in out Instance; S : Shape_Kind);

   procedure Set_Rate (This  : in out Instance;
                       R     : Param_Range;
                       Scale : U32 := 1);

   procedure Set_Amplitude (This : in out Instance; A : Param_Range);

   function Render (This : in out Instance) return Param_Range;

end Tresses.LFO;
