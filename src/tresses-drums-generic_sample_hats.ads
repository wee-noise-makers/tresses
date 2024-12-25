with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;

generic
   Open_Sample  : not null access constant S8_Array;
   Close_Sample : not null access constant S8_Array;
package Tresses.Drums.Generic_Sample_Hats
with Preelaborate
is

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Filter           : in out Filters.SVF.Instance;
      Env              : in out Envelopes.AR.Instance;
      Phase            : in out U32;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Mix       : constant Param_Id := 1;
   P_Cutoff    : constant Param_Id := 2;
   P_Resonance : constant Param_Id := 3;
   P_Release   : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Mix       => "O/C Mix",
          when P_Cutoff    => "Cutoff",
          when P_Resonance => "Resonance",
          when P_Release   => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Mix       => "MIX",
          when P_Cutoff    => "CTF",
          when P_Resonance => "RES",
          when P_Release   => "REL");

end Tresses.Drums.Generic_Sample_Hats;
