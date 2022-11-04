--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Drums.Percussion is

   kDrumPartials : constant array (Partials_Index) of S16 :=
     (
      0, 0, 1041, 1747, 1846, 3072
     );

   kDrumPartialAmplitudes : constant array (Partials_Index) of S16 :=
     (
      16986, 2654, 3981, 5308, 3981, 2985
     );

   kDrumPartialDecayLong : constant array (Partials_Index) of U16 :=
     (
      65533, 65531, 65531, 65531, 65531, 65516
     );

   kDrumPartialDecayShort : constant array (Partials_Index) of U16 :=
     (
      65083, 64715, 64715, 64715, 64715, 62312
     );

   -----------------
   -- Set_Damping --
   -----------------

   procedure Set_Damping (This : in out Instance; Damping : Param_Range) is
   begin
      This.Damping := Damping;
   end Set_Damping;

   ---------------------
   -- Set_Coefficient --
   ---------------------

   procedure Set_Coefficient (This : in out Instance; Coef : Param_Range) is
   begin
      This.Coefficient := Coef;
   end Set_Coefficient;

   ------------
   -- Strike --
   ------------

   overriding
   procedure Strike (This : in out Instance) is
   begin
      This.Do_Strike := True;
   end Strike;

   ---------------
   -- Set_Pitch --
   ---------------

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range)
   is
   begin
      This.Pitch := Pitch;
   end Set_Pitch;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_Percussion (Buffer,
                         This.Damping, This.Coefficient,
                         This.State,
                         This.Rng,
                         This.Pitch,
                         This.Do_Strike);
   end Render;

   -----------------------
   -- Render_Percussion --
   -----------------------

   procedure Render_Percussion
     (Buffer               :    out Mono_Buffer;
      Damping, Coefficient :        Param_Range;
      State                : in out Additive_State;
      Rng                  : in out Random.Instance;
      Pitch                :        Pitch_Range;
      Do_Strike            : in out Boolean)
   is
   begin
      --  Strike
      if Do_Strike then
         Do_Strike := False;

         declare
            Reset_Phase : constant Boolean :=
              State.Partial_Amplitude (0) < 1024;
         begin
            for I in Partials_Index loop

               State.Target_Partial_Amplitude (I) :=
                 S32 (kDrumPartialAmplitudes (I));

               if Reset_Phase then
                  State.Partial_Phase (I) := 2**30;
               end if;
            end loop;
         end;
      else
         --  Allow a "droning" bell with no energy loss when the parameter is
         --  set to its maximum value
         if Damping < 32_000 then
            for I in Partials_Index loop
               declare
                  Decay_Long  : constant S32 :=
                    S32 (kDrumPartialDecayLong (I));
                  Decay_Short : constant S32 :=
                    S32 (kDrumPartialDecayShort (I));
                  Balance     : constant S16 :=
                    ((((32_767 - S16 (Damping)) / 2**8)**2) / 2**7);

                  Decay       : constant S32 :=
                 Decay_Long -
                      (((Decay_Long - Decay_Short) * S32 (Balance)) / 2**7);
               begin
                  State.Target_Partial_Amplitude (I) :=
                    (State.Partial_Amplitude (I) * Decay) / 2**16;
               end;
            end loop;
         end if;
      end if;

      for I in Partials_Index loop
         State.Partial_Phase_Increment (I) :=
           DSP.Compute_Phase_Increment (S16 (Pitch) + kDrumPartials (I)) * 2;
      end loop;

      declare
         Index : Natural := Buffer'First;

         Cutoff : S32 := (S32 (Pitch) - 12 * 128) + S32 (Coefficient) / 2;

         F : S32;

         Previous_Sample : S16 renames State.Previous_Sample;
         LP_State_0 : S32 renames State.LP_Noise (0);
         LP_State_1 : S32 renames State.LP_Noise (1);
         LP_State_2 : S32 renames State.LP_Noise (2);

         Harmonics_Gain : constant S32 := (if Coefficient < 12_888
                                           then S32 (Coefficient) + 4096
                                           else 16_384);
         Noise_Mode_Gain : S32 := (if Coefficient < 16_384
                                   then 0
                                   else S32 (Coefficient) - 16_384);

         Fade_Increment : constant S32 := 65_536 / Buffer'Length;
         Fade : S32 := 0;

      begin

         Noise_Mode_Gain := (Noise_Mode_Gain * 12_888) / 2**14;

         DSP.Clip (Cutoff, 0, 32_767);

         F := S32 (DSP.Interpolate824 (Resources.LUT_Svf_Cutoff,
                                       U32 (Cutoff * 2**16)));
         loop
            Fade := Fade + Fade_Increment;

            declare
               Harmonics : S32 := 0;
               Noise : S32 := S32 (Random.Get_Sample (Rng));

               Partials : S32_Partials;
               Partial : S32;
               Amplitude : S32;
            begin

               DSP.Clip (Noise, -16_384, 16_384);

               LP_State_0 := LP_State_0 +
                 (((Noise - LP_State_0) * F) / 2**15);
               LP_State_1 := LP_State_1 +
                 (((LP_State_0 - LP_State_1) * F) / 2**15);
               LP_State_2 := LP_State_2 +
                 (((LP_State_1 - LP_State_2) * F) / 2**15);

               for I in Partials_Index loop

                  State.Partial_Phase (I) :=
                    State.Partial_Phase (I) +
                    State.Partial_Phase_Increment (I);

                  Partial :=
                    S32 (DSP.Interpolate824
                         (Resources.WAV_Sine, State.Partial_Phase (I)));

                  Amplitude := State.Partial_Amplitude (I) +
                    ((State.Target_Partial_Amplitude (I) -
                       State.Partial_Amplitude (I)) * Fade) / 2**15;

                  Partial := (Partial * Amplitude) / 2**16;

                  Harmonics := Harmonics + Partial;
                  Partials (I) := Partial;
               end loop;

               declare
                  Sample : S32 := Partials (0);

                  Noise_Mode_1 : constant S32 :=
                    (Partials (1) * LP_State_2) / 2**8;

                  Noise_Mode_2 : constant S32 :=
                    (Partials (3) * LP_State_2) / 2**9;
               begin
                  Sample := Sample +
                    (Noise_Mode_1 * (12_288 - Noise_Mode_Gain) / 2**14);

                  Sample := Sample +
                    ((Noise_Mode_2 * Noise_Mode_Gain) / 2**14);

                  Sample := Sample +
                    ((Harmonics * Harmonics_Gain) / 2**14);

                  DSP.Clip_S16 (Sample);

                  Buffer (Index) := S16 ((Sample + S32 (Previous_Sample)) / 2);
                  Index := Index + 1;

                  Previous_Sample := S16 (Sample);
                  exit when Index > Buffer'Last;

                  Buffer (Index) := S16 (Sample);
                  Index := Index + 1;
                  exit when Index > Buffer'Last;

               end;

            end;
         end loop;

         for I in Partials_Index loop
            State.Partial_Amplitude (I) := State.Target_Partial_Amplitude (I);
         end loop;
      end;
   end Render_Percussion;

end Tresses.Drums.Percussion;
