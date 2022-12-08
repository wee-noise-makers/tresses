with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.FM_OP2
with Preelaborate
is

   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with private;

   procedure Set_Decay (This : in out Instance; P0 : Param_Range);

   procedure Set_Position (This : in out Instance; P1 : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_FM_OP2
     (Buffer                      :    out Mono_Buffer;
      Param0, Param1              :        Param_Range;
      Env                         : in out Envelopes.AD.Instance;
      Phase                       : in out U32;
      Modulator_Phase             : in out U32;
      Pitch                       :        Pitch_Range;
      Do_Strike                   : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Decay;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_Position;

   overriding
   procedure Set_Attack (This : in out Instance; A : U7);

   overriding
   procedure Set_Decay (This : in out Instance; D : U7);

private

   type Instance
   is new Pitched_Voice
      and Strike_Voice
      and Two_Params_Voice
      and Envelope_Voice
   with record
      Phase : U32 := 0;
      Modulator_Phase : U32 := 0;

      Env   : Envelopes.AD.Instance;

      Pitch : Pitch_Range := Init_Pitch;

      Do_Strike : Boolean := False;

      Decay_Param : Param_Range := 0;
      Position_Param : Param_Range := 0;
   end record;

end Tresses.Voices.FM_OP2;
