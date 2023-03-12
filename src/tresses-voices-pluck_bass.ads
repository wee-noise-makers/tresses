with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;
with Tresses.Random;
with Tresses.Analog_Oscillator;
with Tresses.Filters.SVF;

package Tresses.Voices.Pluck_Bass
with Preelaborate
is

   procedure Pluck_Bass
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Env, Shape_Env         : in out Envelopes.AR.Instance;
      Filter                 : in out Filters.SVF.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State);

   P_Shape_Release : constant Param_Id := 1;
   P_Cutoff        : constant Param_Id := 2;
   P_Attack        : constant Param_Id := 3;
   P_Release       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Shape_Release => "Shape Release",
          when P_Cutoff        => "Cutoff",
          when P_Attack        => "Attack",
          when P_Release       => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Shape_Release => "SHP",
          when P_Cutoff        => "CTF",
          when P_Attack        => "ATK",
          when P_Release       => "REL");

end Tresses.Voices.Pluck_Bass;
