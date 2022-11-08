with Tresses.Resources;

package Tresses.DSP
with Preelaborate
is

   function Interpolate824 (T     : Resources.Table_257_U16;
                            Phase : U32)
                            return U16
     with Inline_Always;
   --  Why 824? I don't know, yet...

   function Interpolate824 (T     : Resources.Table_257_S16;
                            Phase : U32)
                            return S16
     with Inline_Always;
   --  Why 824? I don't know, yet...

   function Interpolate88 (T     : Resources.Table_257_S16;
                           Index : U16)
                           return S16
     with Inline_Always;
   --  Why 88? I don't know, yet...

   function Crossfade (Table_A, Table_B : Resources.Table_257_S16;
                       Phase            : U32;
                       Balance          : U16)
                       return S16;

   function Clip (V : S32; First, Last : S32) return S32
     with Post => Clip'Result in First .. Last;

   procedure Clip (V : in out S32; First, Last : S32)
     with Post => V in First .. Last;

   procedure Clip_S16 (V : in out S32)
     with Post => V in -32_767 .. 32_767;
   --  Clip a value to fit in a signed 16bit

   function Clip_S16 (V : S32) return S32
     with Post => Clip_S16'Result in -32_767 .. 32_767;
   --  Clip a value to fit in a signed 16bit

   function Mix (A, B, Balance : U16) return U16;

   function "and" (A : S32; B : U32) return S32;

   function Compute_Phase_Increment (Pitch : S16) return U32;

end Tresses.DSP;
