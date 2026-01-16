with Tresses.Samples.Sample_808_close;
with Tresses.Samples.Sample_808_open;
with Tresses.Drums.Generic_Sample_Hats;
with Tresses.Filters.SVF;


package Tresses.Drums.HH_808_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_808_open.Sample'Access,
   Close_Sample => Samples.Sample_808_close.Sample'Access);
