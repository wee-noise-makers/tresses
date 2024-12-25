with Tresses.Resources;

package Tresses.Envelopes.AR
with Preelaborate
is
   type Segment_Kind is (Attack, Hold, Release, Dead);

   type Segment_Speed is (S_10_Seconds, S_5_Seconds,
                          S_2_Seconds, S_1_Seconds,
                          S_Half_Second,
                          S_Quarter_Second);

   type Curve is (Exponential, Linear, Logarithmic);

   type Instance is private;

   procedure Init (This          : in out Instance;
                   Do_Hold       :        Boolean;
                   Attack_Curve  : Curve         := Logarithmic;
                   Attack_Speed  : Segment_Speed := S_5_Seconds;
                   Release_Curve : Curve         := Exponential;
                   Release_Speed : Segment_Speed := S_10_Seconds)
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
   function LoFi (This : Instance) return U16
     with Inline_Always;

private

   type LUT_Access is access constant Resources.Table_257_U16;

   type Incr_Array is array (Segment_Kind) of U32;
   type Target_Array is array (Segment_Kind) of U16;
   type LUT_Array is array (Segment_Kind) of LUT_Access;

   type Instance is record
      Increment : Incr_Array :=
        (Attack =>
           Resources.LUT_Env_Increments_10seconds (U8 (U7'First)),
         Release =>
           Resources.LUT_Env_Increments_10seconds (U8 (U7'Last)),
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

      LUT_Arr : LUT_Array := (others => Resources.LUT_Env_Expo'Access);
      LUT : LUT_Access := Resources.LUT_Env_Expo'Access;

      Attack_Speed  : Segment_Speed := S_5_Seconds;
      Release_Speed : Segment_Speed := S_10_Seconds;
   end record;

end Tresses.Envelopes.AR;
