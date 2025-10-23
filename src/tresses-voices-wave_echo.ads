with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;
with Tresses.Resources;

package Tresses.Voices.Wave_Echo
with Preelaborate
is

   type Wave_Ref is not null access constant Resources.Table_257_S16;

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Wave             :        Wave_Ref;
      Osc_Select       : in out U32;
      Retrig1          : in out U32;
      Retrig2          : in out U32;
      Phase1, Phase2   : in out U32;
      Pitch1, Pitch2   : in out Pitch_Range;
      Env1, Env2       : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Time    : constant Param_Id := 1;
   P_Repeats : constant Param_Id := 2;
   P_Fold    : constant Param_Id := 3;
   P_Release : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Time    => "Time",
          when P_Repeats => "Repeats",
          when P_Fold    => "Fold",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Time    => "TIM",
          when P_Repeats => "REP",
          when P_Fold    => "FLD",
          when P_Release => "REL");

end Tresses.Voices.Wave_Echo;
