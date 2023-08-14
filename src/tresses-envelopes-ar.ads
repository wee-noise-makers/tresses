with Tresses.Resources;

package Tresses.Envelopes.AR
with Preelaborate
is
   type Segment_Kind is (Attack, Hold, Release, Dead);

   type Instance is private;

   procedure Init (This    : in out Instance;
                   Do_Hold :        Boolean)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Attack (This : in out Instance; A : U7)
     with Linker_Section => Code_Linker_Section;
   procedure Set_Release (This : in out Instance; R : U7)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Attack (This : in out Instance; A : Param_Range)
     with Linker_Section => Code_Linker_Section;
   procedure Set_Release (This : in out Instance; R : Param_Range)
     with Linker_Section => Code_Linker_Section;

   procedure On (This : in out Instance; Velocity : Param_Range)
     with Linker_Section => Code_Linker_Section;
   procedure Off (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Trigger (This : in out Instance; Seg : Segment_Kind)
     with Linker_Section => Code_Linker_Section;

   function Current_Segment (This : Instance) return Segment_Kind
     with Linker_Section => Code_Linker_Section;
   function Render (This : in out Instance) return U16
     with Linker_Section => Code_Linker_Section;
   procedure Render (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   function Value (This : Instance) return U16
     with Inline_Always;
   function Low_Pass (This : in out Instance) return S32
     with Inline_Always;

private

   type Incr_Array is array (Segment_Kind) of U32;
   type Target_Array is array (Segment_Kind) of U16;

   type Instance is record
      Increment : Incr_Array :=
        (Attack =>
           Resources.LUT_Env_Portamento_Increments (U8 (U7'First)),
         Release =>
           Resources.LUT_Env_Portamento_Increments (U8 (U7'Last)),
         others => 0);
      Target : Target_Array := (Attack => U16 (S16'Last),
                                Hold   => U16 (S16'Last),
                                Release  => 0,
                                Dead   => 0);
      Segement : Segment_Kind := Segment_Kind'First;
      Do_Hold : Boolean := False;
      A, B, Value : U16 := 0;
      LP : S32 := 0;
      Phase : U32 := 0;
   end record;

end Tresses.Envelopes.AR;
