with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.Random; use Tresses.Random;
with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Drums.Clap is

   -----------------
   -- Render_Clap --
   -----------------

   procedure Render_Clap
     (Buffer    :    out Mono_Buffer;
      Params    :        Param_Array;
      Filter    : in out Filters.SVF.Instance;
      Rng       : in out Random.Instance;
      Env       : in out Envelopes.AR.Instance;
      Re_Trig   : in out U32;
      Pitch     :        Pitch_Range;
      Do_Init   : in out Boolean;
      Do_Strike : in out Strike_State)
   is

      Decay_Param : Param_Range renames Params (P_Decay);
      Sync_Param : Param_Range renames Params (P_Sync);
      Tone_Param : Param_Range renames Params (P_Tone);
      Drive_Param : Param_Range renames Params (P_Drive);

      Drive_Amount : U32;

   begin
      if Do_Init then
         Do_Init := False;

         Re_Trig := 0;

         Init (Filter);
         Set_Mode (Filter, Band_Pass);

         Init (Env,
               Do_Hold       => False,
               Attack_Speed  => S_Half_Second,
               Release_Speed => S_Half_Second);
         Set_Attack (Env, 0);
      end if;

      --  Strike
      if Do_Strike.Event = On
        or else
          (Re_Trig > 0 and then Value (Env) < 1000)
      then

         if Do_Strike.Event = On then
            Re_Trig := 3;
            Do_Strike.Event := None;
         else
            Re_Trig := Re_Trig - 1;
         end if;

         if Re_Trig = 0 then
            --  Last clap
            Set_Release (Env, Decay_Param);
         else
            --  First claps
            Set_Release (Env, Sync_Param / 8);
         end if;

         On (Env, Do_Strike.Velocity);
      end if;

      Set_Frequency (Filter, Param_Range (Pitch + 2 * Octave));
      Set_Resonance (Filter, Tone_Param);

      --  Control curve: Drive to the power of 2
      Drive_Amount := U32 (Drive_Param);
      Drive_Amount := Shift_Right (Drive_Amount**2, 15);
      Drive_Amount := Drive_Amount * 2;

      declare
         SD, Noise_Sample : S32;
         Fuzzed : S16;
      begin
         for Sample of Buffer loop
            Render (Env);

            Noise_Sample := (S32 (Get_Sample (Rng)) * S32 (Value (Env)) /
                               2**15);

            SD := Process (Filter, Noise_Sample);

            --  Symmetrical soft clipping
            Fuzzed := DSP.Interpolate88
              (Resources.WS_Violent_Overdrive,
               U16 (SD + 32_768));

            --  Mix clean and overdrive signals
            SD := S32 (DSP.Mix (S16 (SD), Fuzzed, U16 (Drive_Amount)));

            Sample := S16 (SD);
         end loop;
      end;
   end Render_Clap;

   ------------
   -- Render --
   ------------

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      Render_Clap (Buffer,
                   This.Params,
                   This.Filter,
                   This.Rng,
                   This.Env,
                   This.Re_Trig,
                   This.Pitch,
                   This.Do_Init,
                   This.Do_Strike);
   end Render;

end Tresses.Drums.Clap;
