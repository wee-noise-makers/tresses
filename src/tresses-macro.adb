with Tresses.Drums.Kick;
with Tresses.Drums.Analog_Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Analog_Snare;
with Tresses.Drums.Clap;
with Tresses.Voices.Analog_Macro;
with Tresses.Voices.FM_OP2;
with Tresses.Voices.Acid;
with Tresses.Voices.Sand;
with Tresses.Voices.Bass_808;
with Tresses.Voices.House_Bass;
with Tresses.Voices.Pluck_Bass;

package body Tresses.Macro is

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

         when Drum_Analog_Kick =>
            Drums.Analog_Kick.Render_Analog_Kick
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Env => This.Env0,
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

         when Drum_Analog_Snare =>
           Drums.Analog_Snare.Render_Analog_Snare
              (Buffer,
               Params => This.Params,
               Phase => This.Phase,
               Phase_Increment => This.Phase_Increment,
               Target_Phase_Increment => This.Target_Phase_Increment,
               Filter => This.Filter0,
               Tone_Env => This.Env0,
               Noise_env => This.Env1,
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
                                     A_Env => This.Env0,
                                     F_Env => This.Env1,
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
               Rng => This.Rng,
               Pitch => This.Pitch,
               Do_Init => This.Do_Init,
               Do_Strike => This.Do_Strike);

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

         when Drum_Analog_Kick =>
            return Drums.Analog_Kick.Param_Label (Id);

         when Drum_Snare =>
            return Drums.Snare.Param_Label (Id);

         when Drum_Analog_Snare =>
            return Drums.Analog_Snare.Param_Label (Id);

         when Drum_Clap =>
            return Drums.Clap.Param_Label (Id);

         when Drum_Cymbal =>
            return Drums.Cymbal.Param_Label (Id);

         when Drum_Percussion =>
            return Drums.Percussion.Param_Label (Id);

         when Drum_Bell =>
            return  Drums.Bell.Param_Label (Id);

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

         when Voice_Bass_808 =>
            return Voices.Bass_808.Param_Label (Id);

         when Voice_House_Bass =>
            return Voices.House_Bass.Param_Label (Id);

         when Voice_Pluck_Bass =>
            return Voices.Pluck_Bass.Param_Label (Id);

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

         when Drum_Analog_Kick =>
            return Drums.Analog_Kick.Param_Short_Label (Id);

         when Drum_Snare =>
            return Drums.Snare.Param_Short_Label (Id);

         when Drum_Analog_Snare =>
            return Drums.Analog_Snare.Param_Short_Label (Id);

         when Drum_Clap =>
            return Drums.Clap.Param_Short_Label (Id);

         when Drum_Cymbal =>
            return Drums.Cymbal.Param_Short_Label (Id);

         when Drum_Percussion =>
            return Drums.Percussion.Param_Short_Label (Id);

         when Drum_Bell =>
            return  Drums.Bell.Param_Short_Label (Id);

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

         when Voice_Bass_808 =>
            return Voices.Bass_808.Param_Short_Label (Id);

         when Voice_House_Bass =>
            return Voices.House_Bass.Param_Short_Label (Id);

         when Voice_Pluck_Bass =>
            return Voices.Pluck_Bass.Param_Short_Label (Id);
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
