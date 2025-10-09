with Tresses.Drums.Kick;
with Tresses.Drums.Sine_Kick;
with Tresses.Drums.Triangle_Kick;
with Tresses.Drums.Chip_Kick;
with Tresses.Drums.Sine_Noise_Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Sine_Snare;
with Tresses.Drums.Saw_Snare;
with Tresses.Drums.Triangle_Snare;
with Tresses.Drums.Clap;
with Tresses.Drums.HH_909_Sampled;
with Tresses.Drums.HH_707_Sampled;
with Tresses.Voices.Analog_Macro;
with Tresses.Voices.FM_OP2;
with Tresses.Voices.Acid;
with Tresses.Voices.Sand;
with Tresses.Voices.Bass_808;
with Tresses.Voices.House_Bass;
with Tresses.Voices.Pluck_Bass;
with Tresses.Voices.Reese;
with Tresses.Voices.Screech;
with Tresses.Voices.Phase_Distortion;
with Tresses.Voices.Phase_Distortion_Instantiations;
with Tresses.Voices.Chip_Portamento;
with Tresses.Voices.Chip_Echo;
with Tresses.Voices.Chip_Phaser;
with Tresses.Voices.Pluck;
with Tresses.Resources;

package body Tresses.Macro is

   package PDVI renames Tresses.Voices.Phase_Distortion_Instantiations;

   ------------
   -- Engine --
   ------------

   function Engine (This : Instance) return Engines
   is (This.Engine);

   ----------------
   -- Set_Engine --
   ----------------

   procedure Set_Engine (This : in out Instance; E : Engines) is
   begin
      if E /= This.Engine then
         This.Engine := E;
         Init (This);
      end if;
   end Set_Engine;

   -----------------
   -- Next_Engine --
   -----------------

   procedure Next_Engine (This : in out Instance) is
   begin
      if This.Engine = Engines'Last then
         Set_Engine (This, Engines'First);
      else
         Set_Engine (This, Engines'Succ (This.Engine));
      end if;
   end Next_Engine;

   -----------------
   -- Prev_Engine --
   -----------------

   procedure Prev_Engine (This : in out Instance) is
   begin
      if This.Engine = Engines'First then
         Set_Engine (This, Engines'Last);
      else
         Set_Engine (This, Engines'Pred (This.Engine));
      end if;
   end Prev_Engine;

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.Do_Init := True;
   end Init;

   ------------
   -- Render --
   ------------

   procedure Render (This               : in out Instance;
                     Buffer, Aux_Buffer :    out Mono_Buffer)
   is
   begin
      case This.Engine is
         when Drum_Kick =>
            Drums.Kick.Render_Kick (Buffer,
                                    Params      => This.Params,
                                    Pulse0      => This.Pulse0,
                                    Pulse1      => This.Pulse1,
                                    Filter      => This.Filter0,
                                    Env         => This.Env0,
                                    LP_State    => This.LP_State,
                                    Pitch       => This.Pitch,
                                    Do_Init     => This.Do_Init,
                                    Do_Strike   => This.Do_Strike);

         when Drum_Sine_Kick =>
            Drums.Sine_Kick.Render_Kick
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Triangle_Kick =>
            Drums.Triangle_Kick.Render_Kick
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Chip_Kick =>
            Drums.Chip_Kick.Render_Kick
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Sine_Noise_Kick =>
            Drums.Sine_Noise_Kick.Render_Kick
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Noise_Env => This.Env1,
               RNG => This.Rng,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Snare =>
            Drums.Snare.Render_Snare (Buffer,
                                      Params => This.Params,
                                      Pulse0 => This.Pulse0,
                                      Pulse1 => This.Pulse1,
                                      Pulse2 => This.Pulse2,
                                      Pulse3 => This.Pulse3,
                                      Filter0 => This.Filter0,
                                      Filter1 => This.Filter1,
                                      Filter2 => This.Filter3,
                                      Rng =>  This.Rng,
                                      Pitch => This.Pitch,
                                      Do_Init => This.Do_Init,
                                      Do_Strike => This.Do_Strike);

         when Drum_Sine_Snare =>
            Drums.Sine_Snare.Render_Snare
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Tone_Env => This.Env0,
               Noise_Env => This.Env1,
               Rng => This.Rng,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Saw_Snare =>
            Drums.Saw_Snare.Render_Snare
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Tone_Env => This.Env0,
               Noise_Env => This.Env1,
               Rng => This.Rng,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Triangle_Snare =>
            Drums.Triangle_Snare.Render_Snare
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Tone_Env => This.Env0,
               Noise_Env => This.Env1,
               Rng => This.Rng,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_Clap =>
            Drums.Clap.Render_Clap (Buffer,
                                    Params => This.Params,
                                    Filter => This.Filter0,
                                    Rng =>  This.Rng,
                                    Env => This.Env0,
                                    Re_Trig => This.Phase,
                                    Pitch => This.Pitch,
                                    Do_Init => This.Do_Init,
                                    Do_Strike => This.Do_Strike);
         when Drum_Cymbal =>
            Drums.Cymbal.Render_Cymbal (Buffer,
                                        Params      => This.Params,
                                        Filter0 => This.Filter0,
                                        Filter1 => This.Filter1,
                                        Env => This.Env0,
                                        State => This.Cym_State,
                                        Phase => This.Phase,
                                        Pitch => This.Pitch,
                                        Do_Init => This.Do_Init,
                                        Do_Strike => This.Do_Strike);

         when Drum_Percussion =>
            Drums.Percussion.Render_Percussion
              (Buffer,
               Params      => This.Params,
               State       => This.Perc_State,
               Rng         => This.Rng,
               Pitch       => This.Pitch,
               Do_Strike   => This.Do_Strike);

         when Drum_Bell =>
            Drums.Bell.Render_Bell (Buffer,
                                    Params      => This.Params,
                                    State       => This.Bell_State,
                                    Pitch       => This.Pitch,
                                    Do_Strike   => This.Do_Strike);

         when Drum_909_Hats =>
            Drums.HH_909_Sampled.Render
              (Buffer,
               Params => This.Params,
               Filter => This.Filter0,
               Env => This.Env0,
               Rng => This.Rng,
               Phase =>  This.Phase,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Drum_707_Hats =>
            Drums.HH_707_Sampled.Render
              (Buffer,
               Params => This.Params,
               Filter => This.Filter0,
               Env => This.Env0,
               Rng => This.Rng,
               Phase =>  This.Phase,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Saw_Swarm =>
            Voices.Saw_Swarm.Render_Saw_Swarm
              (Buffer,
               Params    => This.Params,
               Rng       => This.Rng,
               Env       => This.Env0,
               State     => This.Saw_Swarm_State,
               Phase     => This.Phase,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Plucked =>
            Voices.Plucked.Render_Plucked
              (Buffer,
               Params    => This.Params,
               Rng       => This.Rng,
               Env       => This.Env0,
               State     => This.Pluck_State,
               KS        => This.KS,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Acid =>
            Voices.Acid.Render_Acid (Buffer => Buffer,
                                     Params => This.Params,
                                     Osc0 => This.Osc0,
                                     F_Env => This.Env0,
                                     Filter => This.Ladder,
                                     Pitch => This.Pitch,
                                     Do_Init => This.Do_Init,
                                     Do_Strike => This.Do_Strike);

         when Voice_Analog_Buzz | Voice_Analog_Morph
            =>
            declare
               use Voices.Analog_Macro;

               Shape : constant Analog_Macro_Shape :=
                 (case This.Engine is
                     when Voice_Analog_Buzz => Buzz,
                     when Voice_Analog_Morph => Morph,
                     when others => raise Program_Error);

            begin
               Voices.Analog_Macro.Render_Analog_Macro
                 (Buffer_A =>  Buffer,
                  Buffer_B =>  Aux_Buffer,
                  Shape => Shape,
                  Params => This.Params,
                  Osc0 => This.Osc0,
                  Osc1 => This.Osc1,
                  Env => This.Env0,
                  LP_State => This.LP_State,
                  Pitch => This.Pitch,
                  Do_Init => This.Do_Init,
                  Do_Strike => This.Do_Strike);
            end;

         when Voice_FM2OP =>
            Voices.FM_OP2.Render_FM_OP2 (Buffer,
                                         This.Params,
                                         This.Env0,
                                         This.Phase,
                                         This.Modulator_Phase,
                                         This.Pitch,
                                         This.Do_Init,
                                         This.Do_Strike);

         when Voice_Sand =>
            Voices.Sand.Render_Sand
              (Buffer_A  => Buffer,
               Buffer_B  => Aux_Buffer,
               Params    => This.Params,
               Osc0      => This.Osc0,
               Osc1      => This.Osc1,
               Filter1   => This.Filter0,
               Env       => This.Env0,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Bass_808 =>
            Voices.Bass_808.Render_Bass_808
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike,
               Waveform => Resources.WAV_Sine'Access);

         when Voice_Chip_Bass =>
            Voices.Bass_808.Render_Bass_808
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike,
               Waveform => Resources.WAV_Chip_Triangle'Access);

         when Voice_House_Bass =>
            Voices.House_Bass.Render_House_Bass
              (Buffer_A  => Buffer,
               Buffer_B  => Aux_Buffer,
               Params    => This.Params,
               Osc0      => This.Osc0,
               Osc1      => This.Osc1,
               Filter1   => This.Filter0,
               Env       => This.Env0,
               F_Env     => This.Env1,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Pluck_Bass =>
            Voices.Pluck_Bass.Pluck_Bass
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Env => This.Env0,
               Shape_Env => This.Env1,
               Filter => This.Filter0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Reese =>
            Voices.Reese.Render_Reese
              (Buffer_A  => Buffer,
               Buffer_B  => Aux_Buffer,
               Params    => This.Params,
               Osc0      => This.Osc0,
               Osc1      => This.Osc1,
               Filter1   => This.Filter0,
               Env       => This.Env0,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Screech =>
            Voices.Screech.Render_Screech
              (Buffer => Buffer,
               Params => This.Params,
               Env => This.Env0,
               Filter => This.Filter0,
               Phase => This.Phase,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDR_Sine =>
            PDVI.Render_Reso_Sine
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDR_Triangle =>
            PDVI.Render_Reso_Triangle
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDR_Sine_Square =>
            PDVI.Render_Reso_Sine_Square
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDR_Square_Sine =>
            PDVI.Render_Reso_Square_Sine
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDR_Square_Full_Sine =>
            PDVI.Render_Reso_Square_Full_Sine
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDL_Trig_Warp =>
            PDVI.Render_Lookup_Triangle_Sine2_Warp3
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_PDL_Triangle_Screech =>
            PDVI.Render_Lookup_Sine_Screech
              (Buffer,
               Params => This.Params,
               Osc => This.PDOsc0,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Glide =>
            Voices.Chip_Portamento.Render
              (Buffer,
               Params => This.Params,
               Start_Phase_Incr =>  This.Phase,
               Current_Phase_Incr => This.Phase_Increment,
               Target_Phase_Incr => This.Target_Phase_Increment,
               Osc => This.Osc0,
               Env => This.Env0,
               Shape_Env => This.Env1,
               Filter => This.Filter0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Echo_Square =>
            Voices.Chip_Echo.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Osc_Select =>  This.Phase,
               Retrig1 => This.Phase_Increment,
               Retrig2 => This.Target_Phase_Increment,
               Pitch1 => This.Pitch1,
               Pitch2 => This.Pitch2,
               Osc1 => This.Osc0,
               Osc2 => This.Osc1,
               Shape1 => Analog_Oscillator.Square,
               Shape2 => Analog_Oscillator.Square,
               Env1 => This.Env0,
               Env2 => This.Env1,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Echo_Square_Saw =>
            Voices.Chip_Echo.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Osc_Select =>  This.Phase,
               Retrig1 => This.Phase_Increment,
               Retrig2 => This.Target_Phase_Increment,
               Pitch1 => This.Pitch1,
               Pitch2 => This.Pitch2,
               Osc1 => This.Osc0,
               Osc2 => This.Osc1,
               Shape1 => Analog_Oscillator.Square,
               Shape2 => Analog_Oscillator.Variable_Saw,
               Env1 => This.Env0,
               Env2 => This.Env1,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Phaser =>
            Voices.Chip_Phaser.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Square,
               Phase_Increment => This.Phase_Increment,
               Osc1 => This.Osc0,
               Osc2 => This.Osc1,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Sine_Phaser =>
            Voices.Chip_Phaser.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Sine_Fold,
               Phase_Increment => This.Phase_Increment,
               Osc1 => This.Osc0,
               Osc2 => This.Osc1,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Triangle_Phaser =>
            Voices.Chip_Phaser.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Triangle_Fold,
               Phase_Increment => This.Phase_Increment,
               Osc1 => This.Osc0,
               Osc2 => This.Osc1,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Sine_Pluck =>
            Voices.Pluck.Render
              (Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Sine_Fold,
               Osc => This.Osc0,
               Env => This.Env0,
               Filter => This.Filter0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Triangle_Pluck =>
            Voices.Pluck.Render
              (Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Triangle_Fold,
               Osc => This.Osc0,
               Env => This.Env0,
               Filter => This.Filter0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Pluck =>
            Voices.Pluck.Render
              (Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Square,
               Osc => This.Osc0,
               Env => This.Env0,
               Filter => This.Filter0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

      end case;
   end Render;

   -----------------
   -- Param_Label --
   -----------------

   function Param_Label (Engine : Tresses.Engines; Id : Param_Id)
                         return String
   is
   begin
      case Engine is
         when Drum_Kick =>
            return Drums.Kick.Param_Label (Id);

         when Drum_Sine_Kick | Drum_Triangle_Kick | Drum_Chip_Kick =>
            return Drums.Sine_Kick.Param_Label (Id);

         when Drum_Sine_Noise_Kick =>
            return Drums.Sine_Noise_Kick.Param_Label (Id);

         when Drum_Snare =>
            return Drums.Snare.Param_Label (Id);

         when Drum_Sine_Snare | Drum_Saw_Snare | Drum_Triangle_Snare =>
            return Drums.Sine_Snare.Param_Label (Id);

         when Drum_Clap =>
            return Drums.Clap.Param_Label (Id);

         when Drum_Cymbal =>
            return Drums.Cymbal.Param_Label (Id);

         when Drum_Percussion =>
            return Drums.Percussion.Param_Label (Id);

         when Drum_Bell =>
            return  Drums.Bell.Param_Label (Id);

         when Drum_909_Hats =>
            return Drums.HH_909_Sampled.Param_Label (Id);

         when Drum_707_Hats =>
            return Drums.HH_707_Sampled.Param_Label (Id);

         when Voice_Saw_Swarm =>
            return Voices.Saw_Swarm.Param_Label (Id);

         when Voice_Plucked =>
            return Voices.Plucked.Param_Label (Id);

         when Voice_Acid =>
            return Voices.Acid.Param_Label (Id);

         when Voice_Analog_Buzz =>
            return Voices.Analog_Macro.Param_Label
              (Voices.Analog_Macro.Buzz, Id);

         when Voice_Analog_Morph =>
            return Voices.Analog_Macro.Param_Label
              (Voices.Analog_Macro.Morph, Id);

         when Voice_FM2OP =>
            return Voices.FM_OP2.Param_Label (Id);

         when Voice_Sand =>
            return Voices.Sand.Param_Label (Id);

         when Voice_Bass_808 | Voice_Chip_Bass =>
            return Voices.Bass_808.Param_Label (Id);

         when Voice_House_Bass =>
            return Voices.House_Bass.Param_Label (Id);

         when Voice_Pluck_Bass =>
            return Voices.Pluck_Bass.Param_Label (Id);

         when Voice_Reese =>
            return Voices.Reese.Param_Label (Id);

         when Voice_Screech =>
            return Voices.Screech.Param_Label (Id);

         when Voice_PDR_Sine .. Voice_PDL_Triangle_Screech =>
            return Voices.Phase_Distortion.Param_Label (Id);

         when Voice_Chip_Glide =>
            return Tresses.Voices.Chip_Portamento.Param_Label (Id);

         when Voice_Chip_Echo_Square .. Voice_Chip_Echo_Square_Saw =>
            return Tresses.Voices.Chip_Echo.Param_Label (Id);

         when Voice_Chip_Phaser | Voice_Sine_Phaser | Voice_Triangle_Phaser
            =>
            return Tresses.Voices.Chip_Phaser.Param_Label (Id);

         when Voice_Sine_Pluck .. Voice_Chip_Pluck =>
            return Tresses.Voices.Pluck.Param_Label (Id);
      end case;

   end Param_Label;

   -----------------------
   -- Param_Short_Label --
   -----------------------

   function Param_Short_Label (Engine : Tresses.Engines; Id : Param_Id)
                               return Short_Label
   is
   begin
      case Engine is
         when Drum_Kick =>
            return Drums.Kick.Param_Short_Label (Id);

         when Drum_Sine_Kick | Drum_Triangle_Kick | Drum_Chip_Kick =>
            return Drums.Sine_Kick.Param_Short_Label (Id);

         when Drum_Sine_Noise_Kick =>
            return Drums.Sine_Noise_Kick.Param_Short_Label (Id);

         when Drum_Snare =>
            return Drums.Snare.Param_Short_Label (Id);

         when Drum_Sine_Snare | Drum_Triangle_Snare | Drum_Saw_Snare =>
            return Drums.Sine_Snare.Param_Short_Label (Id);

         when Drum_Clap =>
            return Drums.Clap.Param_Short_Label (Id);

         when Drum_Cymbal =>
            return Drums.Cymbal.Param_Short_Label (Id);

         when Drum_Percussion =>
            return Drums.Percussion.Param_Short_Label (Id);

         when Drum_Bell =>
            return  Drums.Bell.Param_Short_Label (Id);

         when Drum_909_Hats =>
            return Drums.HH_909_Sampled.Param_Short_Label (Id);

         when Drum_707_Hats =>
            return Drums.HH_707_Sampled.Param_Short_Label (Id);

         when Voice_Saw_Swarm =>
            return Voices.Saw_Swarm.Param_Short_Label (Id);

         when Voice_Plucked =>
            return Voices.Plucked.Param_Short_Label (Id);

         when Voice_Acid =>
            return Voices.Acid.Param_Short_Label (Id);

         when Voice_Analog_Buzz =>
            return Voices.Analog_Macro.Param_Short_Label
              (Voices.Analog_Macro.Buzz, Id);

         when Voice_Analog_Morph =>
            return Voices.Analog_Macro.Param_Short_Label
              (Voices.Analog_Macro.Morph, Id);

         when Voice_FM2OP =>
            return Voices.FM_OP2.Param_Short_Label (Id);

         when Voice_Sand =>
            return Voices.Sand.Param_Short_Label (Id);

         when Voice_Bass_808 | Voice_Chip_Bass =>
            return Voices.Bass_808.Param_Short_Label (Id);

         when Voice_House_Bass =>
            return Voices.House_Bass.Param_Short_Label (Id);

         when Voice_Pluck_Bass =>
            return Voices.Pluck_Bass.Param_Short_Label (Id);

         when Voice_Reese =>
            return Voices.Reese.Param_Short_Label (Id);

         when Voice_Screech =>
            return Voices.Screech.Param_Short_Label (Id);

         when Voice_PDR_Sine .. Voice_PDL_Triangle_Screech =>
            return Voices.Phase_Distortion.Param_Short_Label (Id);

         when Voice_Chip_Glide =>
            return Tresses.Voices.Chip_Portamento.Param_Short_Label (Id);

         when Voice_Chip_Echo_Square .. Voice_Chip_Echo_Square_Saw =>
            return Tresses.Voices.Chip_Echo.Param_Short_Label (Id);

         when Voice_Chip_Phaser | Voice_Sine_Phaser | Voice_Triangle_Phaser
              =>
            return Tresses.Voices.Chip_Phaser.Param_Short_Label (Id);

         when Voice_Sine_Pluck .. Voice_Chip_Pluck =>
            return Tresses.Voices.Pluck.Param_Short_Label (Id);
      end case;
   end Param_Short_Label;

   -----------------
   -- Param_Label --
   -----------------

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String is
   begin
      return Param_Label (This.Engine, Id);
   end Param_Label;

   -----------------------
   -- Param_Short_Label --
   -----------------------

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is
   begin
      return Param_Short_Label (This.Engine, Id);
   end Param_Short_Label;

end Tresses.Macro;
