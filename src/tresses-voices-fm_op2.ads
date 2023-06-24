with Tresses.Envelopes.AR;

package Tresses.Voices.FM_OP2
with Preelaborate
is

   procedure Render_FM_OP2
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AR.Instance;
      Phase           : in out U32;
      Modulator_Phase : in out U32;
      Pitch           :        Pitch_Range;
      Do_Init         : in out Boolean;
      Do_Strike       : in out Strike_State);

   P_Modulation : constant Param_Id := 1;
   P_Detune     : constant Param_Id := 2;
   P_Attack     : constant Param_Id := 3;
   P_Release    : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Modulation => "Modulation",
          when P_Detune     => "Detune",
          when P_Attack     => "Attack",
          when P_Release    => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Modulation => "MOD",
          when P_Detune     => "DET",
          when P_Attack     => "ATK",
          when P_Release    => "REL");

end Tresses.Voices.FM_OP2;
