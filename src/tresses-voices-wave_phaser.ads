with Tresses.Envelopes.AR;
with Tresses.Resources;

package Tresses.Voices.Wave_Phaser
with Preelaborate
is
   type Wave_Ref is not null access constant Resources.Table_257_S16;

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Phase1, Phase2   : in out U32;
      Phase_Increment  : in out U32;
      Wave             : Wave_Ref;
      Env              : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Phaser  : constant Param_Id := 1;
   P_Fold    : constant Param_Id := 2;
   P_Attack  : constant Param_Id := 3;
   P_Release : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Phaser  => "Phaser",
          when P_Fold    => "Fold",
          when P_Attack  => "Attack",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Phaser  => "PHZ",
          when P_Fold    => "FLD",
          when P_Attack  => "ATK",
          when P_Release => "REL");

end Tresses.Voices.Wave_Phaser;
