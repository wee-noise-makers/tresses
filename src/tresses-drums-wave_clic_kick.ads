with Tresses.Envelopes.AR;
with Tresses.Resources;
with Tresses.Random;
with Tresses.Resources;

package Tresses.Drums.Wave_Clic_Kick
with Preelaborate
is

   type Wave_Ref is not null access constant Tresses.Resources.Table_257_S16;

   procedure Render_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Tone_Waveform          :        Wave_Ref;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Env, Noise_Env         : in out Envelopes.AR.Instance;
      RNG                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
     with Linker_Section => Code_Linker_Section;

   P_Punch       : constant Param_Id := 1;
   P_Punch_Decay : constant Param_Id := 2;
   P_Click       : constant Param_Id := 3;
   P_Decay       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay       => "Decay",
          when P_Click       => "Clic",
          when P_Punch       => "Punch",
          when P_Punch_Decay => "Punch Decay");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay       => "DCY",
          when P_Click       => "CLK",
          when P_Punch       => "PCH",
          when P_Punch_Decay => "PDC");

end Tresses.Drums.Wave_Clic_Kick;
