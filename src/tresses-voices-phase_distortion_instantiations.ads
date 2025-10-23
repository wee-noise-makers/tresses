with Tresses.Voices.Phase_Distortion;
with Tresses.Phase_Distortion_Oscillator;
with Tresses.Resources;

package Tresses.Voices.Phase_Distortion_Instantiations
with Preelaborate
is

   package PDO renames Tresses.Phase_Distortion_Oscillator;
   package PDV renames Tresses.Voices.Phase_Distortion;

   --  Various instantiations of Phase Distortion voices --

   procedure Render_Reso is new PDV.Render (PDO.Render_Resonance)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Reso_Full is new PDV.Render (PDO.Render_Resonance_2)
     with Linker_Section => Code_Linker_Section;

   -- Lookup Triangle Sine2_Warp3  --
   function Phase_Distort_Sine2_Warp3
   is new PDO.Phase_Distort_Lookup (Resources.WAV_Sine2_Warp3'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Osc_Render_Lookup_Sine2_Warp3
   is new PDO.Render (Phase_Distort_Sine2_Warp3)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Lookup_Sine2_Warp3
   is new PDV.Render (Osc_Render_Lookup_Sine2_Warp3)
     with Linker_Section => Code_Linker_Section;

   -- Lookup Sine Screech  --
   function Phase_Distort_Screech
   is new PDO.Phase_Distort_Lookup (Resources.WAV_Screech'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Osc_Render_Lookup_Screech
   is new PDO.Render (Phase_Distort_Screech)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Lookup_Screech
   is new PDV.Render (Osc_Render_Lookup_Screech)
     with Linker_Section => Code_Linker_Section;


end Tresses.Voices.Phase_Distortion_Instantiations;
