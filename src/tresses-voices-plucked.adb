--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Random; use Tresses.Random;
with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;
with Tresses.DSP;

package body Tresses.Voices.Plucked is

   --------------------
   -- Render_Plucked --
   --------------------

   procedure Render_Plucked
     (Buffer    :    out Mono_Buffer;
      Params    :        Param_Array;
      Rng       : in out Random.Instance;
      Env       : in out Envelopes.AD.Instance;
      State     : in out Pluck_State;
      KS        : in out KS_Array;
      Pitch     :        Pitch_Range;
      Do_Strike : in out Boolean)
   is

      function Interpolate (Offset : U32; Phase : U32) return S32 is
         I : constant U32 := Offset + Shift_Right (Phase, 22);
         A : constant S32 := S32 (KS (I));
         B : constant S32 := S32 (KS (I + 1));

         V : constant S32 := S32 (Shift_Right (Phase, 6) and 16#7FFF#);
         --  In the original code the mask is 0xFFFF but this leads to integer
         --  overflow in (B - A) * V. So we use a mask of 0x7FFF here.
      begin
         return A + (((B - A) * V) / 2**16);
      end Interpolate;

      Decay_Param : Param_Range renames Params (P_String_Decay);
      Position_Param : Param_Range renames Params (P_Position);

      Phase_Increment : U32 := DSP.Compute_Phase_Increment (S16 (Pitch));
   begin

      Set_Attack (Env, Params (P_Attack));
      Set_Decay (Env, Params (P_Decay));

      Phase_Increment := Phase_Increment * 2;

      if Do_Strike then
         Do_Strike := False;

         --  New active voice
         if State.Active = State.Voices'Last then
            State.Active := State.Voices'First;
         else
            State.Active := State.Active + 1;
         end if;

         declare
            P : Pluck_Voice renames State.Voices (State.Active);
            Increment : U32 := Phase_Increment;
            Width : U32;
         begin
            P.Shift := 0;
            while Increment > (2 * 2**22) loop
               Increment := Increment / 2;
               P.Shift := P.Shift + 1;
            end loop;

            P.Size := Shift_Right (Elt_Per_Voice - 1, P.Shift);
            P.Mask := P.Size - 1;
            P.Write_Ptr := 0;
            P.Max_Phase_Increment := Phase_Increment * 2;
            P.Phase_Increment := Phase_Increment;

            Width := U32 (Position_Param);
            Width := (3 * Width) / 2;
            P.Initialization_Ptr := (P.Size * (8_192 + Width)) / 2**16;
         end;

         Trigger (Env, Attack);
      end if;

      declare
         Current_String : Pluck_Voice renames State.Voices (State.Active);

         Update_Probability : U32;
         Loss : S32;

         Index : Natural := Buffer'First;
         Previous_Sample : S32;
         Sample          : S32;
      begin
         --  Update the phase increment of the latest note, but do not
         --  transpose too high above the original pitch.
         Current_String.Phase_Increment :=
           U32'Min (Phase_Increment, Current_String.Max_Phase_Increment);

         --  Compute loss and stretching factors
         Update_Probability :=
           (if Decay_Param < 16_384
            then 65535
            else 131_072 - (Shift_Right (U32 (Decay_Param), 3) * 31));

         Loss := 4_096 - S32 (Shift_Right (Phase_Increment, 14));
         if Loss < 256 then
            Loss := 256;
         end if;

         if Decay_Param < 16_384 then
            Loss := (Loss * (16_384 - S32 (Decay_Param))) / 2**14;
         else
            Loss := 0;
         end if;

         Previous_Sample :=
           S32 (State.Voices (State.Voices'First).Prev_Sample);

         while Index <= Buffer'Last loop
            Sample := 0;
            for I in State.Voices'Range loop
               declare
                  P : Pluck_Voice renames State.Voices (I);
                  Offset : constant U32 := I * Elt_Per_Voice;
                  Excitation_Sample : S32;
               begin
                  --  Initialization: Just use a white noise sample and fill
                  --  the delay line.
                  if P.Initialization_Ptr /= 0 then
                     P.Initialization_Ptr := P.Initialization_Ptr - 1;

                     Excitation_Sample :=
                       (S32 (KS (Offset + P.Initialization_Ptr)) +
                          3 * S32 (Get_Sample (Rng))) / 2**2;

                     KS (Offset + P.Initialization_Ptr) :=
                       S16 (Excitation_Sample);

                     Sample := Sample + Excitation_Sample;

                  else
                     P.Phase := P.Phase + P.Phase_Increment;

                     declare
                        Read_Ptr : constant U32 :=
                          (Shift_Right (P.Phase, (22 + P.Shift)) + 2)
                          and P.Mask;
                        Write_Ptr : U32 renames P.Write_Ptr;
                        Num_Loops : U32 := 0;
                        Next, Probability : U32;
                        A, B, Sum : S32;
                     begin
                        while Write_Ptr /= Read_Ptr loop
                           Num_Loops := Num_Loops + 1;
                           Next := (Write_Ptr + 1) and P.Mask;
                           A := S32 (KS (Offset + Write_Ptr));
                           B := S32 (KS (Offset + Next));
                           Probability := Get_Word (Rng);

                           if (Probability and 16#FFFF#) < Update_Probability
                           then
                              Sum := A + B;
                              Sum := (if Sum < 0
                                      then -(-Sum / 2)
                                      else Sum / 2);

                              if Loss /= 0 then
                                 Sum := (Sum * (32_768 - Loss)) / 2**15;
                              end if;
                              KS (Offset + Write_Ptr) := S16 (Sum);
                           end if;

                           if Write_Ptr = 0 then
                              KS (Offset + P.Size) := KS (Offset);
                           end if;
                           Write_Ptr := Next;
                        end loop;
                        Sample := Sample + Interpolate
                          (Offset, Shift_Right (P.Phase, P.Shift));
                     end;
                  end if;
               end;
            end loop;

            DSP.Clip_S16 (Sample);
            Sample := (Sample * S32 (Render (Env))) / 2**15;
            DSP.Clip_S16 (Sample);

            Buffer (Index) := S16 ((Previous_Sample + Sample) / 2**1);
            Previous_Sample := Sample;
            Index := Index + 1;
            exit when Index > Buffer'Last;

            Buffer (Index) := S16 (Sample);
            Index := Index + 1;
            exit when Index > Buffer'Last;
         end loop;
      end;

   end Render_Plucked;

end Tresses.Voices.Plucked;
