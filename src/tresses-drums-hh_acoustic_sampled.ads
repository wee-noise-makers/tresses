with Tresses.Samples.Sample_acoustic_close;
with Tresses.Samples.Sample_acoustic_open;
with Tresses.Drums.Generic_Sample_Hats;

package Tresses.Drums.HH_Acoustic_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_acoustic_open.Sample'Access,
   Close_Sample => Samples.Sample_acoustic_close.Sample'Access);
