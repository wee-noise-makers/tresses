with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.FM_OP6
with Preelaborate
is

   procedure Render_FM_OP6
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Pitch           :        Pitch_Range;
      Do_Strike       : in out Boolean);

   P_Modulation : constant Param_Id := 1;
   P_Detune     : constant Param_Id := 2;
   P_Attack     : constant Param_Id := 3;
   P_Decay      : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Modulation => "Modulation",
          when P_Detune     => "Detune",
          when P_Attack     => "Attack",
          when P_Decay      => "Decay");

end Tresses.Voices.FM_OP6;
