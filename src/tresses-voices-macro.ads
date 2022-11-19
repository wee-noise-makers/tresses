with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Random;
with Tresses.Envelopes.AD;
with Tresses.Analog_Oscillator;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Macro
with Preelaborate
is
   --  A macro engine that can play all the synth sounds

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   function Engine (This : Instance) return Synth_Engines;
   procedure Set_Engine (This : in out Instance; E : Synth_Engines);
   procedure Next_Engine (This : in out Instance);
   procedure Prev_Engine (This : in out Instance);

   procedure Init (This : in out Instance);

   procedure Render (This               : in out Instance;
                     Buffer, Aux_Buffer :    out Mono_Buffer);

   procedure Set_Attack (This : in out Instance; A : U7);
   procedure Set_Decay (This : in out Instance; D : U7);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

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
      Rng         : Random.Instance;
      Env         : Envelopes.AD.Instance;
      Osc0, Osc1  : Analog_Oscillator.Instance;

      Pitch : Pitch_Range := Init_Pitch;
      Phase : U32 := 0;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      P1, P2 : Param_Range := 0;
   end record;

end Tresses.Voices.Macro;
