with Tresses.Drums.Cymbal;
with Tresses.Drums.Percussion;
with Tresses.Drums.Bell;

with Tresses.Excitation;
with Tresses.Random;
with Tresses.Filters.SVF;
with Tresses.Envelopes.AD;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Macro
with Preelaborate
is
   --  A macro engine that can play all the drum sounds

   type Instance
   is new Four_Params_Voice
   with private;

   function Engine (This : Instance) return Drum_Engines;
   procedure Set_Engine (This : in out Instance; E : Drum_Engines);
   procedure Next_Engine (This : in out Instance);
   procedure Prev_Engine (This : in out Instance);

   procedure Init (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; P : Param_Id) return String;

private

   type Instance
   is new Four_Params_Voice
   with record

      Engine : Drum_Engines := Drum_Engines'First;

      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter3 : Filters.SVF.Instance;
      Rng : Random.Instance;
      Env : Envelopes.AD.Instance;

      Bell_State : Bell.Additive_State;
      Perc_State : Percussion.Additive_State;
      LP_State : S32 := 0;
      Cym_State : Cymbal.Cymbal_State;
      Phase : U32 := 0;

      Do_Init : Boolean := True;

   end record;

end Tresses.Drums.Macro;
