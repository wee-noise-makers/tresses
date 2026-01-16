with Tresses.Samples.Sample_707hh_close;
with Tresses.Samples.Sample_707hh_open;
with Tresses.Drums.Generic_Sample_Hats;

package Tresses.Drums.HH_707_Sampled
is new Tresses.Drums.Generic_Sample_Hats
  (Open_Sample => Samples.Sample_707hh_open.Sample'Access,
   Close_Sample => Samples.Sample_707hh_close.Sample'Access);
