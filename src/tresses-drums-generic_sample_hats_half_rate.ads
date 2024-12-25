with Tresses.Envelopes.AR;
with Tresses.Filters.SVF;

with Tresses.Interfaces; use Tresses.Interfaces;

generic
   Open_Sample  : not null access constant S8_Array;
   Close_Sample : not null access constant S8_Array;
package Tresses.Drums.Generic_Sample_Hats_Half_Rate
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

   -- Interfaces --

   type Instance
   is new Four_Params_Voice
   with private;

   overriding
   function Param_Label (This : Instance; Id : Param_Id)
                         return String
   is (Param_Label (Id));

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (Param_Short_Label (Id));

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

private

   type Instance
   is new Four_Params_Voice
   with record
      Filter  : Filters.SVF.Instance;
      Env     : Envelopes.AR.Instance;
      Phase   : U32;
      Do_Init : Boolean := True;
   end record;


end Tresses.Drums.Generic_Sample_Hats_Half_Rate;
