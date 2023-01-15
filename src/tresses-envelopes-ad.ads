with Tresses.Resources;

package Tresses.Envelopes.AD
with Preelaborate
is
   type Segment_Kind is (Attack, Hold, Decay, Dead);

   type Instance is private;

   procedure Init (This    : in out Instance;
                   Do_Hold :        Boolean);

   procedure Set_Attack (This : in out Instance; A : U7);
   procedure Set_Decay (This : in out Instance; D : U7);

   procedure Set_Attack (This : in out Instance; A : Param_Range);
   procedure Set_Decay (This : in out Instance; D : Param_Range);

   procedure On (This : in out Instance; Velocity : Param_Range);
   procedure Off (This : in out Instance);

   procedure Trigger (This : in out Instance; Seg : Segment_Kind);

   function Current_Segment (This : Instance) return Segment_Kind;
   function Render (This : in out Instance) return U16;
   procedure Render (This : in out Instance);

   function Value (This : Instance) return U16;
   function Low_Pass (This : in out Instance) return S32;

private

   type Incr_Array is array (Segment_Kind) of U32;
   type Target_Array is array (Segment_Kind) of U16;

   type Instance is record
      Increment : Incr_Array :=
        (Attack =>
           Resources.LUT_Env_Portamento_Increments (U8 (U7'First)),
         Decay =>
           Resources.LUT_Env_Portamento_Increments (U8 (U7'Last)),
         others => 0);
      Target : Target_Array := (Attack => U16 (S16'Last),
                                Hold   => U16 (S16'Last),
                                Decay  => 0,
                                Dead   => 0);
      Segement : Segment_Kind := Segment_Kind'First;
      Do_Hold : Boolean := False;
      A, B, Value : U16 := 0;
      LP : S32 := 0;
      Phase : U32 := 0;
   end record;

end Tresses.Envelopes.AD;
