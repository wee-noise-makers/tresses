with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;
with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Analog_Macro is

   -----------------
   -- Param_Label --
   -----------------

   function Param_Label (Shape : Analog_Macro_Shape; Id : Param_Id)
                         return String
   is (case Id is
          when 1 => (case Shape is
                        when Morph => "Waveform",
                        when Buzz  => "Waveform"),
          when 2 => (case Shape is
                        when Morph => "Tone",
                        when Buzz  => "Detune"),
          when 3 => "Attack",
          when 4 => "Decay");

   function Param_Short_Label (Shape : Analog_Macro_Shape; Id : Param_Id)
                               return Short_Label
   is (case Id is
          when 1 => (case Shape is
                        when Morph => "WAV",
                        when Buzz  => "WAV"),
          when 2 => (case Shape is
                        when Morph => "TON",
                        when Buzz  => "DET"),
          when 3 => "ATK",
          when 4 => "DCY");

   -----------------
   -- Render_Buzz --
   -----------------

   procedure Render_Buzz
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Param1, Param2     :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      Pitch              :        Pitch_Range)
   is
      Sample : S32;
   begin
      Osc0.Set_Param (0, Param1);
      Osc0.Set_Shape (Analog_Oscillator.Buzz);
      Osc0.Set_Pitch (Pitch);

      Osc1.Set_Param (0, Param1);
      Osc1.Set_Shape (Analog_Oscillator.Buzz);

      declare
         Pitch_Shift : constant Pitch_Range :=
           Pitch_Range (Param2 / 2**8);
      begin
         if Pitch <= Pitch_Range'Last - Pitch_Shift then
            Osc1.Set_Pitch (Pitch + Pitch_Shift);
         else
            Osc1.Set_Pitch (Pitch);
         end if;
      end;

      Osc0.Render (Buffer_A);
      Osc1.Render (Buffer_B);

      for Idx in Buffer_A'Range loop
         Sample := S32 ((Buffer_A (Idx) / 2) + (Buffer_B (Idx) / 2));

         Render (Env);
         Sample := (Sample * S32 (Low_Pass (Env))) / 2**15;

         Buffer_A (Idx) := S16 (Sample);
      end loop;

   end Render_Buzz;

   ------------------
   -- Render_Morph --
   ------------------

   procedure Render_Morph
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Param1, Param2     :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      LP_State           : in out S32;
      Pitch              :        Pitch_Range)
   is
      Sample : S32;
      Shifted_Sample : S32;
      Fuzzed : S16;
      Balance : U16;
      LP_Cutoff : S32;
      F : S32;
      Fuzz_Amount : S32;

      Pitch_Limit : constant := 80 * 2**7;
   begin
      Osc0.Set_Pitch (Pitch);
      Osc1.Set_Pitch (Pitch);

      case Param1 is
         when Param_Range'First .. 10_922 =>
            Osc0.Set_Param (0, 0);
            Osc1.Set_Param (0, 0);
            Osc0.Set_Shape (Analog_Oscillator.Triangle);
            Osc1.Set_Shape (Analog_Oscillator.Saw);
            Balance := U16 (Param1) * 6;

         when 10_923 .. 21_845 =>
            Osc0.Set_Param (0, 0);
            Osc1.Set_Param (0, 0);
            Osc0.Set_Shape (Analog_Oscillator.Square);
            Osc1.Set_Shape (Analog_Oscillator.Saw);
            Balance := U16'Last - ((U16 (Param1) - 10_923) * 6);

         when 21_846 .. Param_Range'Last =>
            Osc0.Set_Param (0, (Param1 - 21_846) * 3);
            Osc1.Set_Param (0, 0);
            Osc0.Set_Shape (Analog_Oscillator.Square);
            Osc1.Set_Shape (Analog_Oscillator.Sine);
            Balance := 0;
      end case;

      Osc0.Render (Buffer_A);
      Osc1.Render (Buffer_B);

      LP_Cutoff := S32 (Pitch) - (S32 (Param2) / 2) + 128 * 128;
      DSP.Clip (LP_Cutoff, 0, 32_767);

      F := S32 (DSP.Interpolate824
                (Resources.LUT_Svf_Cutoff, U32 (LP_Cutoff * 2**16)));

      Fuzz_Amount := S32 (Param2) * 2;
      if Pitch > Pitch_Limit then
         Fuzz_Amount := Fuzz_Amount - ((S32 (Pitch) - Pitch_Limit) * 2**4);
         if Fuzz_Amount < 0 then
            Fuzz_Amount := 0;
         end if;
      end if;

      for Idx in Buffer_A'Range loop
         Sample := S32 (DSP.Mix (Buffer_A (Idx), Buffer_B (Idx), Balance));

         LP_State := LP_State + (((Sample - LP_State) * F) / 2**15);
         DSP.Clip_S16 (LP_State);

         Shifted_Sample := LP_State + 32_768;

         Fuzzed := DSP.Interpolate88 (Resources.WS_Violent_Overdrive,
                                      U16 (Shifted_Sample));

         Sample := S32 (DSP.Mix (S16 (Sample), Fuzzed, U16 (Fuzz_Amount)));

         Render (Env);
         Sample := (Sample * S32 (Low_Pass (Env))) / 2**15;
         Buffer_A (Idx) := S16 (Sample);
      end loop;

   end Render_Morph;

   -------------------------
   -- Render_Analog_Macro --
   -------------------------

   procedure Render_Analog_Macro
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Shape              :        Analog_Macro_Shape;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      LP_State           : in out S32;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
   is
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env, Do_Hold => True);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Attack (Env, Params (3));
      Set_Decay (Env, Params (4));

      case Shape is
         when Buzz =>
            Render_Buzz
              (Buffer_A, Buffer_B,
               Params (1), Params (2),
               Osc0, Osc1,
               Env, Pitch);

         when Morph =>
            Render_Morph
              (Buffer_A, Buffer_B,
               Params (1), Params (2),
               Osc0, Osc1,
               Env,
               LP_State, Pitch);
      end case;

   end Render_Analog_Macro;

end Tresses.Voices.Analog_Macro;
