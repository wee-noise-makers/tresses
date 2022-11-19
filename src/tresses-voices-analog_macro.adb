with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Analog_Macro is

   ---------------
   -- Set_Shape --
   ---------------

   procedure Set_Shape (This : in out Instance; Shape : Analog_Macro_Shape) is
   begin
      This.Shape := Shape;
   end Set_Shape;

   ------------
   -- Render --
   ------------

   procedure Render (This               : in out Instance;
                     Buffer_A, Buffer_B :    out Mono_Buffer)
   is
   begin
      Render_Analog_Macro (Buffer_A, Buffer_B,
                           This.Shape,
                           This.Param1, This.Param2,
                           This.Osc0, This.Osc1,
                           This.Env,
                           This.LP_State,
                           This.Pitch,
                           This.Do_Strike);
   end Render;

   -----------------
   -- Render_Buzz --
   -----------------

   procedure Render_Buzz
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Param1             :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      Pitch              :        Pitch_Range)
   is
      Sample : S32;
   begin
      Osc0.Set_Param1 (Param1);
      Osc0.Set_Shape (Analog_Oscillator.Buzz);
      Osc0.Set_Pitch (Pitch);

      Osc1.Set_Param1 (Param1);
      Osc1.Set_Shape (Analog_Oscillator.Buzz);

      declare
         Pitch_Shift : constant Pitch_Range :=
           Pitch_Range (Param1 / 2**8);
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

         Sample := (Sample * S32 (Render (Env))) / 2**15;

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
            Osc0.Set_Param1 (0);
            Osc1.Set_Param1 (0);
            Osc0.Set_Shape (Analog_Oscillator.Triangle);
            Osc1.Set_Shape (Analog_Oscillator.Saw);
            Balance := U16 (Param1) * 6;

         when 10_923 .. 21_845 =>
            Osc0.Set_Param1 (0);
            Osc1.Set_Param1 (0);
            Osc0.Set_Shape (Analog_Oscillator.Square);
            Osc1.Set_Shape (Analog_Oscillator.Saw);
            Balance := U16'Last - ((U16 (Param1) - 10_923) * 6);

         when 21_846 .. Param_Range'Last =>
            Osc0.Set_Param1 ((Param1 - 21_846) * 3);
            Osc1.Set_Param1 (0);
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
         Sample := (Sample * S32 (Render (Env))) / 2**15;
         Buffer_A (Idx) := S16 (Sample);
      end loop;

   end Render_Morph;

   -------------------------
   -- Render_Analog_Macro --
   -------------------------

   procedure Render_Analog_Macro
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Shape              :        Analog_Macro_Shape;
      Param1, Param2     :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      LP_State           : in out S32;
      Pitch              :        Pitch_Range;
      Do_Strike          : in out Boolean)
   is
   begin
      if Do_Strike then
         Do_Strike := False;
         Envelopes.AD.Trigger (Env, Envelopes.AD.Attack);
      end if;

      case Shape is
         when Buzz =>
            Render_Buzz
              (Buffer_A, Buffer_B, Param1, Osc0, Osc1, Env, Pitch);
         when Morph =>
            Render_Morph
              (Buffer_A, Buffer_B,
               Param1, Param2,
               Osc0, Osc1,
               Env,
               LP_State, Pitch);
      end case;

   end Render_Analog_Macro;

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

   ----------------
   -- Set_Param1 --
   ----------------

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range) is
   begin
      This.Param1 := P;
   end Set_Param1;

   ----------------
   -- Set_Param2 --
   ----------------

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range) is
   begin
      This.Param2 := P;
   end Set_Param2;

   ----------------
   -- Set_Attack --
   ----------------

   overriding
   procedure Set_Attack (This : in out Instance; A : U7) is
   begin
      Envelopes.AD.Set_Attack (This.Env, A);
   end Set_Attack;

   ---------------
   -- Set_Decay --
   ---------------

   overriding
   procedure Set_Decay (This : in out Instance; D : U7) is
   begin
      Envelopes.AD.Set_Decay (This.Env, D);
   end Set_Decay;

end Tresses.Voices.Analog_Macro;
