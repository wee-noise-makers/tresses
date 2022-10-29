with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Random;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Macro
with Preelaborate
is
   --  A macro engine that can play all the drum sounds

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   function Engine (This : Instance) return Synth_Engines;
   procedure Set_Engine (This : in out Instance; E : Synth_Engines);
   procedure Next_Engine (This : in out Instance);
   procedure Prev_Engine (This : in out Instance);

   procedure Init (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This : in out Instance;
                        Pitch : S16);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range);

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range);

private

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record

      Engine : Synth_Engines := Synth_Engines'First;

      Saw_Swarm_State : Saw_Swarm.Saw_Swarm_State;
      Pluck_State : Plucked.Pluck_State;
      KS          : Plucked.KS_Array;
      Rng : Random.Instance;

      Pitch : S16 := 12 * 128 * 4;
      Phase : U32 := 0;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      P1, P2 : Param_Range := 0;
   end record;

end Tresses.Voices.Macro;
