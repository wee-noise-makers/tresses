with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Random;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Snare
with Preelaborate
is
   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   procedure Init (This : in out Instance);

   procedure Set_Tone (This : in out Instance; P0 : Param_Range);

   procedure Set_Noise (This : in out Instance; P1 : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_Snare
     (Buffer                         :    out Mono_Buffer;
      Tone_Param, Noise_Param        :        Param_Range;
      Pulse0, Pulse1, Pulse2, Pulse3 : in out Excitation.Instance;
      Filter0, Filter1, Filter2      : in out Filters.SVF.Instance;
      Rng                            : in out Random.Instance;
      Pitch                          :        Pitch_Range;
      Do_Init                        : in out Boolean;
      Do_Strike                      : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Tone;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_Noise;

private

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record
      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter2 : Filters.SVF.Instance;
      Rng : Random.Instance;

      Pitch : Pitch_Range := Init_Pitch;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      Tone_Param : Param_Range := 0;
      Noise_Param : Param_Range := 0;
   end record;

end Tresses.Drums.Snare;
