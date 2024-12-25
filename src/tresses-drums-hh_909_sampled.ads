with Tresses.Samples.Sample_909hh_close_half_rate;
with Tresses.Samples.Sample_909hh_open_half_rate;
with Tresses.Drums.Generic_Sample_Hats_Half_Rate;

package Tresses.Drums.HH_909_Sampled
is new Tresses.Drums.Generic_Sample_Hats_Half_Rate
  (Open_Sample => Samples.Sample_909hh_open_half_rate.Sample'Access,
   Close_Sample => Samples.Sample_909hh_close_half_rate.Sample'Access);
