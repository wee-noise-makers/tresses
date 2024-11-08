with Tresses.Voices.Phase_Distortion;
with Tresses.Phase_Distortion_Oscillator;
with Tresses.Resources;

package Tresses.Voices.Phase_Distortion_Instantiations
with Preelaborate
is

   package PDO renames Tresses.Phase_Distortion_Oscillator;
   package PDV renames Tresses.Voices.Phase_Distortion;

   --  Various instantiations of Phase Distortion voices --

   -- Reso Sine --
   procedure Osc_Render_Reso_Sine
   is new PDO.Render_Resonance (Resources.WAV_Sine'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Reso_Sine is new PDV.Render (Osc_Render_Reso_Sine)
     with Linker_Section => Code_Linker_Section;

   -- Reso Triangle --
   procedure Osc_Render_Reso_Triangle
   is new PDO.Render_Resonance (Resources.WAV_Triangle'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Reso_Triangle is new PDV.Render (Osc_Render_Reso_Triangle)
     with Linker_Section => Code_Linker_Section;

   -- Reso Combined Sine Square  --
   procedure Osc_Render_Reso_Combined_Sine_Square
   is new PDO.Render_Resonance (Resources.WAV_Combined_Sin_Square'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Reso_Sine_Square
   is new PDV.Render (Osc_Render_Reso_Combined_Sine_Square)
     with Linker_Section => Code_Linker_Section;

   -- Reso Combined Square Sine  --
   procedure Osc_Render_Reso_Combined_Square_Sine
   is new PDO.Render_Resonance (Resources.WAV_Combined_Square_Sin'Access)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Reso_Square_Sine
   is new PDV.Render (Osc_Render_Reso_Combined_Square_Sine)
     with Linker_Section => Code_Linker_Section;

   -- Lookup Triangle Sine2_Warp3  --
   function Phase_Distort_Sine2_Warp3
   is new PDO.Phase_Distort_Lookup (Resources.WAV_Sine2_Warp3'Access);

   procedure Osc_Render_Lookup_Triangle_Sine2_Warp3
   is new PDO.Render (Resources.WAV_Triangle'Access,
                      Phase_Distort_Sine2_Warp3)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Lookup_Triangle_Sine2_Warp3
   is new PDV.Render (Osc_Render_Lookup_Triangle_Sine2_Warp3)
     with Linker_Section => Code_Linker_Section;

   -- Lookup Sine Screech  --
   function Phase_Distort_Screech
   is new PDO.Phase_Distort_Lookup (Resources.WAV_Screech'Access);

   procedure Osc_Render_Lookup_Sine_Screech
   is new PDO.Render (Resources.WAV_Triangle'Access,
                      Phase_Distort_Screech)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Lookup_Sine_Screech
   is new PDV.Render (Osc_Render_Lookup_Sine_Screech)
     with Linker_Section => Code_Linker_Section;

end Tresses.Voices.Phase_Distortion_Instantiations;
