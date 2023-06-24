--
--  SPDX-License-Identifier: MIT
--
--  Based on Clouds from Mutable Instruments:
--  Copyright 2014 Emilie Gillet.

with Tresses.Resources;

generic
   --  Size of each delay line in number of samples. The default value are
   --  based on the Mutable Instruments constants and adapted for the sample
   --  rate.
   --
   --  MI_Len : Length of delay in Mutable Instruments' implementation
   --  MI_SR  : Sample rate of Mutable Instruments's implementation
   --  TS_SR  : Tresses sample rate
   --
   --  Lenght = (MI_Len / MI_SR) * TS_SR
   --
   --  E.g: (113 / 32_000) * 44_100 ~= 156
   --  https://github.com/pichenettes/eurorack/blob/
   --      master/clouds/dsp/fx/reverb.h#L56
   --
   --  The total delay line samples in MI is 16375. At 44.1kHz sample rate
   --  that means: (16375 / 32_000) * 44_100 ~= 22567 sample -> 45_134 Bytes
   --  of memory footprint for the reverb.

   --  4 x All-Pass
   Ap1_Len   : U16 := U16 ((113.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Ap2_Len   : U16 := U16 ((162.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Ap3_Len   : U16 := U16 ((241.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Ap4_Len   : U16 := U16 ((399.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);

   --  2 x (2 x All-Pass + Delay)
   Dap1a_Len : U16 := U16 ((1653.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Dap1b_Len : U16 := U16 ((2038.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Del1_Len  : U16 := U16 ((3411.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);

   Dap2a_Len : U16 := U16 ((1913.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Dap2b_Len : U16 := U16 ((1663.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
   Del2_Len  : U16 := U16 ((4782.0 / 32_000.0) * Resources.SAMPLE_RATE_REAL);
package Tresses.FX.Reverb
with Preelaborate
is

   type Instance is private;

   procedure Reset (This : in out Instance);

   procedure Set_Amount (This : in out Instance; V : Param_Range);
   procedure Set_Gain (This : in out Instance; V : Param_Range);
   procedure Set_Time (This : in out Instance; V : Param_Range);
   procedure Set_Diffusion (This : in out Instance; V : Param_Range);
   procedure Set_Low_Pass (This : in out Instance; V : Param_Range);

   procedure Process (This  : in out Instance;
                      Left  : in out Mono_Buffer;
                      Right : in out Mono_Buffer);

private

   --  Indexes for the first and last element of each delay line
   Ap1_Base   : constant U16 := 0;
   Ap1_Tail   : constant U16 := Ap1_Base + Ap1_Len - 1;

   Ap2_Base   : constant U16 := Ap1_Tail + 1;
   Ap2_Tail   : constant U16 := Ap2_Base + Ap2_Len - 1;

   Ap3_Base   : constant U16 := Ap2_Tail + 1;
   Ap3_Tail   : constant U16 := Ap3_Base + Ap3_Len - 1;

   Ap4_Base   : constant U16 := Ap3_Tail + 1;
   Ap4_Tail   : constant U16 := Ap4_Base + Ap4_Len - 1;

   Dap1a_Base : constant U16 := Ap4_Tail + 1;
   Dap1a_Tail : constant U16 := Dap1a_Base + Dap1a_Len - 1;

   Dap1b_Base : constant U16 := Dap1a_Tail + 1;
   Dap1b_Tail : constant U16 := Dap1b_Base + Dap1b_Len - 1;

   Del1_Base  : constant U16 := Dap1b_Tail + 1;
   Del1_Tail  : constant U16 := Del1_Base + Del1_Len - 1;

   Dap2a_Base : constant U16 := Del1_Tail + 1;
   Dap2a_Tail : constant U16 := Dap2a_Base + Dap2a_Len - 1;

   Dap2b_Base : constant U16 := Dap2a_Tail + 1;
   Dap2b_Tail : constant U16 := Dap2b_Base + Dap2b_Len - 1;

   Del2_Base  : constant U16 := Dap2b_Tail + 1;
   Del2_Tail  : constant U16 := Del2_Base + Del2_Len - 1;

   Buffer_Size : constant U16 := Del2_Tail + 1;

   type Reverb_Buffer is array (0 .. Buffer_Size - 1) of S16;

   type Instance
   is record
      Buffer : Reverb_Buffer;

      Amount : Param_Range      := Param_Range (0.54 * 32_767.0);
      Input_Gain : Param_Range  := Param_Range (0.2 * 32_767.0);
      Reverb_Time : Param_Range := Param_Range (0.35 * 32_767.0);
      Diffusion : Param_Range   := Param_Range (0.7 * 32_767.0);
      LP : Param_Range          := Param_Range ((0.6 + 0.37) * 32_767.0);
      LP_Decay_1 : S16 := 0;
      LP_Decay_2 : S16 := 0;

      Write_Ptr : S16 := 0;

   end record;

end Tresses.FX.Reverb;
