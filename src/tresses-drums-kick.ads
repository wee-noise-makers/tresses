with Tresses.Excitation;
with Tresses.Filters.SVF;

package Tresses.Drums.Kick
with Preelaborate
is
   type Instance is private;

   procedure Init (This : in out Instance);

   procedure Set_Decay (This : in out Instance; Decay : U16);
   procedure Set_Coefficient (This : in out Instance; Coef : U16);

   procedure Strike (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_Kick (Buffer                 :     out Mono_Buffer;
                          Decay, Coefficient     :        U16;
                          Pulse0, Pulse1, Pulse2 : in out Excitation.Instance;
                          Filter                 : in out Filters.SVF.Instance;
                          LP_State               : in out S32;
                          Pitch                  :        S16;
                          Do_Init                :        Boolean;
                          Do_Strike              :        Boolean);
private

   type Instance is record
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
