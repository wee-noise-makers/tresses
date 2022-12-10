--
--  SPDX-License-Identifier: MIT
--
--  Based on Braids from Mutable Instruments:
--  Copyright 2012 Emilie Gillet.

with Tresses.Excitation; use Tresses.Excitation;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Drums.Bell is

   kBellPartials : constant array (Partials_Index) of S16 :=
     (
      -1284, -1283, -184, -183, 385, 1175, 1536, 2233, 2434, 2934, 3110
     );

   kBellPartialAmplitudes : constant array (Partials_Index) of S16 :=
     (
      8192, 5488, 8192, 14745, 21872, 13680,
      11960, 10895, 10895, 6144, 10895
     );

   kBellPartialDecayLong : constant array (Partials_Index) of U16 :=
     (
      65533, 65533, 65533, 65532, 65531, 65531,
      65530, 65529, 65527, 65523, 65519
     );

   kBellPartialDecayShort : constant array (Partials_Index) of U16 :=
     (
      65308, 65283, 65186, 65123, 64839, 64889,
      64632, 64409, 64038, 63302, 62575
     );

   -----------------
   -- Render_Bell --
   -----------------

   procedure Render_Bell (Buffer    :    out Mono_Buffer;
                          Params    :        Param_Array;
                          State     : in out Additive_State;
                          Pitch     :        Pitch_Range;
                          Do_Strike : in out Boolean)
   is
      Damping     : Param_Range renames Params (P_Damping);
      Coefficient : Param_Range renames Params (P_Coefficient);

      First_Partial : Natural := State.Current_Partial;
      Last_Partial :  Natural :=
        Natural'Min (State.Current_Partial + 3,
                     Partials_Index'Last);
   begin
      --  To save some CPU cycles, do not refresh the frequency of all
      --  partials at the same time. This create a kind of "arpeggiation"
      --  with high frequency CV though...

      State.Current_Partial := (First_Partial + 3) mod Num_Bell_Partials;

      --  Strike
      if Do_Strike then
         Do_Strike := False;

         for I in Partials_Index loop
            State.Partial_Amplitude (I) := S32 (kBellPartialAmplitudes (I));
            State.Partial_Phase (I) := 2**30;
         end loop;

         First_Partial := Partials_Index'First;
         Last_Partial := Partials_Index'Last;
      end if;

      for I in First_Partial .. Last_Partial loop
         declare
            Partial_Pitch : S16 := S16 (Pitch) + kBellPartials (I);
         begin
            if I mod 2 = 1 then
               Partial_Pitch := Partial_Pitch + (S16 (Coefficient) / 2**7);
            else
               Partial_Pitch := Partial_Pitch - (S16 (Coefficient) / 2**7);
            end if;

            State.Partial_Phase_Increment (I) :=
              DSP.Compute_Phase_Increment (Partial_Pitch) * 2;
         end;
      end loop;

      --  Allow a "droning" bell with no energy loss when the parameter is set
      --  to its maximum value
      if Damping < 32_000 then
         for I in Partials_Index loop
            declare
               Decay_Long  : constant S32 := S32 (kBellPartialDecayLong (I));
               Decay_Short : constant S32 := S32 (kBellPartialDecayShort (I));

               B1          : constant S16 := (32_767 - S16 (Damping)) / 2**8;
               Balance     : constant S16 := (B1 * B1) / 2**7;

               Decay       : constant S32 :=
                 Decay_Long -
                   (((Decay_Long - Decay_Short) * S32 (Balance)) / 2**7);
            begin
               State.Partial_Amplitude (I) :=
                 (State.Partial_Amplitude (I) * Decay) / 2**16;
            end;
         end loop;
      end if;

      declare
         Index : Natural := Buffer'First;
         Previous_Sample : S16 renames State.Previous_Sample;
      begin
         loop
            declare
               Sample : S32 := 0;
               Partial : S32;
            begin
               for I in Partials_Index loop
                  State.Partial_Phase (I) :=
                    State.Partial_Phase (I) +
                    State.Partial_Phase_Increment (I);

                  Partial :=
                    S32 (DSP.Interpolate824
                         (Resources.WAV_Sine, State.Partial_Phase (I)));

                  Sample := Sample +
                    ((Partial * State.Partial_Amplitude (I)) / 2**17);
               end loop;

               DSP.Clip_S16 (Sample);
               Buffer (Index) := S16 ((Sample + S32 (Previous_Sample)) / 2);
               Index := Index + 1;

               Previous_Sample := S16 (Sample);
               exit when Index > Buffer'Last;

               Buffer (Index) := S16 (Sample);
               Index := Index + 1;
               exit when Index > Buffer'Last;
            end;
         end loop;
      end;
   end Render_Bell;

end Tresses.Drums.Bell;
