with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Kick
with Preelaborate
is

   procedure Render_Kick
     (Buffer         :    out Mono_Buffer;
      Params         :        Param_Array;
      Pulse0, Pulse1 : in out Excitation.Instance;
      Filter         : in out Filters.SVF.Instance;
      Env            : in out Envelopes.AR.Instance;
      LP_State       : in out S32;
      Pitch          :        Pitch_Range;
      Do_Init        : in out Boolean;
      Do_Strike      : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Decay       : constant Param_Id := 1;
   P_Coefficient : constant Param_Id := 2;
   P_Drive       : constant Param_Id := 3;
   P_Punch       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay       => "Decay",
          when P_Coefficient => "Coefficient",
          when P_Drive       => "Drive",
          when others        => "Punch");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay       => "DCY",
          when P_Coefficient => "COF",
          when P_Drive       => "DRV",
          when others        => "PCH");

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
      Pulse0, Pulse1 : Excitation.Instance;
      Filter         : Filters.SVF.Instance;
      Env            : Envelopes.AR.Instance;
      LP_State       : S32;
      Do_Init        : Boolean := True;
   end record;

end Tresses.Drums.Kick;
