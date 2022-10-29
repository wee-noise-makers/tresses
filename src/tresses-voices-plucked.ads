with Tresses.Random;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Plucked
with Preelaborate
is
   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with private;

   procedure Set_Decay (This : in out Instance; P0 : Param_Range);

   procedure Set_Position (This : in out Instance; P1 : Param_Range);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   type Pluck_State is private;

   Number_Of_Voices : constant := 4;
   type KS_Array
   is array (U32 range 0 .. (Number_Of_Voices * 1025) - 1) of S16;

   procedure Render_Plucked
     (Buffer                      :    out Mono_Buffer;
      Decay_Param, Position_Param :        Param_Range;
      Rng                         : in out Random.Instance;
      State                       : in out Pluck_State;
      KS                          : in out KS_Array;
      Pitch                       :        Pitch_Range;
      Do_Strike                   : in out Boolean);

   --  Interfaces --

   overriding
   procedure Strike (This : in out Instance);

   overriding
   procedure Set_Pitch (This  : in out Instance;
                        Pitch :        Pitch_Range);

   overriding
   procedure Set_Param1 (This : in out Instance; P : Param_Range)
   renames Set_Decay;

   overriding
   procedure Set_Param2 (This : in out Instance; P : Param_Range)
   renames Set_Position;

private

   type Phase_Array is array (0 .. 5) of U32;
   type Filter_State_Matrix is array (0 .. 1, 0 .. 1) of S32;

   type Pluck_Voice is record
      Size                : U32 := 0;
      Write_Ptr           : U32 := 0;
      Shift               : Natural := 0;
      Mask                : U32 := 0;
      Initialization_Ptr  : U32 := 0;
      Phase               : U32 := 0;
      Phase_Increment     : U32 := 0;
      Max_Phase_Increment : U32 := 0;
      Prev_Sample         : S16 := 0;
   end record;

   type Pluck_Voice_Array is array (U32 range <>) of Pluck_Voice;

   type Pluck_State is record
      Voices : Pluck_Voice_Array (0 .. Number_Of_Voices - 1);
      Active : U32 := 0;
   end record;

   type Instance
   is new Pitched_Voice and Strike_Voice and Two_Params_Voice
   with record
      State : Pluck_State;
      KS    : KS_Array;

      Rng   : Random.Instance;

      Pitch : Pitch_Range := Init_Pitch;

      Do_Strike : Boolean := False;

      Decay_Param : Param_Range := 0;
      Position_Param : Param_Range := 0;
   end record;

end Tresses.Voices.Plucked;
