with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.FM_OP2
with Preelaborate
is

   procedure Render_FM_OP2
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AD.Instance;
      Phase           : in out U32;
      Modulator_Phase : in out U32;
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

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Modulation => "MOD",
          when P_Detune     => "DET",
          when P_Attack     => "ATK",
          when P_Decay      => "DCY");

end Tresses.Voices.FM_OP2;
