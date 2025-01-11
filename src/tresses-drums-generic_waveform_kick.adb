with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Drums.Generic_Waveform_Kick is

   -----------------
   -- Render_Kick --
   -----------------

   procedure Render_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env, Pitch_Env         : in out Envelopes.AR.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Decay        : Param_Range renames Params (P_Decay);
      Drive        : Param_Range renames Params (P_Drive);
      Pitch_Offset : Param_Range renames Params (P_Punch);
      Pitch_Decay  : Param_Range renames Params (P_Punch_Decay);

      --  function Bitcrush (P : Param_Range)
      --                     return Param_Range
      --  is (Param_Range (U16 (P) and 2#1111_0000_0000_0000#));
      function Bitcrush (P : Param_Range)
                         return Param_Range
      is (P);

      Offset_Pitch_Incr : U32;
      Sample : S32;
      Fuzzed : S16;
      Drive_Amount : U32;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env,
               Do_Hold => False,
               Release_Speed => S_2_Seconds);
         Set_Attack (Env, 0);

         Init (Pitch_Env,
               Do_Hold => False,
               Release_Speed => S_1_Seconds,
               Attack_Speed => S_Half_Second);
         Set_Attack (Pitch_Env, Param_Range'Last / 32);

         Target_Phase_Increment := 0;
         Phase := 0;
         Phase_Increment := 0;
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (Pitch_Env, Do_Strike.Velocity);

            Target_Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

            Offset_Pitch_Incr :=
              DSP.Compute_Phase_Increment
                (S16 (Add_Sat (Pitch, Octave * 5)));

            Phase_Increment :=
              DSP.Mix (Target_Phase_Increment,
                       Offset_Pitch_Incr,
                       Pitch_Offset);

            Phase := 0;

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Release (Env, Decay);
      Set_Release (Pitch_Env, Pitch_Decay);

      --  Control curve: Drive to the power of 2
      Drive_Amount := U32 (Drive);
      Drive_Amount := Shift_Right (Drive_Amount**2, 15);
      Drive_Amount := Drive_Amount * 2;

      for Index in Buffer'Range loop

         --  Pitch envolope
         Render (Pitch_Env);
         Phase := Phase + DSP.Mix
           (Target_Phase_Increment, Phase_Increment,
            Bitcrush (Param_range (Low_Pass (Pitch_Env))));

         Sample := S32 (DSP.Interpolate824 (Tone_Waveform.all, Phase));

         --  Symmetrical soft clipping
         Fuzzed := DSP.Interpolate88
           (Resources.WS_Violent_Overdrive,
            U16 (Sample + 32_768));

         --  Mix clean and overdrive signals
         Sample := S32 (DSP.Mix (S16 (Sample), Fuzzed, U16 (Drive_Amount)));

         --  Amplitude envolope
         Render (Env);
         Sample := (Sample * Low_Pass (Env)) / 2**15;

         DSP.Clip_S16 (Sample);

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render_Kick;

end Tresses.Drums.Generic_Waveform_Kick;