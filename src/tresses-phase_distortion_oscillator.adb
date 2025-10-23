with Tresses.DSP;

package body Tresses.Phase_Distortion_Oscillator
with Preelaborate
is

   --------------------------
   -- Phase_Distort_Lookup --
   --------------------------

   function Phase_Distort_Lookup (Phase : U32; Amount : Param_Range)
                                  return U32
   is
      Lookup_S64 : constant S64 :=
        S64 (DSP.Interpolate824 (Lookup_Table.all, Phase));

      New_Phase : constant U64 := U64 (Lookup_S64 + 32_768) * 2**16 - 1;
   begin
      return DSP.Mix (Phase, U32 (New_Phase), Amount);
   end Phase_Distort_Lookup;

   ----------
   -- Init --
   ----------

   procedure Init (This          : in out Instance;
                   Release_Curve :        Curve         := Exponential;
                   Release_Speed :        Segment_Speed := S_2_Seconds)
   is
   begin
      Init (This.Shape_Env,
            Do_Hold => False,
            Release_Curve => Release_Curve,
            Release_Speed => Release_Speed);
      Set_Attack (This.Shape_Env, 0);

      This.Phase := 0;
      This.Phase_Increment := 0;
   end Init;

   -------------
   -- Trigger --
   -------------

   procedure Trigger (This     : in out Instance;
                      Velocity :        Param_Range)
   is
   begin
      On (This.Shape_Env, Velocity);
   end Trigger;

   ------------
   -- Render --
   ------------

   procedure Render (This    : in out Instance;
                     Buffer  :    out Mono_Buffer;
                     Wave    :        Wave_Ref;
                     Amount  :        Param_Range;
                     Release :        Param_Range)
   is
      Dist_Amount : Param_Range;
      New_Phase : U32;

   begin

      Set_Release (This.Shape_Env, Release);
      This.Phase_Increment := DSP.Compute_Phase_Increment (S16 (This.Pitch));

      for Sample of Buffer loop

         This.Phase := This.Phase + This.Phase_Increment;

         --  Envolope
         Render (This.Shape_Env);

         --  Apply Phase Distortion envelope
         Dist_Amount :=
           Param_Range ((S32 (Amount) * Low_Pass (This.Shape_Env)) / 2**15);

         New_Phase := Phase_Distort (This.Phase, Dist_Amount);
         Sample := DSP.Interpolate824 (Wave.all, New_Phase);
      end loop;
   end Render;

   ----------------------
   -- Render_Resonance --
   ----------------------

   procedure Render_Resonance (This    : in out Instance;
                               Buffer  :    out Mono_Buffer;
                               Wave    :        Wave_Ref;
                               Amount  :        Param_Range;
                               Release :        Param_Range)
   is
      Dist_Amount : Param_Range;
   begin

      Set_Release (This.Shape_Env, Release);
      This.Phase_Increment := DSP.Compute_Phase_Increment (S16 (This.Pitch));

      for Sample of Buffer loop

         This.Phase := This.Phase + This.Phase_Increment;

         --  Envolope
         Envelopes.AR.Render (This.Shape_Env);

         --  Apply Phase Distortion envelope
         Dist_Amount :=
           Param_Range ((S32 (Amount) * Low_Pass (This.Shape_Env)) / 2**15);

         if This.Phase < U32'Last / 2 then
            Sample := DSP.Interpolate824 (Wave.all, This.Phase);
         else

            --  For the second half of the phase we increase the phase rate
            --  to produce a higher frequency waveform. Up to several octaves
            --  higher than the base pitch.
            declare
               New_Phase : U32;
               Phase_U64 : U64 := U64 (This.Phase - (U32'Last / 2));
               Multiplier : constant U64 :=
                 U64 (U32'Last) + (U64 (Dist_Amount) * 2**22);
            begin
               Phase_U64 := (Phase_U64 * Multiplier) / 2**32;
               New_Phase := U32 (Phase_U64 mod U64 (U32'Last));
               Sample := DSP.Interpolate824 (Wave.all, New_Phase);
            end;

            --  This high frequency part of the waveform is then linearly
            --  attenuated to merge without discontinuities.
            declare
               Phase_Invert : constant U32 := U32'Last - This.Phase;
               Scaled : constant U32 := (Phase_Invert / 2**16);
               Attenuation : constant S32 := S32 (Scaled) - 1;

               Sample_32 : S32 := S32 (Sample);
            begin
               Sample_32 := (Sample_32 * Attenuation) / 2**15;
               Sample := S16 (Sample_32);
            end;
         end if;

      end loop;
   end Render_Resonance;

   ------------------------
   -- Render_Resonance_2 --
   ------------------------

   procedure Render_Resonance_2 (This    : in out Instance;
                                 Buffer  :    out Mono_Buffer;
                                 Wave    :        Wave_Ref;
                                 Amount  :        Param_Range;
                                 Release :        Param_Range)
   is
      Dist_Amount : Param_Range;
   begin

      Set_Release (This.Shape_Env, Release);
      This.Phase_Increment := DSP.Compute_Phase_Increment (S16 (This.Pitch));

      for Sample of Buffer loop

         This.Phase := This.Phase + This.Phase_Increment;

         --  Envolope
         Envelopes.AR.Render (This.Shape_Env);

         --  Apply Phase Distortion envelope
         Dist_Amount :=
           Param_Range ((S32 (Amount) * Low_Pass (This.Shape_Env)) / 2**15);

         if This.Phase < U32'Last / 2 then
            Sample := DSP.Interpolate824 (Wave.all, This.Phase);
         else

            --  For the second half of the phase we increase the phase rate
            --  to produce a higher frequency waveform. Up to several octaves
            --  higher than the base pitch.
            declare
               New_Phase : U32;
               Phase_U64 : U64 := U64 (This.Phase - (U32'Last / 2));
               Multiplier : constant U64 :=
                 U64 (U32'Last) + (U64 (Dist_Amount) * 2**22);
            begin
               Phase_U64 := (Phase_U64 * Multiplier) / 2**32;
               New_Phase := (U32'Last / 2) +
                 U32 (Phase_U64 mod U64 (U32'Last / 2));
               Sample := DSP.Interpolate824 (Wave.all, New_Phase);
            end;

            --  This high frequency part of the waveform is then linearly
            --  attenuated to merge without discontinuities.
            declare
               Phase_Invert : constant U32 := U32'Last - This.Phase;
               Scaled : constant U32 := (Phase_Invert / 2**16);
               Attenuation : constant S32 := S32 (Scaled) - 1;

               Sample_32 : S32 := S32 (Sample);
            begin
               Sample_32 := (Sample_32 * Attenuation) / 2**15;
               Sample := S16 (Sample_32);
            end;
         end if;

      end loop;
   end Render_Resonance_2;

   ---------------
   -- Set_Pitch --
   ---------------

   procedure Set_Pitch (This : in out Instance; P : Pitch_Range) is
   begin
      This.Pitch := P;
   end Set_Pitch;

end Tresses.Phase_Distortion_Oscillator;
