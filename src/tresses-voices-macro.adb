with Tresses.Voices.Analog_Macro;
with Tresses.Voices.FM_OP2;
with Tresses.Voices.Acid;
with Tresses.Voices.Sand;
with Tresses.Voices.Bass_808;
with Tresses.Voices.House_Bass;
with Tresses.Voices.Pluck_Bass;
with Tresses.Voices.Reese;
with Tresses.Voices.Screech;
with Tresses.Voices.Phase_Distortion_Instantiations;
with Tresses.Voices.Chip_Portamento;
with Tresses.Voices.Chip_Echo;
with Tresses.Voices.Chip_Phaser;
with Tresses.Voices.Pluck;
with Tresses.Voices.Wave_Portamento;
with Tresses.Voices.Wave_Phaser;
with Tresses.Voices.Wave_Pluck;
with Tresses.Voices.Wave_Echo;

with Tresses.Macro;
with Tresses.Resources;

package body Tresses.Voices.Macro is

   package PDVI renames Tresses.Voices.Phase_Distortion_Instantiations;

   ------------
   -- Engine --
   ------------

   function Engine (This : Instance) return Synth_Engines
   is (This.Engine);

   ----------------
   -- Set_Engine --
   ----------------

   procedure Set_Engine (This : in out Instance; E : Synth_Engines) is
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
      if This.Engine = Synth_Engines'Last then
         Set_Engine (This, Synth_Engines'First);
      else
         Set_Engine (This, Synth_Engines'Succ (This.Engine));
      end if;
   end Next_Engine;

   -----------------
   -- Prev_Engine --
   -----------------

   procedure Prev_Engine (This : in out Instance) is
   begin
      if This.Engine = Synth_Engines'First then
         Set_Engine (This, Synth_Engines'Last);
      else
         Set_Engine (This, Synth_Engines'Pred (This.Engine));
      end if;
   end Prev_Engine;

   -----------------------
   -- Set_User_Waveform --
   -----------------------

   procedure Set_User_Waveform
     (This : in out Instance;
      Wave : not null access constant Resources.Table_257_S16)
   is
   begin
      This.User_Waveform := Wave;
   end Set_User_Waveform;

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
         when Voice_Saw_Swarm =>
            if This.B /= null then
               Saw_Swarm.Render_Saw_Swarm
                 (Buffer,
                  Params    => This.Params,
                  Rng       => This.Rng,
                  Env       => This.Env0,
                  State     => This.B.Saw_Swarm_State,
                  Phase     => This.U32_1,
                  Pitch     => This.Pitch,
                  Do_Init   => This.Do_Init,
                  Do_Strike => This.Do_Strike);
            end if;
         when Voice_Plucked =>
            if This.B /= null then
               Plucked.Render_Plucked (Buffer,
                                       Params    => This.Params,
                                       Rng       => This.Rng,
                                       Env       => This.Env0,
                                       State     => This.B.Pluck_State,
                                       KS        => This.B.KS,
                                       Pitch     => This.Pitch,
                                       Do_Init   => This.Do_Init,
                                       Do_Strike => This.Do_Strike);
            end if;
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
                 (Buffer_A  => Buffer,
                  Buffer_B  => Aux_Buffer,
                  Shape     => Shape,
                  Params    => This.Params,
                  Osc0      => This.Osc0,
                  Osc1      => This.Osc1,
                  Env       => This.Env0,
                  LP_State  => This.LP_State,
                  Pitch     => This.Pitch,
                  Do_Init   => This.Do_Init,
                  Do_Strike => This.Do_Strike);
            end;

         when Voice_FM2OP =>
            Voices.FM_OP2.Render_FM_OP2 (Buffer,
                                         This.Params,
                                         This.Env0,
                                         This.U32_1,
                                         This.U32_2,
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
               Filter1   => This.SVF,
               Env       => This.Env0,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Bass_808 =>
            Voices.Bass_808.Render_Bass_808
              (Buffer,
               Params => This.Params,
               Phase => This.U32_1,
               Phase_Increment => This.U32_2,
               Target_Phase_Increment => This.U32_3,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike,
               Waveform => Resources.WAV_Sine'Access);

         when Voice_Chip_Bass =>
            Voices.Bass_808.Render_Bass_808
              (Buffer,
               Params => This.Params,
               Phase => This.U32_1,
               Phase_Increment => This.U32_2,
               Target_Phase_Increment => This.U32_3,
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
               Filter1   => This.SVF,
               Env       => This.Env0,
               F_Env     => This.Env1,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Pluck_Bass =>
            Voices.Pluck_Bass.Pluck_Bass
              (Buffer,
               Params => This.Params,
               Phase => This.U32_1,
               Phase_Increment => This.U32_4,
               Env => This.Env0,
               Shape_Env => This.Env1,
               Filter => This.SVF,
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
               Filter1   => This.SVF,
               Env       => This.Env0,
               Pitch     => This.Pitch,
               Do_Init   => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Screech =>
            Voices.Screech.Render_Screech
              (Buffer => Buffer,
               Params => This.Params,
               Env => This.Env0,
               Filter => This.SVF,
               Phase => This.U32_1,
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
            Tresses.Voices.Chip_Portamento.Render
              (Buffer,
               Params => This.Params,
               Start_Phase_Incr =>  This.U32_1,
               Current_Phase_Incr => This.U32_4,
               Target_Phase_Incr => This.U32_3,
               Osc => This.Osc0,
               Env => This.Env0,
               Shape_Env => This.Env1,
               Filter => This.SVF,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Chip_Echo_Square =>
            Voices.Chip_Echo.Render
              (Buffer, Aux_Buffer,
               Params => This.Params,
               Osc_Select =>  This.U32_1,
               Retrig1 => This.U32_2,
               Retrig2 => This.U32_3,
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
               Osc_Select =>  This.U32_1,
               Retrig1 => This.U32_2,
               Retrig2 => This.U32_3,
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
               Phase_Increment => This.U32_1,
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
               Phase_Increment => This.U32_1,
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
               Phase_Increment => This.U32_1,
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
               Filter => This.SVF,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_Triangle_Pluck =>
            Voices.Pluck.Render
              (Buffer,
               Params => This.Params,
               Wave => Analog_Oscillator.Triangle_Fold,
               Osc => This.Osc0,
               Env => This.Env1,
               Filter => This.SVF,
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
               Filter => This.SVF,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_User_Wave_Glide =>
            Voices.Wave_Portamento.Render
              (Buffer,
               Params => This.Params,
               Phase =>  This.U32_1,
               Start_Phase_Incr => This.U32_2,
               Current_Phase_Incr => This.U32_3,
               Target_Phase_Incr => This.U32_4,
               Wave => This.User_Waveform,
               Env =>  This.Env0,
               Shape_Env => This.Env1,
               Filter => This.SVF,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_User_Wave_Phaser =>
            Voices.Wave_Phaser.Render
              (Buffer,
               Params => This.Params,
               Phase1 => This.U32_1,
               Phase2 => This.U32_2,
               Phase_Increment => This.U32_3,
               Wave => This.User_Waveform,
               Env => This.Env0,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_User_Wave_Pluck =>
            Voices.Wave_Pluck.Render
              (Buffer,
               Params => This.Params,
               Wave => This.User_Waveform,
               Phase => This.U32_1,
               Phase_Increment => This.U32_2,
               Env => This.Env0,
               Filter => This.SVF,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

         when Voice_User_Wave_Echo =>
            Voices.Wave_Echo.Render
              (Buffer,
               Params => This.Params,
               Wave => This.User_Waveform,
               Osc_Select => This.U32_1,
               Retrig1 => This.U32_2,
               Retrig2 => This.U32_3,
               Phase1 => This.U32_4,
               Phase2 => This.U32_5,
               Pitch1 => This.Pitch1,
               Pitch2 => This.Pitch2,
               Env1 => This.Env0,
               Env2 => This.Env1,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);
      end case;
   end Render;

   -----------------
   -- Param_Label --
   -----------------

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String is
   begin
      return Tresses.Macro.Param_Label (This.Engine, Id);
   end Param_Label;

   -----------------------
   -- Param_Short_Label --
   -----------------------

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is
   begin
      return Tresses.Macro.Param_Short_Label (This.Engine, Id);
   end Param_Short_Label;

end Tresses.Voices.Macro;
