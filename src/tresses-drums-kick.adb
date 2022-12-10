--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Excitation; use Tresses.Excitation;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.DSP;

package body Tresses.Drums.Kick is

   -----------------
   -- Render_Kick --
   -----------------

   procedure Render_Kick (Buffer                 :    out Mono_Buffer;
                          Params                 :        Param_Array;
                          Pulse0, Pulse1, Pulse2 : in out Excitation.Instance;
                          Filter                 : in out Filters.SVF.Instance;
                          LP_State               : in out S32;
                          Pitch                  :        Pitch_Range;
                          Do_Init                : in out Boolean;
                          Do_Strike              : in out Boolean)
   is
      Decay       : Param_Range renames Params (P_Decay);
      Coefficient : Param_Range renames Params (P_Coefficient);
   begin
      if Do_Init then
         Do_Init := False;

         LP_State := 0;

         Init (Pulse0);
         Set_Delay (Pulse0, 0);
         Set_Decay (Pulse0, 3340);

         Init (Pulse1);
         Set_Delay (Pulse1, U16 (1.0e-3 * 48000.0));
         Set_Decay (Pulse1, 3072);

         Init (Pulse2);
         Set_Delay (Pulse2, U16 (4.0e-3 * 48000.0));
         Set_Decay (Pulse2, 4093);

         Init (Filter);
         Set_Punch (Filter, 32768);
         Set_Mode (Filter, Band_Pass);
      end if;

      --  Strike
      if Do_Strike then
         Do_Strike := False;

         Trigger (Pulse0, S32 (12.0 * 32_768.0 * 0.7));
         Trigger (Pulse1, S32 (-19_662.0 * 0.7));
         Trigger (Pulse2, S32 (18_000));
         Set_Punch (Filter, 24_000);
      end if;

      declare
         Scaled : U32 := 65_535 - (Shift_Left (U32 (Decay), 1));
         Squared : constant U32 := Shift_Right (Scaled * Scaled, 16);
      begin
         Scaled := Shift_Right (Squared * Scaled, 18);
         Set_Resonance (Filter, S16 (32768 - 128 - Scaled));
      end;

      declare
         Coef : U32 := U32 (Coefficient);
      begin
         Coef := Shift_Right (Coef**2, 15);
         Coef := Shift_Right (Coef**2, 15);
         declare
            LP_Coef : constant S32 := 128 + S32 (Coef / 2) * 3;

            Index : Natural := Buffer'First;
         begin
            while Index <= Buffer'Last loop
               declare
                  Excitation : S32 := 0;
                  Unused : S32;
               begin
                  Excitation := Excitation + Process (Pulse0);
                  Excitation := Excitation + (if not Done (Pulse1)
                                              then 16384
                                              else 0);
                  Excitation := Excitation + Process (Pulse1);

                  Unused := Process (Pulse2);

                  Set_Frequency (Filter, S16 (Pitch) + (if Done (Pulse2)
                                                        then 0
                                                        else 17 * 2**7));
                  for X in 0 .. 1 loop
                     declare
                        Resonator_Output : S32;
                        Ignore : Integer;
                     begin
                        Resonator_Output := (Excitation / 2**4) +
                          Process (Filter, Excitation);

                        LP_State := LP_State +
                          (((Resonator_Output - LP_State) * LP_Coef) / 2**15);

                        DSP.Clip_S16 (LP_State);

                        Buffer (Index) := S16 (LP_State);
                        Index := Index + 1;

                        exit when Index > Buffer'Last;
                     end;
                  end loop;
               end;
            end loop;

         end;
      end;
   end Render_Kick;

end Tresses.Drums.Kick;
