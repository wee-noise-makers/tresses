
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

   subtype Mono_Point is S16;
   type Mono_Buffer is array (Natural range <>) of Mono_Point;

end Tresses;
