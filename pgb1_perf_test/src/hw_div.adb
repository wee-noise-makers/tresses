with RP2040_SVD.SIO;
with HAL;

with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;
with System.Machine_Code;

package body HW_Div is

   ---------
   -- "/" --
   ---------

   function DivU32 (A, B : U32) return U32 is
      use RP2040_SVD.SIO;
   begin
      SIO_Periph.DIV_UDIVIDEND := HAL.UInt32 (A);
      SIO_Periph.DIV_UDIVISOR := HAL.UInt32 (B);

      System.Machine_Code.Asm ("b _1_%=" & ASCII.LF &
                                 "_1_%=:" & ASCII.LF &
                                 "b _2_%=" & ASCII.LF &
                                 "_2_%=:" & ASCII.LF &
                                 "b _3_%=" & ASCII.LF &
                                 "_3_%=:" & ASCII.LF &
                                 "b _4_%=" & ASCII.LF &
                                 "_4_%=:",
                               Volatile => True);

      return U32 (SIO_Periph.DIV_QUOTIENT);
   end DivU32;

   -----------
   -- "mod" --
   -----------

   function ModU32 (A, B : U32) return U32 is
      use RP2040_SVD.SIO;
   begin
      SIO_Periph.DIV_UDIVIDEND := HAL.UInt32 (A);
      SIO_Periph.DIV_UDIVISOR := HAL.UInt32 (B);

      System.Machine_Code.Asm ("b _1_%=" & ASCII.LF &
                                 "_1_%=:" & ASCII.LF &
                                 "b _2_%=" & ASCII.LF &
                                 "_2_%=:" & ASCII.LF &
                                 "b _3_%=" & ASCII.LF &
                                 "_3_%=:" & ASCII.LF &
                                 "b _4_%=" & ASCII.LF &
                                 "_4_%=:",
                               Volatile => True);

      return U32 (SIO_Periph.DIV_REMAINDER);
   end ModU32;

   ---------
   -- "/" --
   ---------

   function DivS32 (A, B : S32) return S32 is
      function To_HAL_U32 is new Ada.Unchecked_Conversion (S32, HAL.UInt32);
      function From_HAL_U32 is new Ada.Unchecked_Conversion (HAL.UInt32, S32);
      use RP2040_SVD.SIO;
   begin
      SIO_Periph.DIV_SDIVIDEND := To_HAL_U32 (A);
      SIO_Periph.DIV_SDIVISOR := To_HAL_U32 (B);
      System.Machine_Code.Asm ("b _1_%=" & ASCII.LF &
                                 "_1_%=:" & ASCII.LF &
                                 "b _2_%=" & ASCII.LF &
                                 "_2_%=:" & ASCII.LF &
                                 "b _3_%=" & ASCII.LF &
                                 "_3_%=:" & ASCII.LF &
                                 "b _4_%=" & ASCII.LF &
                                 "_4_%=:",
                               Volatile => True);

      return From_HAL_U32 (SIO_Periph.DIV_QUOTIENT);
   end DivS32;

   function ModS32 (A, B : S32) return S32 is
      function To_HAL_U32 is new Ada.Unchecked_Conversion (S32, HAL.UInt32);
      function From_HAL_U32 is new Ada.Unchecked_Conversion (HAL.UInt32, S32);
      use RP2040_SVD.SIO;
   begin
      SIO_Periph.DIV_SDIVIDEND := To_HAL_U32 (A);
      SIO_Periph.DIV_SDIVISOR := To_HAL_U32 (B);
      System.Machine_Code.Asm ("b _1_%=" & ASCII.LF &
                                 "_1_%=:" & ASCII.LF &
                                 "b _2_%=" & ASCII.LF &
                                 "_2_%=:" & ASCII.LF &
                                 "b _3_%=" & ASCII.LF &
                                 "_3_%=:" & ASCII.LF &
                                 "b _4_%=" & ASCII.LF &
                                 "_4_%=:",
                               Volatile => True);

      return From_HAL_U32 (SIO_Periph.DIV_REMAINDER);

   end ModS32;

end HW_Div;
