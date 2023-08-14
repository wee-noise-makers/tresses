with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;
with Tresses.Filters.SVF;

package Tresses.Voices.House_Bass
with Preelaborate
is

   procedure Render_House_Bass
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Filter1            : in out Filters.SVF.Instance;
      Env, F_Env         : in out Envelopes.AR.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Fold      : constant Param_Id := 1;
   P_F_Release : constant Param_Id := 2;
   P_Attack    : constant Param_Id := 3;
   P_Release   : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Fold      => "Fold",
          when P_F_Release => "F-Release",
          when P_Attack    => "Attack",
          when P_Release   => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Fold      => "FLD",
          when P_F_Release => "FRL",
          when P_Attack    => "ATK",
          when P_Release   => "REL");

end Tresses.Voices.House_Bass;
