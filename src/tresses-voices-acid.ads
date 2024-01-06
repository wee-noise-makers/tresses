with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;
with Tresses.Filters.Ladder;

package Tresses.Voices.Acid
with Preelaborate
is

   procedure Render_Acid
     (Buffer             :    out Mono_Buffer;
      Params             :        Param_Array;
      Osc0               : in out Analog_Oscillator.Instance;
      F_Env              : in out Envelopes.AR.Instance;
      Filter             : in out Filters.Ladder.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Cutoff    : constant Param_Id := 1;
   P_Resonance : constant Param_Id := 2;
   P_F_EG_Int  : constant Param_Id := 3;
   P_F_Decay   : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Cutoff     => "Cutoff",
          when P_Resonance  => "Resonance",
          when P_F_EG_Int   => "Filter Int",
          when P_F_Decay    => "Filter Decay");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Cutoff     => "CTF",
          when P_Resonance  => "RES",
          when P_F_EG_Int   => "FIT",
          when P_F_Decay    => "FDY");

end Tresses.Voices.Acid;
