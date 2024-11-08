with Tresses.Envelopes.AR;
with Tresses.Phase_Distortion_Oscillator;

package Tresses.Voices.Phase_Distortion
with Preelaborate
is

   package PDO renames Tresses.Phase_Distortion_Oscillator;

   generic
      with procedure Render_Osc (This    : in out PDO.Instance;
                                 Buffer  :    out Mono_Buffer;
                                 Amount  :        Param_Range;
                                 Release :        Param_Range);
   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Osc                    : in out Phase_Distortion_Oscillator.Instance;
      Env                    : in out Envelopes.AR.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State);

   P_Distort       : constant Param_Id := 1;
   P_Shape_Release : constant Param_Id := 2;
   P_Attack        : constant Param_Id := 3;
   P_Release       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Shape_Release => "Distort Release",
          when P_Distort       => "Distort",
          when P_Attack        => "Attack",
          when P_Release       => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Shape_Release => "SHP",
          when P_Distort       => "DIS",
          when P_Attack        => "ATK",
          when P_Release       => "REL");

end Tresses.Voices.Phase_Distortion;
