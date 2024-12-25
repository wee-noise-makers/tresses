with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;

package Tresses.Voices.Chip_Phaser
with Preelaborate
is

   procedure Render
     (BufferA, BufferB :    out Mono_Buffer;
      Params           :        Param_Array;
      Phase_Increment  : in out U32;
      Osc1, Osc2       : in out Analog_Oscillator.Instance;
      Env              : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Phaser  : constant Param_Id := 1;
   P_Shape   : constant Param_Id := 2;
   P_Attack  : constant Param_Id := 3;
   P_Release : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Phaser  => "Phaser",
          when P_Shape   => "Shape",
          when P_Attack  => "Attack",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Phaser  => "PHZ",
          when P_Shape   => "SHP",
          when P_Attack  => "ATK",
          when P_Release => "REL");

end Tresses.Voices.Chip_Phaser;
