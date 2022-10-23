with Tresses.Excitation;
with Tresses.SVF;
with Tresses.Random;

package Tresses.Drums.Snare
with Preelaborate
is
   type Instance is private;

   procedure Init (This : in out Instance);

   procedure Set_Tone (This : in out Instance; P0 : U16);

   procedure Set_Noise (This : in out Instance; P1 : U16);

   procedure Strike (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Render_Snare
     (Buffer                         :    out Mono_Buffer;
      Tone_Param, Noise_Param        :        U16;
      Pulse0, Pulse1, Pulse2, Pulse3 : in out Excitation.Instance;
      Filter0, Filter1, Filter2      : in out SVF.Instance;
      Rng                            : in out Random.Instance;
      Pitch                          :        S16;
      Do_Init                        :        Boolean;
      Do_Strike                      :        Boolean);
private

   type Instance is record
      Pulse0 : Excitation.Instance;
      Pulse1 : Excitation.Instance;
      Pulse2 : Excitation.Instance;
      Pulse3 : Excitation.Instance;
      Filter0 : SVF.Instance;
      Filter1 : SVF.Instance;
      Filter2 : SVF.Instance;
      Rng : Random.Instance;

      Pitch : S16 := 12 * 128 * 4;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      Tone_Param : U16 := 0;
      Noise_Param : U16 := 0;
   end record;

end Tresses.Drums.Snare;
