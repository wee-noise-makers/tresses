with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Interfaces; use Tresses.Interfaces;
package Tresses.Drums.Kick
with Preelaborate
is
   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   procedure Init (This : in out Instance);

   procedure Set_Decay (This : in out Instance; Decay : Param_Range);
   procedure Set_Coefficient (This : in out Instance; Coef : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_Kick (Buffer                 :     out Mono_Buffer;
                          Decay, Coefficient     :        Param_Range;
                          Pulse0, Pulse1, Pulse2 : in out Excitation.Instance;
                          Filter                 : in out Filters.SVF.Instance;
                          LP_State               : in out S32;
                          Pitch                  :        Pitch_Range;
                          Do_Init                : in out Boolean;
                          Do_Strike              : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Decay;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_Coefficient;

private

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record
      Pulse0, Pulse1, Pulse2 : Excitation.Instance;
      Filter : Filters.SVF.Instance;

      Pitch : Pitch_Range := Init_Pitch;
      LP_State : S32 := 0;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      Decay : Param_Range := 0;
      Coefficient : Param_Range := 0;
   end record;

end Tresses.Drums.Kick;
