with Tresses.Samples.Sample_cr78_close;
with Tresses.Samples.Sample_cr78_open;
with Tresses.Drums.Generic_Sample_Hats;

package Tresses.Drums.HH_CR78_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_cr78_open.Sample'Access,
   Close_Sample => Samples.Sample_cr78_close.Sample'Access);
