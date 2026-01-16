with Tresses.Samples.Sample_505_close;
with Tresses.Samples.Sample_505_open;
with Tresses.Drums.Generic_Sample_Hats;

package Tresses.Drums.HH_505_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_505_open.Sample'Access,
   Close_Sample => Samples.Sample_505_close.Sample'Access);
