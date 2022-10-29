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

   procedure Set_Decay (This : in out Instance; Decay : U16);
   procedure Set_Coefficient (This : in out Instance; Coef : U16);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_Kick (Buffer                 :     out Mono_Buffer;
                          Decay, Coefficient     :        U16;
                          Pulse0, Pulse1, Pulse2 : in out Excitation.Instance;
                          Filter                 : in out Filters.SVF.Instance;
                          LP_State               : in out S32;
                          Pitch                  :        S16;
                          Do_Init                : in out Boolean;
                          Do_Strike              : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This : in out Instance;
                        Pitch : S16);

   overriding
   procedure Set_Param1 (This : in out Instance; P : U16)
   renames Set_Decay;

   overriding
   procedure Set_Param2 (This : in out Instance; P : U16)
   renames Set_Coefficient;

private

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record
      Pulse0, Pulse1, Pulse2 : Excitation.Instance;
      Filter : Filters.SVF.Instance;

      Pitch : S16 := 3000;
      LP_State : S32 := 0;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      Decay : U16 := 0;
      Coefficient : U16 := 0;
   end record;

end Tresses.Drums.Kick;
