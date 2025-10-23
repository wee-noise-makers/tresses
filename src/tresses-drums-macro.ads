with Tresses.Drums.Cymbal;
with Tresses.Drums.Percussion;
with Tresses.Drums.Bell;

with Tresses.Excitation;
with Tresses.Random;
with Tresses.Filters.SVF;
with Tresses.Envelopes.AR;
with Tresses.Resources;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Macro
with Preelaborate
is
   --  A macro engine that can play all the drum sounds

   type Instance
   is new Four_Params_Voice
   with private;

   function Engine (This : Instance) return Drum_Engines
     with Linker_Section => Code_Linker_Section;
   procedure Set_Engine (This : in out Instance; E : Drum_Engines)
     with Linker_Section => Code_Linker_Section;
   procedure Next_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;
   procedure Prev_Engine (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Init (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Set_User_Waveform
     (This : in out Instance;
      Wave : not null access constant Resources.Table_257_S16)
     with Linker_Section => Code_Linker_Section;

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String;

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label;

private

   type Instance
   is new Four_Params_Voice
   with record

      Engine : Drum_Engines := Drum_Engines'First;

      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter3 : Filters.SVF.Instance;
      Rng : Random.Instance;
      Env0, Env1 : Envelopes.AR.Instance;

      Bell_State : Bell.Additive_State;
      Perc_State : Percussion.Additive_State;
      LP_State : S32 := 0;
      Cym_State : Cymbal.Cymbal_State;
      Phase : U32 := 0;
      Target_Phase_Increment, Phase_Increment : U32 := 0;

      Do_Init : Boolean := True;

      User_Waveform : not null access constant Resources.Table_257_S16 :=
        Resources.WAV_Sine2_Warp2'Access;
   end record;

end Tresses.Drums.Macro;
