with Tresses.Drums.Kick;
with Tresses.Drums.Snare;
with Tresses.Voices.Analog_Macro;
with Tresses.Voices.FM_OP2;

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
                                    Pulse2      => This.Pulse2,
                                    Filter      => This.Filter0,
                                    LP_State    => This.LP_State,
                                    Pitch       => This.Pitch,
                                    Do_Init     => This.Do_Init,
                                    Do_Strike   => This.Do_Strike);
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
         when Drum_Cymbal =>
            Drums.Cymbal.Render_Cymbal (Buffer,
                                        Params      => This.Params,
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
               Params      => This.Params,
               Rng             => This.Rng,
               Env             => This.Env,
               State           => This.Saw_Swarm_State,
               Phase           => This.Phase,
               Pitch           => This.Pitch,
               Do_Strike       => This.Do_Strike);

         when Voice_Plucked =>
            Voices.Plucked.Render_Plucked
              (Buffer,
               Params      => This.Params,
               Rng            => This.Rng,
               Env            => This.Env,
               State          => This.Pluck_State,
               KS             => This.KS,
               Pitch          => This.Pitch,
               Do_Strike      => This.Do_Strike);

         when Voice_Analog_Buzz | Voice_Analog_Morph =>
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
                  Env => This.Env,
                  LP_State => This.LP_State,
                  Pitch => This.Pitch,
                  Do_Strike => This.Do_Strike);
            end;

         when Voice_Analog_FM2OP =>
            Voices.FM_OP2.Render_FM_OP2 (Buffer,
                                         This.Params,
                                         This.Env,
                                         This.Phase,
                                         This.Modulator_Phase,
                                         This.Pitch,
                                         This.Do_Strike);
      end case;
   end Render;

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

   ---------------
   -- Set_Param --
   ---------------

   overriding
   procedure Set_Param (This : in out Instance;
                        Id   :        Param_Id;
                        P    :        Param_Range)
   is
   begin
      This.Params (Id) := P;
   end Set_Param;

   -----------------
   -- Param_Label --
   -----------------

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String is
   begin
      case This.Engine is
         when Drum_Kick =>
            return Drums.Kick.Param_Label (Id);

         when Drum_Snare =>
            return Drums.Snare.Param_Label (Id);

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

         when Voice_Analog_Buzz | Voice_Analog_Morph =>
            declare
               use Voices.Analog_Macro;

               Shape : constant Analog_Macro_Shape :=
                 (case This.Engine is
                     when Voice_Analog_Buzz => Buzz,
                     when Voice_Analog_Morph => Morph,
                     when others => raise Program_Error);

            begin
               return Voices.Analog_Macro.Param_Label (Shape, Id);
            end;
         when Voice_Analog_FM2OP =>
            return Voices.FM_OP2.Param_Label (Id);
      end case;
   end Param_Label;

end Tresses.Macro;
