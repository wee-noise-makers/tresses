with Tresses.Envelopes.AD;
with Tresses.Analog_Oscillator;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Analog_Macro
with Preelaborate
is

   type Analog_Macro_Shape is (Buzz);

   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with private;

   procedure Set_Shape (This : in out Instance; Shape : Analog_Macro_Shape);

   procedure Render (This               : in out Instance;
                     Buffer_A, Buffer_B :    out Mono_Buffer)
     with Pre => Buffer_A'First = Buffer_B'First
               and then
                 Buffer_A'Last = Buffer_B'Last;

   procedure Render_Analog_Macro
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Shape              :        Analog_Macro_Shape;
      Param1, Param2     :        Param_Range;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AD.Instance;
      Pitch              :        Pitch_Range;
      Do_Strike          : in out Boolean)
     with Pre => Buffer_A'First = Buffer_B'First
               and then
                 Buffer_A'Last = Buffer_B'Last;

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range);

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range);

   overriding
   procedure Set_Attack (This : in out Instance; A : U7);

   overriding
   procedure Set_Decay (This : in out Instance; D : U7);

private

   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with record
      Shape      : Analog_Macro_Shape := Analog_Macro_Shape'First;
      Env        : Envelopes.AD.Instance;
      Osc0, Osc1 : Analog_Oscillator.Instance;

      Pitch : Pitch_Range := Init_Pitch;

      Do_Strike : Boolean := False;

      Param1, Param2 : Param_Range := 0;
   end record;

end Tresses.Voices.Analog_Macro;
