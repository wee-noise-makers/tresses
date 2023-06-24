--
--  SPDX-License-Identifier: MIT
--
--  Based on Clouds from Mutable Instruments:
--  Copyright 2014 Emilie Gillet.

with Tresses.DSP;

package body Tresses.FX.Reverb is

   type Context is tagged record
      Accumulator : S16 := 0;
      Prev_Read : S16 := 0;
      Write_Ptr : U16 := 0;
   end record;

   procedure Load (This : in out Context; Value : S16) is
   begin
      This.Accumulator := Value;
   end Load;

   procedure Read (This : in out Context; Value : S16; Gain : S16) is
   begin
      This.Accumulator := This.Accumulator +
        S16 ((S32 (Value) * S32 (Gain) / 2**15));
   end Read;

   procedure Read_Offset (This : in out Context;
                          Buffer : Reverb_Buffer;
                          Offset : U16;
                          Scale : S16)
   is
      Index : constant U16 := (This.Write_Ptr + Offset) mod Buffer'Length;
      Acc : S32;
   begin
      This.Prev_Read := Buffer (Index);

      Acc := S32 (This.Accumulator);

      Acc := Acc + (S32 (This.Prev_Read) * S32 (Scale) / 2**15);

      This.Accumulator := S16 (DSP.Clip_S16 (Acc));
   end Read_Offset;

   procedure Write (This : Context; Value : out S16) is
   begin
      Value := This.Accumulator;
   end Write;

   procedure Write_Scale (This : in out Context; Value : out S16; Scale : S16)
   is
   begin
      Value := This.Accumulator;
      This.Accumulator :=
        S16 ((S32 (This.Accumulator) * S32 (Scale)) / 2**15);
   end Write_Scale;

   procedure Write_All_Pass (This   : in out Context;
                             Buffer : in out Reverb_Buffer;
                             Offset :        U16;
                             Scale  :        S16)
   is
      Index : constant U16 :=
        (This.Write_Ptr + Offset) mod Buffer'Length;
      Acc : S32;
   begin
      Buffer (Index) := This.Accumulator;

      Acc := (S32 (This.Accumulator) * S32 (Scale)) / 2**15;
      Acc := Acc + S32 (This.Prev_Read);

      This.Accumulator := S16 (DSP.Clip_S16 (Acc));
   end Write_All_Pass;

   procedure Write_Double (This   : in out Context;
                           Buffer : in out Reverb_Buffer;
                           Offset :        U16)
   is
      Index : constant U16 :=
        (This.Write_Ptr + Offset) mod Buffer'Length;
   begin
      Buffer (Index) := This.Accumulator;

      This.Accumulator := S16 (DSP.Clip_S16 (S32 (This.Accumulator) * 2));
   end Write_Double;

   procedure LP (This : in out Context;
                 State : in out S16;
                 Coef : S16)
   is
   begin
      State := State +
        S16 ((S32 (Coef) * S32 (This.Accumulator - State)) / 2**15);

      This.Accumulator := State;
   end LP;

   procedure Start (This   : in out Instance;
                    C      : in out Context)
   is
   begin
      This.Write_Ptr := This.Write_Ptr - 1;
      if This.Write_Ptr < 0 then
         This.Write_Ptr := This.Write_Ptr + This.Buffer'Length;
      end if;

      C.Accumulator := 0;
      C.Prev_Read := 0;
      C.Write_Ptr := U16 (This.Write_Ptr);
   end Start;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Instance) is
   begin
      This.Buffer := (others => 0);
   end Reset;

   ----------------
   -- Set_Amount --
   ----------------

   procedure Set_Amount (This : in out Instance; V : Param_Range) is
   begin
      This.Amount := V;
   end Set_Amount;

   --------------
   -- Set_Gain --
   --------------

   procedure Set_Gain (This : in out Instance; V : Param_Range) is
   begin
      This.Input_Gain := V;
   end Set_Gain;

   --------------
   -- Set_Time --
   --------------

   procedure Set_Time (This : in out Instance; V : Param_Range) is
   begin
      This.Reverb_Time := V;
   end Set_Time;

   -------------------
   -- Set_Diffusion --
   -------------------

   procedure Set_Diffusion (This : in out Instance; V : Param_Range) is
   begin
      This.Diffusion := V;
   end Set_Diffusion;

   ------------------
   -- Set_Low_Pass --
   ------------------

   procedure Set_Low_Pass (This : in out Instance; V : Param_Range) is
   begin
      This.LP := V;
   end Set_Low_Pass;

   -------------
   -- Process --
   -------------

   procedure Process (This  : in out Instance;
                      Left  : in out Mono_Buffer;
                      Right : in out Mono_Buffer)
   is

      C : Context;

      Kap    : constant S16 := S16 (This.Diffusion);
      Klp    : constant S16 := S16 (This.LP);
      Krt    : constant S16 := S16 (This.Reverb_Time);
      Amount : constant S16 := S16 (This.Amount);
      Gain   : constant S16 := S16 (This.Input_Gain);

      LP1 : S16 renames This.LP_Decay_1;
      LP2 : S16 renames This.LP_Decay_1;

   begin

      --  This implementation is based on reverb.h from the eurorack
      --  repository of Mutable instruments:
      --  https://github.com/pichenettes/eurorack/blob/
      --      master/clouds/dsp/fx/reverb.h
      --
      --  Itself based on the 1997 paper "Effect Design: Part
      --  1: Reverberator and Other Filters" by Jon Dattorro:
      --  https://ccrma.stanford.edu/~dattorro/EffectDesignPart1.pdf
      --
      --  Compared to the MI's version this reverb doesn't have LFOs.

      for Index in Left'Range loop
         declare
            Wet : S16 := 0;
            Apout : S16 := 0;
            L : S16 renames Left (Index);
            R : S16 renames Right (Index);
         begin
            Start (This, C);

            C.Read (S16 (DSP.Clip_S16 (S32 (L) + S32 (R))), Gain);

            --  Diffuse through 4 allpasses
            C.Read_Offset (This.Buffer, Ap1_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Ap1_Base, -Kap);

            C.Read_Offset (This.Buffer, Ap2_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Ap2_Base, -Kap);

            C.Read_Offset (This.Buffer, Ap3_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Ap3_Base, -Kap);

            C.Read_Offset (This.Buffer, Ap4_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Ap4_Base, -Kap);

            C.Write (Apout);

            --  Left: 2 allpasses + Delay
            C.Load (Apout);

            C.LP (LP1, Klp);
            C.Read_Offset (This.Buffer, Del2_Tail, Krt);

            C.Read_Offset (This.Buffer, Dap1a_Tail, -Kap);
            C.Write_All_Pass (This.Buffer, Dap1a_Base, Kap);
            C.Read_Offset (This.Buffer, Dap1b_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Dap1b_Base, -Kap);
            C.Write_Double (This.Buffer, Del1_Base);
            C.Write_Scale (Wet, 0);

            L := L +
              S16 (DSP.Clip_S16 ((S32 (Wet - L) * S32 (Amount)) / 2**15));

            --  Right: 2 allpasses + Delay
            C.Load (Apout);

            C.LP (LP2, Klp);
            C.Read_Offset (This.Buffer, Del1_Tail, Krt);

            C.Read_Offset (This.Buffer, Dap2a_Tail, Kap);
            C.Write_All_Pass (This.Buffer, Dap2a_Base, -Kap);
            C.Read_Offset (This.Buffer, Dap2b_Tail, -Kap);
            C.Write_All_Pass (This.Buffer, Dap2b_Base, Kap);
            C.Write_Double (This.Buffer, Del2_Base);
            C.Write_Scale (Wet, 0);

            R := R +
              S16 (DSP.Clip_S16 ((S32 (Wet - R) * S32 (Amount)) / 2**15));
         end;
      end loop;
   end Process;

end Tresses.FX.Reverb;
