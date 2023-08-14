with Tresses.Random;
with Tresses.Envelopes.AR;

package Tresses.Voices.Saw_Swarm
with Preelaborate
is

   type Saw_Swarm_State is private;

   procedure Render_Saw_Swarm
     (Buffer    :    out Mono_Buffer;
      Params    :        Param_Array;
      Rng       : in out Random.Instance;
      Env       : in out Envelopes.AR.Instance;
      State     : in out Saw_Swarm_State;
      Phase     : in out U32;
      Pitch     :        Pitch_Range;
      Do_Init   : in out Boolean;
      Do_Strike : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Detune    : constant Param_Id := 1;
   P_High_Pass : constant Param_Id := 2;
   P_Attack    : constant Param_Id := 3;
   P_Release   : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Detune    => "Detune",
          when P_High_Pass => "High Pass",
          when P_Attack    => "Attack",
          when P_Release   => "Release");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Detune    => "DET",
          when P_High_Pass => "HIP",
          when P_Attack    => "ATK",
          when P_Release   => "REL");

private

   type Phase_Array is array (0 .. 5) of U32;
   type Filter_State_Matrix is array (0 .. 1, 0 .. 1) of S32;

   type Saw_Swarm_State is record
      Phase : Phase_Array := (others => 0);
      DC_Blocked : S32 := 0;
      LP : S32 := 0;
      BP : S32 := 0;
   end record;

end Tresses.Voices.Saw_Swarm;
