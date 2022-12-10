with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Kick
with Preelaborate
is

   procedure Render_Kick (Buffer                 :    out Mono_Buffer;
                          Params                 :        Param_Array;
                          Pulse0, Pulse1, Pulse2 : in out Excitation.Instance;
                          Filter                 : in out Filters.SVF.Instance;
                          LP_State               : in out S32;
                          Pitch                  :        Pitch_Range;
                          Do_Init                : in out Boolean;
                          Do_Strike              : in out Boolean);

   P_Decay       : constant Param_Id := 1;
   P_Coefficient : constant Param_Id := 2;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay       => "Decay",
          when P_Coefficient => "Coefficient",
          when others        => "N/A");

end Tresses.Drums.Kick;
