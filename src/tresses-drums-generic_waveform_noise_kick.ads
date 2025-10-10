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

   P_Comb_Pitch   : constant Param_Id := 1;
   P_Comb_Reso    : constant Param_Id := 2;
   P_Noise_Decay  : constant Param_Id := 3;
   P_Filter_Pitch : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Comb_Pitch   => "Comb Pitch",
          when P_Comb_Reso    => "Comb Resonance",
          when P_Noise_Decay  => "Noise Decay",
          when P_Filter_Pitch => "Filter Pitch");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Comb_Pitch    => "CBP",
          when P_Comb_Reso     => "CBR",
          when P_Noise_Decay   => "NDC",
          when P_Filter_Pitch  => "FLT");

end Tresses.Drums.Generic_Waveform_Noise_Kick;
