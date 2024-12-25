with RP.Multicore;

package body Core_1_Utils is

   -----------
   -- Start --
   -----------

   procedure Start (Entry_Point : HAL.UInt32) is
   begin
      RP.Multicore.Launch_Core1 (Trap_Vector, Stack_Pointer, Entry_Point);
   end Start;

end Core_1_Utils;
