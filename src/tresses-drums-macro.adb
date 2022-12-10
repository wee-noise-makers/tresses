with Tresses.Drums.Kick;
with Tresses.Drums.Snare;

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
                              Pulse2      => This.Pulse2,
                              Filter      => This.Filter0,
                              LP_State    => This.LP_State,
                              Pitch       => This.Pitch,
                              Do_Init     => This.Do_Init,
                              Do_Strike   => This.Do_Strike);
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
         when Drum_Cymbal =>
            Cymbal.Render_Cymbal (Buffer,
                                  Params => This.Params,
                                  Filter0 => This.Filter0,
                                  Filter1 => This.Filter1,
                                  Env => This.Env,
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
   function Param_Label (This : Instance; P : Param_Id) return String is
   begin
      case This.Engine is
         when Drum_Kick =>
            return Kick.Param_Label (P);

         when Drum_Snare =>
            return Snare.Param_Label (P);

         when Drum_Cymbal =>
            return Cymbal.Param_Label (P);

         when Drum_Percussion =>
            return Percussion.Param_Label (P);

         when Drum_Bell =>
            return Bell.Param_Label (P);
      end case;
   end Param_Label;

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

end Tresses.Drums.Macro;
