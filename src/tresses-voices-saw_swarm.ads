with Tresses.Random;
with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Saw_Swarm
with Preelaborate
is
   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with private;

   procedure Set_Detune (This : in out Instance; P0 : Param_Range);

   procedure Set_High_Pass (This : in out Instance; P1 : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   type Saw_Swarm_State is private;

   procedure Render_Saw_Swarm
     (Buffer                        :    out Mono_Buffer;
      Detune_Param, High_Pass_Param :        Param_Range;
      Rng                           : in out Random.Instance;
      Env                           : in out Envelopes.AD.Instance;
      State                         : in out Saw_Swarm_State;
      Phase                         : in out U32;
      Pitch                         :        Pitch_Range;
      Do_Strike                     : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This : in out Instance; Pitch : Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Detune;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_High_Pass;

   overriding
   procedure Set_Attack (This : in out Instance; A : U7);

   overriding
   procedure Set_Decay (This : in out Instance; D : U7);

private

   type Phase_Array is array (0 .. 5) of U32;
   type Filter_State_Matrix is array (0 .. 1, 0 .. 1) of S32;

   type Saw_Swarm_State is record
      Phase : Phase_Array := (others => 0);
      DC_Blocked : S32 := 0;
      LP : S32 := 0;
      BP : S32 := 0;
   end record;

   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with record
      State : Saw_Swarm_State;

      Env   : Envelopes.AD.Instance;
      Rng   : Random.Instance;

      Pitch : Pitch_Range := Init_Pitch;
      Phase : U32 := 0;

      Do_Strike : Boolean := False;

      Detune_Param : Param_Range := 0;
      High_Pass_Param : Param_Range := 0;
   end record;

end Tresses.Voices.Saw_Swarm;
