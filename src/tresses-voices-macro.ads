with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Random;
with Tresses.Envelopes.AR;
with Tresses.Filters.Ladder;
with Tresses.Filters.SVF;
with Tresses.Analog_Oscillator;
with Tresses.Phase_Distortion_Oscillator;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Macro
with Preelaborate
is
   --  A macro engine that can play all the synth sounds

   type Macro_Buffers is private;

   type Instance (B : access Macro_Buffers)
   is new Four_Params_Voice
   with private;

   function Engine (This : Instance) return Synth_Engines
     with Linker_Section => Code_Linker_Section;
   procedure Set_Engine (This : in out Instance; E : Synth_Engines)
     with Linker_Section => Code_Linker_Section;
   procedure Next_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;
   procedure Prev_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Init (This : in out Instance);

   procedure Render (This               : in out Instance;
                     Buffer, Aux_Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String;

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label;

private

   type Macro_Buffers is record
      Saw_Swarm_State : Saw_Swarm.Saw_Swarm_State;
      KS              : Plucked.KS_Array;
      Pluck_State     : Plucked.Pluck_State;
   end record;

   type Instance (B : access Macro_Buffers)
   is new Four_Params_Voice
   with record

      Engine : Synth_Engines := Synth_Engines'First;

      Rng              : Random.Instance;
      Env0, Env1       : Envelopes.AR.Instance;
      Osc0, Osc1, Osc2 : Analog_Oscillator.Instance;
      PDOsc0           : Phase_Distortion_Oscillator.Instance;
      Ladder           : Filters.Ladder.Instance;
      SVF              : Filters.SVF.Instance;
      LP_State         : S32 := 0;

      Pitch1, Pitch2 : Pitch_Range;

      Phase : U32 := 0;
      Modulator_Phase : U32 := 0;
      Target_Phase_Increment, Phase_Increment : U32 := 0;

      Do_Init : Boolean := True;
   end record;

end Tresses.Voices.Macro;
