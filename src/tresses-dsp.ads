with Tresses.Resources;

package Tresses.DSP
with Preelaborate
is

   function Interpolate824 (T     : Resources.Table_257_U16;
                            Phase : U32)
                            return U16
     with Inline_Always;
   --  Phase interpreted as 8-bit integer, 24-bit fraction

   function Interpolate824 (T     : Resources.Table_257_S16;
                            Phase : U32)
                            return S16
     with Inline_Always;
   --  Phase interpreted as 8-bit integer, 24-bit fraction

   function Interpolate88 (T     : Resources.Table_257_S16;
                           Index : U16)
                           return S16
     with Inline_Always;
   --  Phase interpreted as 8-bit integer, 8-bit fraction

   function Crossfade (Table_A, Table_B : Resources.Table_257_S16;
                       Phase            : U32;
                       Balance          : N16)
                       return S16
     with Inline_Always;

   function Clip (V : S32; First, Last : S32) return S32
     with Inline_Always;

   procedure Clip (V : in out S32; First, Last : S32)
     with Inline_Always;

   function Clip (V : S64; First, Last : S64) return S64
     with Inline_Always;

   procedure Clip (V : in out S64; First, Last : S64)
     with Inline_Always;

   procedure Clip_S16 (V : in out S32)
     with Inline_Always;
   --  Clip a value to fit in a signed 16bit

   function Clip_S16 (V : S32) return S32
     with Inline_Always;
   --  Clip a value to fit in a signed 16bit

   function Mix (A, B, Balance : U16) return U16
     with Inline_Always;
   function Mix (A, B : S16; Balance : U16) return S16
     with Inline_Always;
   function Mix (A, B : S16; Balance : Param_Range) return S16
     with Inline_Always;
   function Mix (A, B : U32; Balance : Param_Range) return U32
     with Inline_Always;

   function "and" (A : S32; B : U32) return S32
     with Inline_Always;

   function Compute_Phase_Increment (Pitch : S16) return U32
     with Linker_Section => Code_Linker_Section;

   function Tanh (X : S16) return S16
     with Inline_Always;

   function Modulate (A : Param_Range; Param : Param_Range)
                      return Param_Range;
   function Modulate (A : U16; Param : Param_Range) return U16;
   function Modulate (A : U32; Param : Param_Range) return U32;

end Tresses.DSP;
