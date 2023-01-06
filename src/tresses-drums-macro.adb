with Tresses.Drums.Kick;
with Tresses.Drums.Analog_Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Clap;
with Tresses.Macro;

package body Tresses.Drums.Macro is

   ------------
   -- Engine --
   ------------

   function Engine (This : Instance) return Drum_Engines
   is (This.Engine);

   ----------------
   -- Set_Engine --
   ----------------

   procedure Set_Engine (This : in out Instance; E : Drum_Engines) is
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
      if This.Engine = Drum_Engines'Last then
         Set_Engine (This, Drum_Engines'First);
      else
         Set_Engine (This, Drum_Engines'Succ (This.Engine));
      end if;
   end Next_Engine;

   -----------------
   -- Prev_Engine --
   -----------------

   procedure Prev_Engine (This : in out Instance) is
   begin
      if This.Engine = Drum_Engines'First then
         Set_Engine (This, Drum_Engines'Last);
      else
         Set_Engine (This, Drum_Engines'Pred (This.Engine));
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
         when Drum_Kick =>
            Kick.Render_Kick (Buffer,
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
            Analog_Kick.Render_Analog_Kick
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
            Snare.Render_Snare (Buffer,
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
         when Drum_Clap =>
            Clap.Render_Clap (Buffer,
                              Params => This.Params,
                              Filter => This.Filter0,
                              Rng =>  This.Rng,
                              Env => This.Env0,
                              Re_Trig => This.Phase,
                              Pitch => This.Pitch,
                              Do_Init => This.Do_Init,
                              Do_Strike => This.Do_Strike);
         when Drum_Cymbal =>
            Cymbal.Render_Cymbal (Buffer,
                                  Params => This.Params,
                                  Filter0 => This.Filter0,
                                  Filter1 => This.Filter1,
                                  Env     => This.Env0,
                                  State => This.Cym_State,
                                  Phase => This.Phase,
                                  Pitch => This.Pitch,
                                  Do_Init => This.Do_Init,
                                  Do_Strike => This.Do_Strike);

         when Drum_Percussion =>
            Percussion.Render_Percussion (Buffer,
                                          Params    => This.Params,
                                          State     => This.Perc_State,
                                          Rng       => This.Rng,
                                          Pitch     => This.Pitch,
                                          Do_Strike => This.Do_Strike);

         when Drum_Bell =>
            Bell.Render_Bell (Buffer,
                              Params    => This.Params,
                              State     => This.Bell_State,
                              Pitch     => This.Pitch,
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

end Tresses.Drums.Macro;
