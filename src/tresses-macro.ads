with Tresses.Drums.Cymbal;
with Tresses.Drums.Percussion;
with Tresses.Drums.Bell;

with Tresses.Excitation;
with Tresses.Random;
with Tresses.Filters.SVF;
with Tresses.Filters.Ladder;
with Tresses.Envelopes.AR;
with Tresses.Analog_Oscillator;

with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Macro
with Preelaborate
is
   --  A macro engine that can play all sounds

   type Instance
   is new Four_Params_Voice
   with private;

   function Engine (This : Instance) return Engines
     with Linker_Section => Code_Linker_Section;

   procedure Set_Engine (This : in out Instance; E : Engines)
     with Linker_Section => Code_Linker_Section;

   procedure Next_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Prev_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Init (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Render (This               : in out Instance;
                     Buffer, Aux_Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   --  Interfaces --

   function Param_Label (Engine : Tresses.Engines; Id : Param_Id)
                         return String;

   function Param_Short_Label (Engine : Tresses.Engines; Id : Param_Id)
                               return Short_Label;

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String;

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label;

private

   type Instance
   is new Four_Params_Voice
   with record

      Engine : Engines := Engines'First;

      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter3 : Filters.SVF.Instance;
      Osc0, Osc1 : Analog_Oscillator.Instance;
      Rng : Random.Instance;
      Env0, Env1 : Envelopes.AR.Instance;

      Ladder : Filters.Ladder.Instance;

      LP_State : S32 := 0;
      Cym_State : Drums.Cymbal.Cymbal_State;
      Bell_State : Drums.Bell.Additive_State;
      Perc_State : Drums.Percussion.Additive_State;
      Phase : U32 := 0;
      Modulator_Phase : U32 := 0;
      Target_Phase_Increment, Phase_Increment : U32 := 0;

      Saw_Swarm_State : Voices.Saw_Swarm.Saw_Swarm_State;
      Pluck_State : Voices.Plucked.Pluck_State;
      KS          : Voices.Plucked.KS_Array;

      Do_Init : Boolean := True;

   end record;

end Tresses.Macro;
