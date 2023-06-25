with Tresses.DSP;
with Tresses.Resources; use Tresses.Resources;

package body Tresses.Analog_Oscillator is

   type Waveform_257_Access is not null access constant Table_257_S16;

   Bandlimited_Comb_Table : constant array (U32 range <>)
     of Waveform_257_Access :=
     (0 => WAV_Bandlimited_Comb_0'Access,
      1 => WAV_Bandlimited_Comb_1'Access,
      2 => WAV_Bandlimited_Comb_2'Access,
      3 => WAV_Bandlimited_Comb_3'Access,
      4 => WAV_Bandlimited_Comb_4'Access,
      5 => WAV_Bandlimited_Comb_5'Access,
      6 => WAV_Bandlimited_Comb_6'Access,
      7 => WAV_Bandlimited_Comb_7'Access,
      8 => WAV_Bandlimited_Comb_8'Access,
      9 => WAV_Bandlimited_Comb_9'Access,
      10 => WAV_Bandlimited_Comb_10'Access,
      11 => WAV_Bandlimited_Comb_11'Access,
      12 => WAV_Bandlimited_Comb_12'Access,
      13 => WAV_Bandlimited_Comb_13'Access,
      14 => WAV_Bandlimited_Comb_14'Access);

   ----------------------
   -- This_Blep_Sample --
   ----------------------

   function This_Blep_Sample (T : U32) return S32 is
      X : U32 := T;
   begin
      if X > 65_535 then
         X := 65_535;
      end if;

      return S32 ((X * X) / 2**18);
   end This_Blep_Sample;

   ----------------------
   -- Next_Blep_Sample --
   ----------------------

   function Next_Blep_Sample (T : U32) return S32 is
      X : U32 := T;
   begin
      if X > 65_535 then
         X := 65_535;
      end if;

      X := 65_535 - X;

      return -S32 ((X * X) / 2**18);
   end Next_Blep_Sample;

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.Phase := 0;
      This.Phase_Increment := 1;
      This.Prev_Phase_Increment := 1;
      This.High := False;
      This.Params := (others => 0);
      This.Prev_Params := (others => 0);
      This.Discontinuity_Depth := -16_383;
      This.Next_Sample := 0;
   end Init;

   ----------
   -- Sync --
   ----------

   procedure Sync (This : in out Instance) is
   begin
      This.Phase := 0;
   end Sync;

   ---------------
   -- Set_Shape --
   ---------------

   procedure Set_Shape (This : in out Instance; S : Shape_Kind) is
   begin
      This.Shape := S;
   end Set_Shape;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      if This.Shape /= This.Prev_Shape then
         This.Init;
         This.Prev_Shape := This.Shape;
      end if;

      This.Phase_Increment :=
        DSP.Compute_Phase_Increment (S16 (This.Pitch));

      case This.Shape is
         when Saw =>
            This.Render_Saw (Buffer);
         when Variable_Saw =>
            This.Render_Variable_Saw (Buffer);
         when Square =>
            This.Render_Square (Buffer);
         when Triangle =>
            This.Render_Triangle (Buffer);
         when Sine =>
            This.Render_Sine (Buffer);
         when Triangle_Fold =>
            This.Render_Triangle_Fold (Buffer);
         when Sine_Fold =>
            This.Render_Sine_Fold (Buffer);
         when Buzz =>
            This.Render_Buzz (Buffer);
      end case;
   end Render;

   ---------------
   -- Set_Param --
   ---------------

   procedure Set_Param (This : in out Instance;
                        Id : Param_Id;
                        P  : Param_Range)
   is
   begin
      This.Params (Id) := P;
   end Set_Param;

   ---------------
   -- Set_Pitch --
   ---------------

   procedure Set_Pitch (This : in out Instance; P : Pitch_Range) is
   begin
      This.Pitch := P;
   end Set_Pitch;

   -----------------------
   -- Begin_Interpolate --
   -----------------------

   procedure Begin_Interpolate
     (This        : in out Param_Interpolator;
      Osc         : in out Instance;
      Id          :        Param_Id;
      Buffer_Size :        U32)
   is
   begin
      This.Id := Id;
      This.Start := S32 (Osc.Prev_Params (Id));
      This.Delt  := S32 (Osc.Params (Id)) - This.Start;
      This.Increment := S32 (Param_Range'Last) / S32 (Buffer_Size);
      This.Xfade := 0;
   end Begin_Interpolate;

   -----------------
   -- Interpolate --
   -----------------

   function Interpolate
     (This : in out Param_Interpolator)
      return Param_Range
   is
   begin
      This.Xfade := This.Xfade + This.Increment;
      return Param_Range (This.Start + ((This.Delt * This.Xfade) / 2**15));
   end Interpolate;

   ---------------------
   -- End_Interpolate --
   ---------------------

   procedure End_Interpolate
     (This : in out Param_Interpolator;
      Osc  : in out Instance)
   is
   begin
      Osc.Prev_Params (This.Id) := Osc.Params (This.Id);
   end End_Interpolate;

   -----------------------
   -- Begin_Interpolate --
   -----------------------

   procedure Begin_Interpolate
     (This        : in out Phase_Increment_Interpolator;
      Osc         : in out Instance;
      Buffer_Size :        U32)
   is
   begin
      This.Phase_Increment := Osc.Prev_Phase_Increment;
      if Osc.Prev_Phase_Increment < Osc.Phase_Increment then
         This.Phase_Increment_Increment :=
           (Osc.Phase_Increment - Osc.Prev_Phase_Increment) /
           Buffer_Size;
      else
         This.Phase_Increment_Increment :=
           not ((Osc.Prev_Phase_Increment - Osc.Phase_Increment) /
                    Buffer_Size);
      end if;
   end Begin_Interpolate;

   -----------------
   -- Interpolate --
   -----------------

   function Interpolate
     (This : in out Phase_Increment_Interpolator)
     return U32
   is
   begin
      This.Phase_Increment :=
        This.Phase_Increment + This.Phase_Increment_Increment;
      return This.Phase_Increment;
   end Interpolate;

   ---------------------
   -- End_Interpolate --
   ---------------------

   procedure End_Interpolate
     (This : in out Phase_Increment_Interpolator;
      Osc  : in out Instance)
   is
   begin
      Osc.Prev_Phase_Increment := This.Phase_Increment;
   end End_Interpolate;

   ----------------
   -- Render_Saw --
   ----------------

   procedure Render_Saw (This   : in out Instance;
                         Buffer :    out Mono_Buffer)
   is
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Next_Sample : S32 := S32 (This.Next_Sample);

   begin
      Begin_Interpolate (Phase_Incr_Interp,
                         This,
                         U32 (Buffer'Length));

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);
         declare
            --  Sync_Reset : Boolean := False;
            Self_Reset : Boolean := False;
            --  Transition_During_Reset : Boolean := False;

            --  Reset_Time : U32 := 0;
            T : U32;

            This_Sample : S32 := Next_Sample;
         begin
            Next_Sample := 0;

            --  TODO sync_in ?

            This.Phase := This.Phase + Phase_Increment;

            if This.Phase < Phase_Increment then
               Self_Reset := True;
            end if;

            --  TODO sync_out ?

            if Self_Reset then
               T := This.Phase / Shift_Right (Phase_Increment, 16);
               This_Sample := This_Sample - This_Blep_Sample (T);
               Next_Sample := Next_Sample - Next_Blep_Sample (T);
            end if;

            --  TODO sync_reset ?

            Next_Sample := Next_Sample + S32 (This.Phase / 2**17);

            Sample := S16 ((This_Sample - 16_384) * 2);
         end;
      end loop;

      This.Next_Sample := S16 (Next_Sample);

      End_Interpolate (Phase_Incr_Interp, This);

   end Render_Saw;

   -------------------------
   -- Render_Variable_Saw --
   -------------------------

   procedure Render_Variable_Saw (This   : in out Instance;
                                  Buffer :    out Mono_Buffer)
   is
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Next_Sample : S32 := S32 (This.Next_Sample);

      PW : constant U32 := U32 (This.Params (0)) * 2**16;
   begin
      Begin_Interpolate (Phase_Incr_Interp,
                         This,
                         U32 (Buffer'Length));

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);

         declare
            --  Sync_Reset : Boolean := False;
            Self_Reset : Boolean := False;
            --  Transition_During_Reset : Boolean := False;

            --  Reset_Time : U32 := 0;
            T : U32;

            This_Sample : S32 := Next_Sample;
         begin
            Next_Sample := 0;

            --  TODO sync_in ?

            This.Phase := This.Phase + Phase_Increment;

            if This.Phase < Phase_Increment then
               Self_Reset := True;
            end if;

            --  TODO sync_out ?

            loop
               if not This.High then
                  exit when This.Phase < PW;

                  if Shift_Right (Phase_Increment, 16) /= 0 then
                     T := (This.Phase - PW)  /
                       Shift_Right (Phase_Increment, 16);
                  else
                     T := 65_535;
                  end if;
                  This_Sample := This_Sample - This_Blep_Sample (T);
                  Next_Sample := Next_Sample - Next_Blep_Sample (T);
                  This.High := True;
               end if;

               if This.High then
                  exit when not Self_Reset;
                  Self_Reset := False;

                  T := This.Phase / Shift_Right (Phase_Increment, 16);
                  This_Sample := This_Sample - This_Blep_Sample (T);
                  Next_Sample := Next_Sample - Next_Blep_Sample (T);
                  This.High := False;
               end if;
            end loop;

            --  TODO sync_reset ?

            Next_Sample := Next_Sample + S32 (This.Phase / 2**18);
            Next_Sample := Next_Sample + S32 ((This.Phase - PW) / 2**18);

            Sample := S16 (DSP.Clip_S16 ((This_Sample - 16_384) * 2));
         end;
      end loop;

      This.Next_Sample := S16 (Next_Sample);

      End_Interpolate (Phase_Incr_Interp, This);

   end Render_Variable_Saw;

   -------------------
   -- Render_Square --
   -------------------

   procedure Render_Square (This   : in out Instance;
                            Buffer :    out Mono_Buffer)
   is
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Param : constant Param_Range := (if This.Params (0) > 32_000
                                       then 32_000
                                       else This.Params (0));

      Next_Sample : S32 := S32 (This.Next_Sample);

   begin
      Begin_Interpolate (Phase_Incr_Interp,
                         This,
                         U32 (Buffer'Length));

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);
         declare
            --  Sync_Reset : Boolean := False;
            Self_Reset : Boolean := False;
            --  Transition_During_Reset : Boolean := False;

            PW : constant U32 :=  Shift_Left (32_768 - U32 (Param), 16);
            --  Pulse Width

            --  Reset_Time : U32 := 0;
            T : U32;

            This_Sample : S32 := Next_Sample;
         begin
            Next_Sample := 0;

            --  TODO sync_in ?

            This.Phase := This.Phase + Phase_Increment;

            if This.Phase < Phase_Increment then
               Self_Reset := True;
            end if;

            --  TODO sync_out ?

            loop
               if not This.High then
                  exit when This.Phase < PW;

                  T := (This.Phase - PW)  / Shift_Right (Phase_Increment, 16);
                  This_Sample := This_Sample + This_Blep_Sample (T);
                  Next_Sample := Next_Sample + Next_Blep_Sample (T);
                  This.High := True;
               end if;

               if This.High then
                  exit when not Self_Reset;
                  Self_Reset := False;

                  T := This.Phase / Shift_Right (Phase_Increment, 16);
                  This_Sample := This_Sample - This_Blep_Sample (T);
                  Next_Sample := Next_Sample - Next_Blep_Sample (T);
                  This.High := False;
               end if;
            end loop;

            --  TODO sync_reset ?

            Next_Sample := Next_Sample + (if This.Phase < PW
                                          then 0
                                          else 32_767);

            Sample := S16 ((This_Sample - 16_384) * 2);
         end;
      end loop;

      This.Next_Sample := S16 (Next_Sample);

      End_Interpolate (Phase_Incr_Interp, This);

   end Render_Square;

   ---------------------
   -- Render_Triangle --
   ---------------------

   procedure Render_Triangle (This   : in out Instance;
                              Buffer :    out Mono_Buffer)
   is
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Phase_16 : U16;
      Triangle : S32;

   begin
      Begin_Interpolate (Phase_Incr_Interp, This, Buffer'Length);

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);

         Sample := 0;

         for X in 1 .. 2 loop
            This.Phase := This.Phase + Phase_Increment / 2;

            Phase_16 := U16 (This.Phase / 2**16);

            Triangle := S32 ((Phase_16 * 2**1) xor
                               (if (Phase_16 and 16#8000#) /= 0
                                then 16#FFFF#
                                else 16#0000#));
            Triangle := Triangle - 32_768;
            Sample := Sample + S16 (Triangle / 2);
         end loop;
      end loop;

      End_Interpolate (Phase_Incr_Interp, This);
   end Render_Triangle;

   -----------------
   -- Render_Sine --
   -----------------

   procedure Render_Sine (This   : in out Instance;
                          Buffer :    out Mono_Buffer)
   is
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;

   begin
      Begin_Interpolate (Phase_Incr_Interp, This, Buffer'Length);

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);

         This.Phase := This.Phase + Phase_Increment;

         Sample := DSP.Interpolate824 (WAV_Sine, This.Phase);
      end loop;

      End_Interpolate (Phase_Incr_Interp, This);
   end Render_Sine;

   --------------------------
   -- Render_Triangle_Fold --
   --------------------------

   procedure Render_Triangle_Fold (This   : in out Instance;
                                   Buffer :    out Mono_Buffer)
   is
      Gain : S32;
      Param_Interp : Param_Interpolator;
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Phase_16 : U16;
      Param : S32;
      Triangle : S32;

   begin
      Begin_Interpolate (Phase_Incr_Interp, This, Buffer'Length);
      Begin_Interpolate (Param_Interp, This, 0, Buffer'Length);

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);
         Param := S32 (Interpolate (Param_Interp));

         Gain := 2_048 + ((Param * 30_720) / 2**15);

         Sample := 0;

         for X in 1 .. 2 loop
            --  2x oversampled WF
            This.Phase := This.Phase + Phase_Increment / 2;

            Phase_16 := U16 (This.Phase / 2**16);

            Triangle := S32 ((Phase_16 * 2**1) xor
                               (if (Phase_16 and 16#8000#) /= 0
                                then 16#FFFF#
                                else 16#0000#));
            Triangle := Triangle - 32_768;
            Triangle := (Triangle * Gain) / 2**15;
            Triangle := S32 (DSP.Interpolate88 (Resources.WS_Tri_Fold,
                             U16 (Triangle + 32_768)));
            Sample := Sample + S16 (Triangle / 2);
         end loop;
      end loop;

      End_Interpolate (Phase_Incr_Interp, This);
      End_Interpolate (Param_Interp, This);
   end Render_Triangle_Fold;

   ----------------------
   -- Render_Sine_Fold --
   ----------------------

   procedure Render_Sine_Fold (This   : in out Instance;
                               Buffer :    out Mono_Buffer)
   is
      Sine : S32;
      Gain : S32;
      Param_Interp : Param_Interpolator;
      Phase_Incr_Interp : Phase_Increment_Interpolator;
      Phase_Increment : U32;
      Param : S32;

   begin
      Begin_Interpolate (Phase_Incr_Interp, This, Buffer'Length);
      Begin_Interpolate (Param_Interp, This, 0, Buffer'Length);

      for Sample of Buffer loop
         Phase_Increment := Interpolate (Phase_Incr_Interp);
         Param := S32 (Interpolate (Param_Interp));

         Gain := 2_048 + ((Param * 30_720) / 2**15);

         Sample := 0;

         for X in 1 .. 2 loop
            --  2x oversampled WF
            This.Phase := This.Phase + Phase_Increment / 2;
            Sine := S32 (DSP.Interpolate824 (Resources.WAV_Sine, This.Phase));
            Sine := (Sine * Gain) / 2**15;
            Sine := S32 (DSP.Interpolate88 (Resources.WS_Sine_Fold,
                         U16 (Sine + 32_768)));

            Sample := Sample + S16 (Sine / 2);
         end loop;
      end loop;

      End_Interpolate (Phase_Incr_Interp, This);
      End_Interpolate (Param_Interp, This);
   end Render_Sine_Fold;

   -----------------
   -- Render_Buzz --
   -----------------

   procedure Render_Buzz (This   : in out Instance;
                          Buffer :    out Mono_Buffer)
   is
      Shifted_Pitch : constant S32 := S32 (This.Pitch) +
        ((32_767 - S32 (This.Params (0))) / 2**1);

      Crossfade : constant U16 := (U16 (Shifted_Pitch) * 2**6) and 16#7FFF#;

      Index1        : U32 := Shift_Right (U32 (Shifted_Pitch), 10);
      Index2        : U32;
   begin
      if Index1 >= Bandlimited_Comb_Table'Last then
         Index1 := Bandlimited_Comb_Table'Last;
         Index2 := Index1;
      else
         Index2 := Index1 + 1;
      end if;

      declare
         Wave1 : constant Waveform_257_Access :=
           Bandlimited_Comb_Table (Index1);
         Wave2 : constant Waveform_257_Access :=
           Bandlimited_Comb_Table (Index2);
      begin
         for Sample of Buffer loop
            This.Phase := This.Phase + This.Phase_Increment;
            Sample := DSP.Crossfade (Wave1.all, Wave2.all,
                                     This.Phase, N16 (Crossfade));
         end loop;
      end;
   end Render_Buzz;

end Tresses.Analog_Oscillator;
