with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;
with Tresses.Analog_Oscillator;
with Tresses.Filters.Ladder;

package Tresses.Voices.Acid
with Preelaborate
is

   procedure Render_Acid
     (Buffer             :    out Mono_Buffer;
      Params             :        Interfaces.Param_Array;
      Osc0               : in out Analog_Oscillator.Instance;
      A_Env, F_Env       : in out Envelopes.AD.Instance;
      Filter             : in out Filters.Ladder.Instance;
      Pitch              :        Pitch_Range;
      Do_Init            : in out Boolean;
      Do_Strike          : in out Boolean);

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

end Tresses.Voices.Acid;
