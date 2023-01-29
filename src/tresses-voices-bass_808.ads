with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;
with Tresses.Random;

package Tresses.Voices.Bass_808
with Preelaborate
is

   procedure Render_Bass_808
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env                    : in out Envelopes.AR.Instance;
      Rng                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State);

   P_Drive       : constant Param_Id := 1;
   P_Punch       : constant Param_Id := 2;
   P_Attack      : constant Param_Id := 3;
   P_Release     : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Drive   => "Drive",
          when P_Punch   => "Punch",
          when P_Attack  => "Attack",
          when P_Release => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Drive   => "DRV",
          when P_Punch   => "PCH",
          when P_Attack  => "ATK",
          when P_Release => "REL");

end Tresses.Voices.Bass_808;
