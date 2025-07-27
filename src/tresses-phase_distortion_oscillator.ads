with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Resources;

package Tresses.Phase_Distortion_Oscillator
with Preelaborate
is
   type Instance
   is tagged record
      Pitch       : Pitch_Range := Init_Pitch;

      Shape_Env : Envelopes.AR.Instance;

      Phase      : U32 := 0;
      Phase_Increment : U32 := 1;
      Prev_Phase_Increment : U32 := 1;
   end record;

   procedure Init (This          : in out Instance;
                   Release_Curve :        Curve         := Exponential;
                   Release_Speed :        Segment_Speed := S_2_Seconds)
     with Linker_Section => Code_Linker_Section;

   procedure Trigger (This     : in out Instance;
                      Velocity :        Param_Range)
     with Linker_Section => Code_Linker_Section;

   generic
      Waveform : not null access constant Tresses.Resources.Table_257_S16;
      with
        function Phase_Distort (Phase : U32; Amount : Param_Range) return U32;
   procedure Render (This    : in out Instance;
                     Buffer  :    out Mono_Buffer;
                     Amount  :        Param_Range;
                     Release :        Param_Range);

   generic
      Waveform : not null access constant Tresses.Resources.Table_257_S16;
   procedure Render_Resonance (This    : in out Instance;
                               Buffer  :    out Mono_Buffer;
                               Amount  :        Param_Range;
                               Release :        Param_Range);

   generic
      Waveform : not null access constant Tresses.Resources.Table_257_S16;
   procedure Render_Resonance_2 (This    : in out Instance;
                                 Buffer  :    out Mono_Buffer;
                                 Amount  :        Param_Range;
                                 Release :        Param_Range);

   procedure Set_Pitch (This : in out Instance; P : Pitch_Range)
     with Linker_Section => Code_Linker_Section;

   generic
      Lookup_Table : not null access constant Tresses.Resources.Table_257_S16;
   function Phase_Distort_Lookup (Phase : U32; Amount : Param_Range)
                                  return U32;

end Tresses.Phase_Distortion_Oscillator;
