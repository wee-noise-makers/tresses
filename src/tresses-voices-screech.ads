with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;

package Tresses.Voices.Screech
with Preelaborate
is

   procedure Render_Screech
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Env             : in out Envelopes.AR.Instance;
      Filter          : in out Tresses.Filters.SVF.Instance;
      Phase           : in out U32;
      Pitch           :        Pitch_Range;
      Do_Init         : in out Boolean;
      Do_Strike       : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Cutoff  : constant Param_Id := 1;
   P_Drive   : constant Param_Id := 2;
   P_Attack  : constant Param_Id := 3;
   P_Release : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Cutoff  => "Cutoff",
          when P_Drive   => "Drive",
          when P_Attack  => "Attack",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Cutoff  => "CTF",
          when P_Drive   => "DRV",
          when P_Attack  => "ATK",
          when P_Release => "REL");

end Tresses.Voices.Screech;
