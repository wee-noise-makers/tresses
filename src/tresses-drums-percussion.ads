with Tresses.Random;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Percussion
with Preelaborate
is
   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   procedure Set_Damping (This : in out Instance; Damping : Param_Range);
   procedure Set_Coefficient (This : in out Instance; Coef : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   type Additive_State is private;

   procedure Render_Percussion
     (Buffer               :     out Mono_Buffer;
      Damping, Coefficient :        Param_Range;
      State                : in out Additive_State;
      Rng                  : in out Random.Instance;
      Pitch                :        Pitch_Range;
      Do_Strike            : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Damping;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_Coefficient;

private

   Num_Drum_Partials : constant := 6;

   subtype Partials_Index is Natural range 0 .. Num_Drum_Partials - 1;
   type U32_Partials is array (Partials_Index) of U32;
   type S32_Partials is array (Partials_Index) of S32;
   type LP_Noise_Array is array (0 .. 2) of S32;

   type Additive_State is record
      Partial_Phase : U32_Partials := (others => 0);
      Partial_Phase_Increment : U32_Partials := (others => 0);
      Partial_Amplitude : S32_Partials := (others => 0);
      Target_Partial_Amplitude : S32_Partials := (others => 0);
      Previous_Sample : S16 := 0;
      LP_Noise : LP_Noise_Array;
   end record;

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record
      Rng : Random.Instance;

      State : Additive_State;
      Pitch : Pitch_Range := Init_Pitch;

      Do_Strike : Boolean := False;

      Damping : Param_Range := 0;
      Coefficient : Param_Range := 0;
   end record;

end Tresses.Drums.Percussion;
