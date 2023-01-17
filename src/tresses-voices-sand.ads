with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;
with Tresses.Analog_Oscillator;
with Tresses.Filters.SVF;
with Tresses.Filters.Ladder;

package Tresses.Voices.Sand
with Preelaborate
is

   procedure Render_Sand
     (Buffer_A, Buffer_B :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0, Osc1         : in out Analog_Oscillator.Instance;
      Filter1            : in out Filters.SVF.Instance;
      Env                : in out Envelopes.AR.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State);

   P_Fold      : constant Param_Id := 1;
   P_Band_pass : constant Param_Id := 2;
   P_Attack    : constant Param_Id := 3;
   P_Release   : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Fold      => "Fold",
          when P_Band_pass => "Band-Pass",
          when P_Attack    => "Attack",
          when P_Release     => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Fold      => "FLD",
          when P_Band_pass => "BPF",
          when P_Attack    => "ATK",
          when P_Release   => "REL");

end Tresses.Voices.Sand;
