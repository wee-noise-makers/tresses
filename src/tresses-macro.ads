with Tresses.Drums.Cymbal;
with Tresses.Drums.Percussion;
with Tresses.Drums.Bell;

with Tresses.Excitation;
with Tresses.Random;
with Tresses.Filters.SVF;
with Tresses.Envelopes.AD;

with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Macro
with Preelaborate
is
   --  A macro engine that can play all sounds

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   function Engine (This : Instance) return Engines;
   procedure Set_Engine (This : in out Instance; E : Engines);
   procedure Next_Engine (This : in out Instance);
   procedure Prev_Engine (This : in out Instance);

   procedure Init (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

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

      Engine : Engines := Engines'First;

      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter3 : Filters.SVF.Instance;
      Rng : Random.Instance;
      Env : Envelopes.AD.Instance;

      Pitch : Pitch_Range := Init_Pitch;

      LP_State : S32 := 0;
      Cym_State : Drums.Cymbal.Cymbal_State;
      Bell_State : Drums.Bell.Additive_State;
      Perc_State : Drums.Percussion.Additive_State;
      Phase : U32 := 0;

      Saw_Swarm_State : Voices.Saw_Swarm.Saw_Swarm_State;
      Pluck_State : Voices.Plucked.Pluck_State;
      KS          : Voices.Plucked.KS_Array;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      P1, P2 : Param_Range := 0;
   end record;

end Tresses.Macro;
