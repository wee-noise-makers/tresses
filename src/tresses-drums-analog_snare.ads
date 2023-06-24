with Tresses.Random;
with Tresses.Filters.SVF;
with Tresses.Envelopes.AR;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Analog_Snare
with Preelaborate
is

   procedure Render_Analog_Snare
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Target_Phase_Increment : in out U32;
      Filter                 : in out Tresses.Filters.SVF.Instance;
      Tone_Env, Noise_Env    : in out Envelopes.AR.Instance;
      Rng                    : in out Random.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State);

   P_Decay : constant Param_Id := 1;
   P_Noise_Decay : constant Param_Id := 2;
   P_Noise : constant Param_Id := 3;
   P_Punch : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay => "Tone Decay",
          when P_Noise_Decay => "Noise Decay",
          when P_Noise => "Noise",
          when P_Punch => "Punch");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay => "DCY",
          when P_Noise_Decay => "NCY",
          when P_Noise => "NOS",
          when P_Punch => "PCH");

   -- Interfaces --

   type Instance
   is new Four_Params_Voice
   with private;

   overriding
   function Param_Label (This : Instance; Id : Param_Id)
                         return String
   is (Param_Label (Id));

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (Param_Short_Label (Id));

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

private

   type Instance
   is new Four_Params_Voice
   with record
      Env1, Env2        : Envelopes.AR.Instance;
      Phase, Target_Phase_Increment, Phase_Increment : U32 := 0;

      Filter : Tresses.Filters.SVF.Instance;
      Rng : Tresses.Random.Instance;

      Do_Init        : Boolean := True;
   end record;

end Tresses.Drums.Analog_Snare;
