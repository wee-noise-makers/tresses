with Tresses.Random;

package Tresses.Voices.Saw_Swarm
with Preelaborate
is
   type Instance is private;

   procedure Set_Detune (This : in out Instance; P0 : U16);

   procedure Set_High_Pass (This : in out Instance; P1 : U16);

   procedure Strike (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   type Saw_Swarm_State is private;

   procedure Render_Saw_Swarm
     (Buffer                        :    out Mono_Buffer;
      Detune_Param, High_Pass_Param :        U16;
      Rng                           : in out Random.Instance;
      State                         : in out Saw_Swarm_State;
      Phase                         : in out U32;
      Pitch                         :        S16;
      Do_Strike                     : in out Boolean);
private

   type Phase_Array is array (0 .. 5) of U32;
   type Filter_State_Matrix is array (0 .. 1, 0 .. 1) of S32;

   type Saw_Swarm_State is record
      Phase : Phase_Array := (others => 0);
      DC_Blocked : S32 := 0;
      LP : S32 := 0;
      BP : S32 := 0;
   end record;

   type Instance is record
      State : Saw_Swarm_State;

      Rng   : Random.Instance;

      Pitch : S16 := 12 * 128 * 4;
      Phase : U32 := 0;

      Do_Strike : Boolean := False;

      Detune_Param : U16 := 0;
      High_Pass_Param : U16 := 0;
   end record;

end Tresses.Voices.Saw_Swarm;
