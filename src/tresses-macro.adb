with Tresses.Drums.Kick;
with Tresses.Drums.Snare;
with Tresses.Voices.Analog_Macro;

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
                                    Decay => This.P1,
                                    Coefficient => This.P2,
                                    Pulse0      => This.Pulse0,
                                    Pulse1      => This.Pulse1,
                                    Pulse2      => This.Pulse2,
                                    Filter      => This.Filter0,
                                    LP_State    => This.LP_State,
                                    Pitch       => This.Pitch,
                                    Do_Init     => This.Do_Init,
                                    Do_Strike   => This.Do_Strike);
         when Drum_Snare =>
            Drums.Snare.Render_Snare (Buffer,
                                      Tone_Param => This.P1,
                                      Noise_Param => This.P2,
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
         when Drum_Cymbal =>
            Drums.Cymbal.Render_Cymbal (Buffer,
                                        Cutoff_Param => This.P1,
                                        Noise_Param => This.P2,
                                        Filter0 => This.Filter0,
                                        Filter1 => This.Filter1,
                                        Env => This.Env,
                                        State => This.Cym_State,
                                        Phase => This.Phase,
                                        Pitch => This.Pitch,
                                        Do_Init => This.Do_Init,
                                        Do_Strike => This.Do_Strike);

         when Drum_Percussion =>
            Drums.Percussion.Render_Percussion
              (Buffer,
               Damping     => This.P1,
               Coefficient => This.P2,
               State       => This.Perc_State,
               Rng         => This.Rng,
               Pitch       => This.Pitch,
               Do_Strike   => This.Do_Strike);

         when Drum_Bell =>
            Drums.Bell.Render_Bell (Buffer,
                                    Damping     => This.P1,
                                    Coefficient => This.P2,
                                    State       => This.Bell_State,
                                    Pitch       => This.Pitch,
                                    Do_Strike   => This.Do_Strike);

         when Voice_Saw_Swarm =>
            Voices.Saw_Swarm.Render_Saw_Swarm
              (Buffer,
               Detune_Param    => This.P1,
               High_Pass_Param => This.P2,
               Rng             => This.Rng,
               Env             => This.Env,
               State           => This.Saw_Swarm_State,
               Phase           => This.Phase,
               Pitch           => This.Pitch,
               Do_Strike       => This.Do_Strike);

         when Voice_Plucked =>
            Voices.Plucked.Render_Plucked
              (Buffer,
               Decay_Param    => This.P1,
               Position_Param => This.P2,
               Rng            => This.Rng,
               Env            => This.Env,
               State          => This.Pluck_State,
               KS             => This.KS,
               Pitch          => This.Pitch,
               Do_Strike      => This.Do_Strike);

         when Voice_Analog_Buzz | Voice_Analog_Morph |
              Voice_Analog_Acid_Bass
            =>
            declare
               use Voices.Analog_Macro;

               Shape : constant Analog_Macro_Shape :=
                 (case This.Engine is
                     when Voice_Analog_Buzz => Buzz,
                     when Voice_Analog_Morph => Morph,
                     when Voice_Analog_Acid_Bass => Acid_Bass,
                     when others => raise Program_Error);

            begin
               Voices.Analog_Macro.Render_Analog_Macro
                 (Buffer_A =>  Buffer,
                  Buffer_B =>  Aux_Buffer,
                  Shape => Shape,
                  Param1 =>  This.P1,
                  Param2 => This.P2,
                  Osc0 => This.Osc0,
                  Osc1 => This.Osc1,
                  Env => This.Env,
                  Filter => This.Ladder,
                  LP_State => This.LP_State,
                  Pitch => This.Pitch,
                  Do_Strike => This.Do_Strike);
            end;

      end case;
   end Render;

   ----------------
   -- Set_Attack --
   ----------------

   procedure Set_Attack (This : in out Instance; A : U7) is
   begin
      Envelopes.AD.Set_Attack (This.Env, A);
   end Set_Attack;

   ---------------
   -- Set_Decay --
   ---------------

   procedure Set_Decay (This : in out Instance; D : U7) is
   begin
      Envelopes.AD.Set_Decay (This.Env, D);
   end Set_Decay;

   ------------
   -- Strike --
   ------------

   overriding
   procedure Strike (This : in out Instance) is
   begin
      This.Do_Strike := True;
   end Strike;

   ---------------
   -- Set_Pitch --
   ---------------

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range)
   is
   begin
      This.Pitch := Pitch;
   end Set_Pitch;

   ----------------
   -- Set_Param1 --
   ----------------

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range) is
   begin
      This.P1 := P;
   end Set_Param1;

   ----------------
   -- Set_Param2 --
   ----------------

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range) is
   begin
      This.P2 := P;
   end Set_Param2;

end Tresses.Macro;
