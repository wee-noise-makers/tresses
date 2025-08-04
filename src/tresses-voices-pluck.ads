with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;
with Tresses.Analog_Oscillator;

package Tresses.Voices.Pluck
with Preelaborate
is

   procedure Render
     (Buffer    :    out Mono_Buffer;
      Params    :        Param_Array;
      Wave      :        Analog_Oscillator.Shape_Kind;
      Osc       : in out Analog_Oscillator.Instance;
      Env       : in out Envelopes.AR.Instance;
      Filter    : in out Filters.SVF.Instance;
      Pitch     :        Pitch_Range;
      Do_Init   : in out Boolean;
      Do_Strike : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Shape   : constant Param_Id := 1;
   P_Cutoff  : constant Param_Id := 2;
   P_Reso    : constant Param_Id := 3;
   P_Release : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Shape   => "Shape",
          when P_Cutoff  => "Cutoff",
          when P_Reso    => "Resonance",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Shape   => "SHP",
          when P_Cutoff  => "CTF",
          when P_Reso    => "RES",
          when P_Release => "REL");

end Tresses.Voices.Pluck;
