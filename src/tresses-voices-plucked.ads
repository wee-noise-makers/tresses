with Tresses.Random;
with Tresses.Envelopes.AD;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Voices.Plucked
with Preelaborate
is

   type Pluck_State is private;

   Number_Of_Voices : constant := 4;
   Elt_Per_Voice    : constant := 1024 + 1;
   type KS_Array
   is array (U32 range 0 .. (Number_Of_Voices * Elt_Per_Voice) - 1) of S16;

   procedure Render_Plucked
     (Buffer                      :    out Mono_Buffer;
      Params                      :        Param_Array;
      Rng                         : in out Random.Instance;
      Env                         : in out Envelopes.AD.Instance;
      State                       : in out Pluck_State;
      KS                          : in out KS_Array;
      Pitch                       :        Pitch_Range;
      Do_Strike                   : in out Boolean);

   P_String_Decay : constant Param_Id := 1;
   P_Position     : constant Param_Id := 2;
   P_Attack       : constant Param_Id := 3;
   P_Decay        : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_String_Decay => "String Decay",
          when P_Position     => "Position",
          when P_Attack       => "Attack",
          when P_Decay        => "Decay");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_String_Decay => "SDY",
          when P_Position     => "POS",
          when P_Attack       => "ATK",
          when P_Decay        => "DCY");

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

end Tresses.Voices.Plucked;
