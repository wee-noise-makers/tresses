with Tresses.Samples.Sample_mrk2_close;
with Tresses.Samples.Sample_mrk2_open;
with Tresses.Drums.Generic_Sample_Hats;

package Tresses.Drums.HH_MRK2_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_mrk2_open.Sample'Access,
   Close_Sample => Samples.Sample_mrk2_close.Sample'Access);
