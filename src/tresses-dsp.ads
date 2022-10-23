with Tresses.Lookup_Tables; use Tresses.Lookup_Tables;

package Tresses.DSP
with Preelaborate
is

   function Interpolate824 (T : Table_257_U16; Phase : U32) return U16
     with Inline_Always;
   --  Why 824? I don't know, yet...

   procedure Clip_S16 (V : in out S32)
     with Inline_Always,
     Post => V in -32_767 .. 32_767;
   --  Clip a value to fit in a signed 16bit

   function Mix (A, B, Balance : U16) return U16;

   function "and" (A : S32; B : U32) return S32;

   function Compute_Phase_Increment (Midi_Pitch : S16) return U32;

end Tresses.DSP;
