with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Analog_Kick
with Preelaborate
is

   procedure Render_Analog_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env                    : in out Envelopes.AR.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Decay       : constant Param_Id := 1;
   P_Drive       : constant Param_Id := 3;
   P_Punch       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay => "Decay",
          when P_Drive => "Drive",
          when P_Punch => "Punch",
          when others  => "N/A");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay => "DCY",
          when P_Drive => "DRV",
          when P_Punch => "PCH",
          when others  => "N/A");

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
      Env            : Envelopes.AR.Instance;
      Phase, Target_Phase_Increment, Phase_Increment : U32 := 0;

      Do_Init        : Boolean := True;
   end record;

end Tresses.Drums.Analog_Kick;
