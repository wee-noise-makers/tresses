--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Ada.Unchecked_Conversion;

package body Tresses.Random is

   function To_S16 is new Ada.Unchecked_Conversion (U16, S16);

   ----------
   -- Seed --
   ----------

   procedure Seed (This : in out Instance; Seed : U32) is
   begin
      This.State := Seed;
   end Seed;

   --------------
   -- Get_Word --
   --------------

   function Get_Word (This : in out Instance) return U32 is
   begin
      This.State := This.State * 1_664_525 + 1_013_904_223;
      return This.State;
   end Get_Word;

   ----------------
   -- Get_Sample --
   ----------------

   function Get_Sample (This : in out Instance) return S16 is
   begin
      return To_S16 (U16 (Shift_Right (Get_Word (This), 16)));
   end Get_Sample;

   ---------------
   -- Get_Float --
   ---------------

   function Get_Float (This : in out Instance) return Float is
   begin
      return Float (Get_Word (This)) / 4_294_967_296.0;
   end Get_Float;

end Tresses.Random;
