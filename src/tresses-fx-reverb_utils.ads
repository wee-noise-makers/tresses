with Tresses.FX.Reverb;

package Tresses.FX.Reverb_Utils
with Preelaborate
is
   type S12 is range -2 ** 11 .. 2 ** 11 - 1;
   for S12'Size use 12;

   type S10 is range -2 ** 9 .. 2 ** 9 - 1;
   for S10'Size use 10;

   package Reverb_12 is new Tresses.FX.Reverb (Compressed_Sample => S12);
   package Reverb_10 is new Tresses.FX.Reverb (Compressed_Sample => S10);
end Tresses.FX.Reverb_Utils;
