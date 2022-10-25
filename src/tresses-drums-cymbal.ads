with Tresses.Envelopes.AD;
with Tresses.Filters.SVF;
with Tresses.Random;

package Tresses.Drums.Cymbal
with Preelaborate
is
   type Instance is private;

   procedure Init (This : in out Instance);

   procedure Set_Cutoff (This : in out Instance; P0 : U16);

   procedure Set_Noise (This : in out Instance; P1 : U16);

   procedure Strike (This : in out Instance);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   type Cymbal_State is private;

   procedure Render_Cymbal
     (Buffer                    :    out Mono_Buffer;
      Cutoff_Param, Noise_Param :        U16;
      Filter0, Filter1          : in out Filters.SVF.Instance;
      Env                       : in out Envelopes.AD.Instance;
      State                     : in out Cymbal_State;
      Phase                     : in out U32;
      Pitch                     :        S16;
      Do_Init                   : in out Boolean;
      Do_Strike                 : in out Boolean);
private

   type Cymbal_Phase_Array is array (0 .. 5) of U32;

   type Cymbal_State is record
      Phase : Cymbal_Phase_Array := (others => 0);
      Rng : Random.Instance;
      Last_Noise : U32 := 0;
   end record;

   type Instance is record
      Env : Envelopes.AD.Instance;

      Filter0, Filter1 : Filters.SVF.Instance;

      State : Cymbal_State;

      Pitch : S16 := 12 * 128 * 6;
      Phase : U32 := 0;

      Do_Strike : Boolean := False;
      Do_Init : Boolean := True;

      Cutoff_Param : U16 := 0;
      Noise_Param : U16 := 0;
   end record;

end Tresses.Drums.Cymbal;
