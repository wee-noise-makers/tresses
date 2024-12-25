with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;

package Tresses.Voices.Chip_Echo
with Preelaborate
is

   procedure Render
     (BufferA, BufferB :    out Mono_Buffer;
      Params           :        Param_Array;
      Osc_Select       : in out U32;
      Retrig1          : in out U32;
      Retrig2          : in out U32;
      Pitch1, Pitch2   : in out Pitch_Range;
      Osc1, Osc2       : in out Analog_Oscillator.Instance;
      Shape1, Shape2   :        Analog_Oscillator.Shape_Kind;
      Env1, Env2       : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Time        : constant Param_Id := 1;
   P_Repeats : constant Param_Id := 2;
   P_Shape       : constant Param_Id := 3;
   P_Release     : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Time    => "Time",
          when P_Repeats => "Repeats",
          when P_Shape   => "Shape",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Time    => "TIM",
          when P_Repeats => "REP",
          when P_Shape   => "SHP",
          when P_Release => "REL");

end Tresses.Voices.Chip_Echo;
