with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Filters.SVF;

with GNAT.IO; use GNAT.IO;

package body Tresses.Drums.Generic_Waveform_Noise_Kick is

   function Compute_Delay (Midi_Pitch : S16) return U32 is
      use Tresses.Resources;
      use Tresses.DSP;

      Pitch_Table_Start : constant := 128 * Resources.HIGHEST_NOTE;

      Ref_Pitch : S32 := S32 (Midi_Pitch);
      Num_Shifts : Natural := 0;

      A, B, Delai : U32;
   begin
      if Ref_Pitch >= Resources.HIGHEST_NOTE * 128 - Octave then
         Ref_Pitch := Resources.HIGHEST_NOTE * 128 - Octave;
      end if;

      Ref_Pitch := Ref_Pitch - Pitch_Table_Start;

      while Ref_Pitch < 0 loop
         Ref_Pitch := Ref_Pitch + Octave;
         Num_Shifts := Num_Shifts + 1;
      end loop;

      A := LUT_Oscillator_Delays (U8 (Ref_Pitch / 2**4));
      B := LUT_Oscillator_Delays (U8 (Ref_Pitch / 2**4) + 1);
      Delai := A +
        U32 ((S32 (B - A) * (Ref_Pitch and 16#F#)) / 2**4);

      Delai := Shift_Right (Delai, 12 - Num_Shifts);

      return Delai;
   end Compute_Delay;

   Comb_Delay_Len : constant := 1024; -- 8192;

   type Comb_Buffer is array (Natural range <>) of S32;
   Comb_Line : access Mono_Buffer := new Mono_Buffer (0 .. Comb_Delay_Len - 1);

   Prev_Filtered_Pitch : S32 := 0;
   Comb_Phase : U32 := 0;

   SVF_BP : access Filters.SVF.Instance := new Filters.SVF.Instance;

   -----------------
   -- Comb_Filter --
   -----------------

   procedure Comb_Filter (Buffer : in out Mono_Buffer;
                          Comb_Pitch : Pitch_Range;
                          Pitch_Offset, Reso : Param_Range)
   is
      Filtered_Pitch : S32 := 0;
      Local_Pitch : S32;
      Delai : U32;
   begin
      Local_Pitch := S32 (Comb_Pitch) + (S32 (Pitch_Offset) - 16384) / 2;
      --  Local_Pitch := Comb_Pitch;
      Filtered_Pitch := Prev_Filtered_Pitch;
      Filtered_Pitch := (15 * Filtered_Pitch + Local_Pitch) / 2**4;
      Prev_Filtered_Pitch := Filtered_Pitch;

      Delai := Compute_Delay (S16 (Filtered_Pitch));
      --  Delai := Compute_Delay (S16 (Param / 2));


      if Delai > (Comb_Delay_Len * 2**16) then
         Put_Line ("Delay clip:" & Delai'Img & " > " &  Natural (Comb_Delay_Len * 2**16)'Img);
         Delai := Comb_Delay_Len * 2**16;
      end if;

      declare
         Delai_Integral : U32 := (Delai / 2**16) - 6;
         Delai_Fractional : U32 := Delai and 16#FFFF#;
         Resonance : S16 := S16 (Reso);
         --  Warp the resonance curve to have a more precise adjustment in the extrema.
           --  Tresses.DSP.Interpolate824
           --    (Tresses.Resources.WS_Moderate_Overdrive, Reso);

         Delai_Ptr : U32 := Comb_Phase;
      begin

         Put_Line ("Delay Integral:" & Delai_Integral'Img);

         Delai_Ptr := Delai_Ptr mod Comb_Delay_Len;
         for Frame of Buffer loop
            declare
               Offset : U32 := Delai_Ptr + 2 * Comb_Delay_Len - Delai_Integral;
               A : S32 := S32 (Comb_Line (Natural (Offset mod Comb_Delay_Len)));
               B : S32 := S32 (Comb_Line (Natural ((Offset - 1) mod Comb_Delay_Len)));
               Delayed_Sample : S32 :=
                 A + (((B - A) * S32 (Delai_Fractional / 2)) / 2**15);
               Feedback : S32 :=
                 DSP.Clip_S16 (((Delayed_Sample * S32 (Resonance)) / 2**15) +
                                   S32 (Frame));
            begin

               Feedback := Filters.SVF.Process (SVF_BP.all, Feedback);

               Comb_Line (Natural (Delai_Ptr)) := S16 (Feedback);

               Frame := S16 (DSP.Clip_S16 ((S32 (Frame) + Delayed_Sample * 2) / 2));
               --  Frame := S16 (DSP.Clip_S16 ((Delayed_Sample * 2)));
               Delai_Ptr := (Delai_Ptr + 1) mod Comb_Delay_Len;
            end;
         end loop;
         Comb_Phase := Delai_Ptr;
      end;

   end Comb_Filter;

   -----------------
   -- Render_Kick --
   -----------------

   procedure Render_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env, Noise_Env         : in out Envelopes.AR.Instance;
      RNG                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Comb_Pitch_Offset   : Param_Range renames Params (P_Comb_Pitch);
      Comb_Reso           : Param_Range renames Params (P_Comb_Reso);
      Noise_Decay         : Param_Range renames Params (P_Noise_Decay);
      Filter_Pitch_Offset : Param_Range renames Params (P_Filter_Pitch);

      Offset_Pitch_Incr : U32;
      Sample : S32;
      Phase_Noise : S32;
      Phase_Modulation : U32;
      Phase_Incr_Delta : U32 := 0;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env,
               Do_Hold => False,
               Release_Speed => S_Quarter_Second);
         Set_Attack (Env, 0);

         Init (Noise_Env,
               Do_Hold => False,
               Release_Speed => S_Quarter_Second);
         Set_Attack (Noise_Env, 0);

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;

         Filters.SVF.Init (SVF_BP.all);
         Filters.SVF.Set_Mode (SVF_BP.all, Filters.SVF.Band_Pass);
         Filters.SVF.Set_Resonance (SVF_BP.all, Param_Range'Last - 5000);
         Filters.SVF.Set_Punch (SVF_BP.all, 0);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (Noise_Env, Do_Strike.Velocity);

            Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Release (Env, Noise_Decay);

      -- 1/5 of a quarter of second: 50 milliseconds
      Set_Release (Noise_Env,  Param_Range'Last / 5);

      Filters.SVF.Set_Frequency (SVF_BP.all,
                                 Add_Sat (Param_Range (Pitch),
                                   Filter_Pitch_Offset / 8));
      Filters.SVF.Set_Resonance (SVF_BP.all, 1700);

      for Index in Buffer'Range loop

         Phase := Phase + Phase_Increment;

         Render (Noise_Env);
         Phase_Noise :=
           (S32 (Tresses.Random.Get_Sample (RNG)) *
              S32 (Value (Noise_Env))) / 2**15;

         --  S16 to U32
         Phase_Modulation := U32 (-S32 (S16'First) + Phase_Noise) * 2**15;

         Sample := S32 (DSP.Interpolate824 (Resources.WAV_Triangle,
                        Phase + Phase_Modulation));

         --  Amplitude envolope
         Sample := (Sample * Low_Pass (Noise_Env)) / 2**15;

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

      Comb_Filter (Buffer, Pitch, Comb_Pitch_Offset, Comb_Reso);

      for Frame of Buffer loop
         Render (Env);
         Frame := S16 (DSP.Clip_S16 (S32 (Frame) +
                         (S32 (Random.Get_Sample (RNG)) * Low_Pass (Env)) / 2**15));
      end loop;
   end Render_Kick;

end Tresses.Drums.Generic_Waveform_Noise_Kick;
