with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;
with Tresses.Random;

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

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
   is
   begin
      case This.Engine is
         when Voice_Saw_Swarm =>
            Saw_Swarm.Render_Saw_Swarm (Buffer,
                                        Detune_Param    => This.P1,
                                        High_Pass_Param => This.P1,
                                        Rng             => This.Rng,
                                        State           => This.Saw_Swarm_State,
                                        Phase           => This.Phase,
                                        Pitch           => This.Pitch,
                                        Do_Strike       => This.Do_Strike);
         when Voice_Plucked =>
            Plucked.Render_Plucked (Buffer,
                                    Decay_Param    => This.P1,
                                    Position_Param => This.P1,
                                    Rng            =>  This.Rng,
                                    State          =>  This.Pluck_State,
                                    KS             =>  This.KS,
                                    Pitch          =>  This.Pitch,
                                    Do_Strike      =>  This.Do_Strike);
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
   procedure Set_Pitch (This : in out Instance;
                        Pitch : S16)
   is
   begin
      This.Pitch := Pitch;
   end Set_Pitch;

   ----------------
   -- Set_Param1 --
   ----------------

   overriding
   procedure Set_Param1 (This : in out Instance; P : U16) is
   begin
      This.P1 := P;
   end Set_Param1;

   ----------------
   -- Set_Param2 --
   ----------------

   overriding
   procedure Set_Param2 (This : in out Instance; P : U16) is
   begin
      This.P2 := P;
   end Set_Param2;

end Tresses.Voices.Macro;
