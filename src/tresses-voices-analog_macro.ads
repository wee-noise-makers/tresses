with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Analog_Macro
with Preelaborate
is

   type Analog_Macro_Shape is (Morph, Buzz);

   procedure Render_Analog_Macro
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Shape              :        Analog_Macro_Shape;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Env                : in out Envelopes.AR.Instance;
      LP_State           : in out S32;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
     with Pre => Buffer_A'First = Buffer_B'First
               and then
                 Buffer_A'Last = Buffer_B'Last;

   function Param_Label (Shape : Analog_Macro_Shape; Id : Param_Id)
                         return String;

   function Param_Short_Label (Shape : Analog_Macro_Shape; Id : Param_Id)
                               return Short_Label;

end Tresses.Voices.Analog_Macro;
