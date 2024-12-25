with HAL;
with System.Storage_Elements;

package Core_1_Utils is

   procedure Start (Entry_Point : HAL.UInt32);

private

   Scartch_X_Size  : constant := 4 * 1024;
   Scartch_X_Start : constant := 16#20040000#;
   Scartch_X_End   : constant := Scartch_X_Start + Scartch_X_Size;

   Vector : Integer;
   pragma Import (C, Vector, "__vectors");

   -----------------
   -- Trap_Vector --
   -----------------

   function Trap_Vector return HAL.UInt32
   is (HAL.UInt32 (System.Storage_Elements.To_Integer (Vector'Address)));

   -------------------
   -- Stack_Pointer --
   -------------------

   function Stack_Pointer return HAL.UInt32
   is (Scartch_X_End);

end Core_1_Utils;
