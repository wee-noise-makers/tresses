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
   P_Drive       : constant Param_Id := 3;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay       => "Decay",
          when P_Coefficient => "Coefficient",
          when P_Drive       => "Drive",
          when others        => "N/A");

   -- Interfaces --

   type Instance
   is new Four_Params_Voice
   with private;

   overriding
   function Param_Label (This : Instance; Id : Param_Id)
                         return String
   is (Param_Label (Id));

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

private

   type Instance
   is new Four_Params_Voice
   with record
      Pulse0, Pulse1, Pulse2 : Excitation.Instance;
      Filter                 : Filters.SVF.Instance;
      LP_State               : S32;
      Do_Init                : Boolean := True;
   end record;

end Tresses.Drums.Kick;
