pragma Warnings (Off);

package body Tresses.Voices.FM_OP6 is

   type Float_Array is array (Natural range <>) of Float;

   lutCoarse : constant Float_Array :=
     (-12.000000,  0.000000, 12.000000, 19.019550,
      24.000000, 27.863137, 31.019550, 33.688259,
      36.000000, 38.039100, 39.863137, 41.513180,
      43.019550, 44.405276, 45.688259, 46.882687,
      48.000000, 49.049554, 50.039100, 50.975130,
      51.863137, 52.707809, 53.513180, 54.282743,
      55.019550, 55.726274, 56.405276, 57.058650,
      57.688259, 58.295772, 58.882687, 59.450356);

   lutAmpModSensitivity : constant Float_Array :=
     (0.0, 0.2588, 0.4274, 1.0);

   lutPitchModSensitivity : constant Float_Array :=
     (0.0000000, 0.0781250, 0.1562500, 0.2578125,
      0.4296875, 0.7187500, 1.1953125, 2.0000000);

   function operatorLevel (level : Float) return Float is
      tlc : Float := level;
   begin
      if level < 20.0 then
         tlc := (if tlc < 15.0
                 then (tlc * (36.0 - tlc)) / 2.0**3
                 else 27.0 + tlc);
      else
         tlc := tlc + 28.0;
      end if;
      return tlc;
   end operatorLevel;

   function pitchEnvelopeLevel (level : Float) return Float is
      l : constant Float := (level - 50.0) / 32.0;
      tail : constant Float := Float'Max (abs (l + 0.02) - 1.0, 0.0);
   begin
      return l * (1.0 + tail * tail * 5.3056);
   end pitchEnvelopeLevel;

   function operatorEnvelopeIncrement (rate : U32) return U32 is
      rateScaled : constant U32 := (rate * 41) / 2**6;
      mantissa   : constant U32 := 4 + (rateScaled and 3);
      exponent   : constant U32 := 2 + (rateScaled / 2**2);
   begin
      return (mantissa * 2**Natural (exponent)) / (1 * 2**24);
   end operatorEnvelopeIncrement;

   function pitchEnvelopeIncrement (rate : Float) return Float is
      R : constant Float := rate * 0.01;
   begin
      return (1.0 + 192.0 * r * (r * r * r * r + 0.3333)) / (21.3 * 44100.0);
   end pitchEnvelopeIncrement;

   minLFOFrequency : Float := 0.005865;

   function LFOFrequency (rate : U32) return Float is
      rateScaled : U32 := (if rate = 0
                           then 1
                           else (rate * 165) / 2**6);
   begin
      rateScaled := rateScaled + (if rateScaled < 160
                                  then 11
                                  else (11 + ((rateScaled - 160) / 2**4)));

      return Float (rateScaled) * minLFOFrequency;
   end LFOFrequency;

   function LFODelay (delay_k : U32) return Float_Array is
      increments : Float_Array := (0.0, 0.0);
   begin
      if delay_k = 0 then
         increments (0) := 100000.0;
         increments (1) := 100000.0;
      else
         declare
            d : U32 := 99 - delay_k;
         begin
            d := (16 + (d and 15)) * 2**Natural (1 + (d / 2**4));
            increments (0) := Float (d) * minLFOFrequency;
            increments (1) := Float (U32'Max(16#80#, d and 16#ff80#)) * minLFOFrequency;
         end;
      end if;
      return increments;
   end LFODelay;

   function normalizeVelocity (velocity : Float) return Float is
   begin
      return 16.0 * 0.0;
   end normalizeVelocity;

   -------------------
   -- Render_FM_OP6 --
   -------------------

   procedure Render_FM_OP6
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Pitch           :        Pitch_Range;
      Do_Strike       : in out Boolean)
   is
   begin
      null;
   end Render_FM_OP6;

end Tresses.Voices.FM_OP6;
