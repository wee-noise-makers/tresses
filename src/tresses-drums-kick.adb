--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Excitation; use Tresses.Excitation;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;
with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Drums.Kick is

   -----------------
   -- Render_Kick --
   -----------------

   procedure Render_Kick
     (Buffer         :    out Mono_Buffer;
      Params         :        Param_Array;
      Pulse0, Pulse1 : in out Excitation.Instance;
      Filter         : in out Filters.SVF.Instance;
      Env            : in out Envelopes.AD.Instance;
      LP_State       : in out S32;
      Pitch          :        Pitch_Range;
      Do_Init        : in out Boolean;
      Do_Strike      : in out Boolean)
   is
      Decay        : Param_Range renames Params (P_Decay);
      Coefficient  : Param_Range renames Params (P_Coefficient);
      Drive        : Param_Range renames Params (P_Drive);
      Pitch_Decay  : Param_Range renames Params (P_Punch);
      Drive_Amount : U32;

      Pitch_Offset : S32 := 0;

   begin
      if Do_Init then
         Do_Init := False;

         LP_State := 0;

         Init (Pulse0);
         Set_Delay (Pulse0, 0);
         Set_Decay (Pulse0, 3340);

         Init (Pulse1);
         Set_Delay (Pulse1, U16 (1.0e-3 * Resources.SAMPLE_RATE_REAL / 2.0));
         Set_Decay (Pulse1, 3072);

         Init (Filter);
         Set_Punch (Filter, 32768);
         Set_Mode (Filter, Band_Pass);

         Set_Attack (Env, U7'First);

      end if;

      --  Strike
      if Do_Strike then
         Do_Strike := False;

         Trigger (Pulse0, S32 (12.0 * 32_768.0 * 0.7));
         Trigger (Pulse1, S32 (-19_662.0 * 0.7));
         Set_Punch (Filter, 24_000);

         Set_Decay (Env, 4096 + Pitch_Decay / 4);
         Trigger (Env, Envelopes.AD.Attack);
      end if;

      Pitch_Offset := S32 (Octave) * 4;

      declare
         Scaled : U32 := 65_535 - (Shift_Left (U32 (Decay), 1));
         Squared : constant U32 := Shift_Right (Scaled * Scaled, 16);
      begin
         Scaled := Shift_Right (Squared * Scaled, 18);
         Set_Resonance (Filter, S16 (32768 - 128 - Scaled));
      end;

      --  Control curve: Drive to the power of 2
      Drive_Amount := U32 (Drive);
      Drive_Amount := Shift_Right (Drive_Amount**2, 15);
      Drive_Amount := Drive_Amount * 2;

      declare
         Coef : U32 := U32 (Coefficient);

         Target_Pitch : S32;
      begin
         --  Control curve: Coef to the power of 4
         Coef := Shift_Right (Coef**2, 15);
         Coef := Shift_Right (Coef**2, 15);
         declare
            LP_Coef : constant S32 := 128 + S32 (Coef / 2) * 3;

            Index : Natural := Buffer'First;
         begin
            while Index <= Buffer'Last loop
               declare
                  Excitation : S32 := 0;
               begin
                  Excitation := Excitation + Process (Pulse0);
                  Excitation := Excitation + (if not Done (Pulse1)
                                              then 16384
                                              else 0);
                  Excitation := Excitation + Process (Pulse1);

                  --  Pitch Envelope
                  Render (Env);
                  Target_Pitch := S32 (Pitch) +
                    ((Pitch_Offset * S32 (Value (Env))) / 2**15);
                  DSP.Clip_S16 (Target_Pitch);

                  Set_Frequency (Filter, S16 (Target_Pitch));
                  for X in 0 .. 1 loop
                     declare
                        Resonator_Output : S32;
                        Ignore : Integer;
                        Fuzzed : S16;
                     begin
                        Resonator_Output := (Excitation / 2**4) +
                          Process (Filter, Excitation);

                        LP_State := LP_State +
                          (((Resonator_Output - LP_State) * LP_Coef) / 2**15);

                        DSP.Clip_S16 (LP_State);

                        --  Symmetrical soft clipping

                        Fuzzed := DSP.Interpolate88
                          (Resources.WS_Violent_Overdrive,
                           U16 (LP_State + 32_768));

                        --  Mix clean and overdrive signals
                        Buffer (Index) := DSP.Mix (S16 (LP_State),
                                                   Fuzzed,
                                                   U16 (Drive_Amount));

                        Index := Index + 1;

                        exit when Index > Buffer'Last;
                     end;
                  end loop;
               end;
            end loop;

         end;
      end;
   end Render_Kick;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_Kick (Buffer,
                   This.Params,
                   This.Pulse0,
                   This.Pulse1,
                   This.Filter,
                   This.Env,
                   This.LP_State,
                   This.Pitch,
                   This.Do_Init,
                   This.Do_Strike);
   end Render;

end Tresses.Drums.Kick;
