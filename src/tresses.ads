
with Interfaces;

pragma Warnings (Off, "has no effect");
use Interfaces;
pragma Warnings (On, "has no effect");

package Tresses
with Preelaborate
is

   subtype U8 is Interfaces.Unsigned_8;
   subtype U16 is Interfaces.Unsigned_16;
   subtype U32 is Interfaces.Unsigned_32;

   type U7 is mod 2**7 with Size => 7;

   subtype S8 is Interfaces.Integer_8;
   subtype S16 is Interfaces.Integer_16;
   subtype S32 is Interfaces.Integer_32;

   type Param_Range is new S16 range 0 .. S16'Last;

   subtype Mono_Point is S16;
   type Mono_Buffer is array (Natural range <>) of Mono_Point;


   type Engines is (Drum_Kick,
                    Drum_Snare,
                    Drum_Cymbal,

                    Voice_Plucked,
                    Voice_Saw_Swarm);

   subtype Drum_Engines is Engines range Drum_Kick .. Drum_Cymbal;
   subtype Synth_Engines is Engines range Voice_Plucked .. Voice_Saw_Swarm;

end Tresses;
