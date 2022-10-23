package Tresses.Envelopes.AD
with Preelaborate
is
   type Segment_Kind is (Attack, Decay, Dead);

   type Instance is private;

   procedure Set_Attack (This : in out Instance; A : U7);
   procedure Set_Decay (This : in out Instance; D : U7);

   procedure Trigger (This : in out Instance; Seg : Segment_Kind);

   function Current_Segment (This : Instance) return Segment_Kind;
   function Render (This : in out Instance) return U16;

   function Value (This : Instance) return U16;

private

   type Incr_Array is array (Segment_Kind) of U32;
   type Target_Array is array (Segment_Kind) of U16;

   type Instance is record
      Increment : Incr_Array := (others => 0);
      Target : Target_Array := (Attack => 65_535, Decay => 0, Dead => 0);
      Segement : Segment_Kind := Segment_Kind'First;
      A, B, Value : U16 := 0;
      Phase : U32 := 0;
   end record;

end Tresses.Envelopes.AD;
