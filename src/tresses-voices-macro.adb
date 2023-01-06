with Tresses.Voices.Analog_Macro;
with Tresses.Voices.FM_OP2;
with Tresses.Voices.Acid;
with Tresses.Macro;

package body Tresses.Voices.Macro is

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
            Saw_Swarm.Render_Saw_Swarm
              (Buffer,
               Params    => This.Params,
               Rng       => This.Rng,
               Env       => This.Env0,
               State     => This.Saw_Swarm_State,
               Phase     => This.Phase,
               Pitch     => This.Pitch,
               Do_Strike => This.Do_Strike);

         when Voice_Plucked =>
            Plucked.Render_Plucked (Buffer,
                                    Params    => This.Params,
                                    Rng       => This.Rng,
                                    Env       => This.Env0,
                                    State     => This.Pluck_State,
                                    KS        => This.KS,
                                    Pitch     => This.Pitch,
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
                 (Buffer_A  => Buffer,
                  Buffer_B  => Aux_Buffer,
                  Shape     => Shape,
                  Params    => This.Params,
                  Osc0      => This.Osc0,
                  Osc1      => This.Osc1,
                  Env       => This.Env0,
                  LP_State  => This.LP_State,
                  Pitch     => This.Pitch,
                  Do_Strike => This.Do_Strike);
            end;

         when Voice_FM2OP =>
            Voices.FM_OP2.Render_FM_OP2 (Buffer,
                                         This.Params,
                                         This.Env0,
                                         This.Phase,
                                         This.Modulator_Phase,
                                         This.Pitch,
                                         This.Do_Strike);
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
