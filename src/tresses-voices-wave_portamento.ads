with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;
with Tresses.Resources;

package Tresses.Voices.Wave_Portamento
with Preelaborate
is
   type Wave_Ref is not null access constant Resources.Table_257_S16;

   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Start_Phase_Incr       : in out U32;
      Current_Phase_Incr     : in out U32;
      Target_Phase_Incr      : in out U32;
      Wave                   : Wave_Ref;
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
          when P_Cutoff        => "Cutoff",
          when P_Attack        => "Attack",
          when P_Release       => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Shape_Release => "GLI",
          when P_Cutoff        => "CTF",
          when P_Attack        => "ATK",
          when P_Release       => "REL");

end Tresses.Voices.Wave_Portamento;
