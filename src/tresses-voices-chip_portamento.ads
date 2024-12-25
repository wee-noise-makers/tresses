with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;
with Tresses.Analog_Oscillator;

package Tresses.Voices.Chip_Portamento
with Preelaborate
is

   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Start_Phase_Incr       : in out U32;
      Current_Phase_Incr     : in out U32;
      Target_Phase_Incr      : in out U32;
      Osc                    : in out Analog_Oscillator.Instance;
      Env, Shape_Env         : in out Envelopes.AR.Instance;
      Filter                 : in out Filters.SVF.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Shape_Release : constant Param_Id := 1;
   P_Cutoff        : constant Param_Id := 2;
   P_Attack        : constant Param_Id := 3;
   P_Release       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Shape_Release => "Glide",
          when P_Cutoff        => "Shape",
          when P_Attack        => "Attack",
          when P_Release       => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Shape_Release => "GLI",
          when P_Cutoff        => "SHP",
          when P_Attack        => "ATK",
          when P_Release       => "REL");

end Tresses.Voices.Chip_Portamento;
