with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Random;
with Tresses.Envelopes.AD;
with Tresses.Filters.Ladder;
with Tresses.Analog_Oscillator;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Macro
with Preelaborate
is
   --  A macro engine that can play all the synth sounds

   type Instance
   is new Four_Params_Voice
   with private;

   function Engine (This : Instance) return Synth_Engines;
   procedure Set_Engine (This : in out Instance; E : Synth_Engines);
   procedure Next_Engine (This : in out Instance);
   procedure Prev_Engine (This : in out Instance);

   procedure Init (This : in out Instance);

   procedure Render (This               : in out Instance;
                     Buffer, Aux_Buffer :    out Mono_Buffer);

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String;

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label;

private

   type Instance
   is new Four_Params_Voice
   with record

      Engine : Synth_Engines := Synth_Engines'First;

      Saw_Swarm_State : Saw_Swarm.Saw_Swarm_State;
      Pluck_State : Plucked.Pluck_State;
      KS          : Plucked.KS_Array;
      Rng         : Random.Instance;
      Env0, Env1  : Envelopes.AD.Instance;
      Osc0, Osc1  : Analog_Oscillator.Instance;
      Ladder      : Filters.Ladder.Instance;
      LP_State : S32 := 0;

      Phase : U32 := 0;
      Modulator_Phase : U32 := 0;

      Do_Init : Boolean := True;
   end record;

end Tresses.Voices.Macro;
