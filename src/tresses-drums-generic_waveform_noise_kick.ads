with Tresses.Envelopes.AR;
with Tresses.Resources;
with Tresses.Random;

generic
   Tone_Waveform : not null access constant Tresses.Resources.Table_257_S16;
package Tresses.Drums.Generic_Waveform_Noise_Kick
with Preelaborate
is

   procedure Render_Kick
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
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
   P_Noise       : constant Param_Id := 3;
   P_Decay       : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay       => "Decay",
          when P_Noise       => "Noise",
          when P_Punch       => "Punch",
          when P_Punch_Decay => "Punch Decay");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay       => "DCY",
          when P_Noise       => "NOI",
          when P_Punch       => "PCH",
          when P_Punch_Decay => "PDC");

end Tresses.Drums.Generic_Waveform_Noise_Kick;
