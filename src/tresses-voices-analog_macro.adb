with Tresses.Envelopes.AD; use Tresses.Envelopes.AD;

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
                           This.Pitch,
                           This.Do_Strike);
   end Render;

   -------------------------
   -- Render_Analog_Macro --
   -------------------------

   procedure Render_Analog_Macro
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Shape              :        Analog_Macro_Shape;
      Param1, Param2     :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      Pitch              :        Pitch_Range;
      Do_Strike          : in out Boolean)
   is
      pragma Unreferenced (Param2);

      Sample : S32;
   begin
      if Do_Strike then
         Do_Strike := False;
         Envelopes.AD.Trigger (Env, Envelopes.AD.Attack);
      end if;

      case Shape is
      when Buzz =>
         Osc0.Set_Param1 (Param1);
         Osc0.Set_Shape (Analog_Oscillator.Buzz);
         Osc0.Set_Pitch (Pitch);

         Osc1.Set_Param1 (Param1);
         Osc1.Set_Shape (Analog_Oscillator.Buzz);
         Osc1.Set_Pitch (Pitch + Pitch_Range (Param1 / 2**8));

         Osc0.Render (Buffer_A);
         Osc1.Render (Buffer_B);

         for Idx in Buffer_A'Range loop
            Sample := S32 ((Buffer_A (Idx) / 2) + (Buffer_B (Idx) / 2));

            Sample := (Sample * S32 (Render (Env))) / 2**15;

            Buffer_A (Idx) := S16 (Sample);
         end loop;
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
