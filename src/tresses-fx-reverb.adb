with Tresses.DSP;

package body Tresses.FX.Reverb is

   type DL is record
      Base : U16;
      Len  : U16;
   end record;

   type Context is tagged record
      Accumulator : S16 := 0;
      Prev_Read : S16 := 0;
      LFO_Value_1 : S16 := 0;
      LFO_Value_2 : S16 := 0;
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

   procedure Read_Tail (This : in out Context;
                        Buffer : Delay_Buffer;
                        D : DL;
                        Scale : S16)
   is
      Index : constant U16 :=
        (This.Write_Ptr + D.Base + D.Len - 1) mod Buffer'Length;
   begin
      This.Prev_Read := Buffer (Index);

      This.Accumulator := This.Accumulator +
        S16 ((S32 (This.Prev_Read) * S32 (Scale) / 2**15));
   end Read_Tail;

   procedure Write (This : Context; Value : out S16) is
   begin
      Value := This.Accumulator;
   end Write;

   procedure Write_Scale (This : in out Context; Value : out S16; Scale : S16) is
   begin
      Value := This.Accumulator;
      This.Accumulator :=
        S16 ((S32 (This.Accumulator) * S32 (Scale)) / 2**15);
   end Write_Scale;

   procedure Write_All_Pass (This : in out Context;
                             Buffer : in out Delay_Buffer;
                             D : DL;
                             Scale : S16)
   is
      Index : constant U16 :=
        (This.Write_Ptr + D.Base) mod Buffer'Length;
   begin
      Buffer (Index) := This.Accumulator;

      This.Accumulator :=
        S16 ((S32 (This.Accumulator) * S32 (Scale)) / 2**15);

      This.Accumulator := This.Accumulator + This.Prev_Read;
   end Write_All_Pass;

   procedure Write (This : in out Context;
                    Buffer : in out Delay_Buffer;
                    D : DL;
                    Scale : S16)
   is
      Index : constant U16 :=
        (This.Write_Ptr + D.Base) mod Buffer'Length;
   begin
      Buffer (Index) := This.Accumulator;

      This.Accumulator :=
        S16 ((S32 (This.Accumulator) * S32 (Scale)) / 2**15);
   end Write;

   procedure Write_Double (This : in out Context;
                           Buffer : in out Delay_Buffer;
                           D : DL)
   is
      Index : constant U16 :=
        (This.Write_Ptr + D.Base) mod Buffer'Length;
   begin
      Buffer (Index) := This.Accumulator;

      This.Accumulator := This.Accumulator * 2;
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

   procedure HP (This : in out Context;
                 State : in out S16;
                 Coef : S16)
   is
   begin
      State := State +
        S16 ((S32 (Coef) * S32 (This.Accumulator - State)) / 2**15);

      This.Accumulator := This.Accumulator - State;
   end HP;

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

      if (U16 (C.Write_Ptr) and 31) /= 0 then
         C.LFO_Value_1 := This.LFO_1.Render;
         C.LFO_Value_2 := This.LFO_2.Render;
      end if;
   end Start;

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Instance) is
   begin
      This.Buffer := (others => 0);

      This.LFO_1.Set_Shape (LFO.Sine);
      This.LFO_1.Set_Loop_Mode (LFO.Repeat);
      This.LFO_1.Set_Rate (Param_Range'Last / 3);

      This.LFO_2.Set_Shape (LFO.Sine);
      This.LFO_2.Set_Loop_Mode (LFO.Repeat);
      This.LFO_2.Set_Rate (Param_Range'Last / 4);
   end Reset;

   -------------
   -- Process --
   -------------

   procedure Process (This  : in out Instance;
                      Left  : in out Mono_Buffer;
                      Right : in out Mono_Buffer)
   is
      Ap1   : constant DL := (0, 113);
      Ap2   : constant DL := (Ap1.Base + Ap1.Len + 1, 162);
      Ap3   : constant DL := (Ap2.Base + Ap2.Len + 1, 241);
      Ap4   : constant DL := (Ap3.Base + Ap3.Len + 1, 399);
      Dap1a : constant DL := (Ap4.Base + Ap4.Len + 1, 1653);
      Dap1b : constant DL := (Dap1a.Base + Dap1a.Len + 1, 2038);
      Del1  : constant DL := (Dap1b.Base + Dap1b.Len + 1, 3411);
      Dap2a : constant DL := (Del1.Base + Del1.Len + 1, 1913);
      Dap2b : constant DL := (Dap2a.Base + Dap2a.Len + 1, 1663);
      Del2  : constant DL := (Dap2b.Base + Dap2b.Len + 1, 4782);

      C : Context;

      Kap : constant S16 := S16 (This.Diffusion);
      Klp : constant S16 := S16 (This.LP);
      Krt : constant S16 := S16 (This.Reverb_Time);
      Amount : constant S16 := S16 (This.Amount);
      Gain : constant S16 := S16 (This.Input_Gain);

      LP1 : S16 renames This.LP_Decay_1;
      LP2 : S16 renames This.LP_Decay_1;

   begin

      for Index in Left'Range loop
         declare
            Wet : S16 := 0;
            Apout : S16 := 0;
            L : S16 renames Left (Index);
            R : S16 renames Right (Index);
         begin
            Start (This, C);

            --  Smear AP1 inside the loop.
            --  TODO: Interpolate (Ap1, 10.0, C.LFO_Value_1, 10.0, 1.0);
            --  TODO: c.Write(ap1, 100, 0.0f);

            C.Read (S16 (DSP.Clip_S16 (S32 (L) + S32 (R))), Gain);

            --  Diffuse through 4 allpasses
            C.Read_Tail (This.Buffer, Ap1, Kap);
            C.Write_All_Pass (This.Buffer, Ap1, -Kap);
            C.Read_Tail (This.Buffer, Ap2, Kap);
            C.Write_All_Pass (This.Buffer, Ap2, -Kap);
            C.Read_Tail (This.Buffer, Ap3, Kap);
            C.Write_All_Pass (This.Buffer, Ap3, -Kap);
            C.Read_Tail (This.Buffer, Ap4, Kap);
            C.Write_All_Pass (This.Buffer, Ap4, -Kap);
            C.Write (Apout);

            --  Main reverb loop
            C.Load (Apout);
            --  TODO: c.Interpolate(del2, 4680.0f, LFO_2, 100.0f, krt);

            C.Read_Tail (This.Buffer, Del1, Krt); -- TODO: Remove?

            C.LP (LP1, Klp);
            C.Read_Tail (This.Buffer, Dap1a, -Kap);
            C.Write_All_Pass (This.Buffer, Dap1a, Kap);
            C.Read_Tail (This.Buffer, Dap1b, Kap);
            C.Write_All_Pass (This.Buffer, Dap1b, -Kap);
            C.Write_Double (This.Buffer, Del1); -- TODO: Scale 2.0
            C.Write_Scale (Wet, 0); --  TODO: 0.0???

            L := L + S16((S32 (Wet - L) * S32 (Amount)) / 2**15);

            C.Load (Apout);
            --  TODO: c.Interpolate(del2, 4680.0f, LFO_2, 100.0f, krt);
            C.LP (LP2, Klp);
            C.Read_Tail (This.Buffer, Del1, Krt);
            C.Read_Tail (This.Buffer, Dap2a, Kap);
            C.Write_All_Pass (This.Buffer, Dap2a, -Kap);
            C.Read_Tail (This.Buffer, Dap2b, -Kap);
            C.Write_All_Pass (This.Buffer, Dap2b, Kap);
            C.Write_Double (This.Buffer, Del2); -- TODO: Scale 2.0
            C.Write_Scale (Wet, 0); --  TODO: 0.0???

            R := R + S16((S32 (Wet - R) * S32 (Amount)) / 2**15);
         end;
      end loop;
   end Process;

end Tresses.FX.Reverb;
