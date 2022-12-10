with Tresses.Envelopes.AD;
with Tresses.Filters.SVF;
with Tresses.Random;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Cymbal
with Preelaborate
is
   type Cymbal_State is private;

   procedure Render_Cymbal
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Filter0, Filter1 : in out Filters.SVF.Instance;
      Env              : in out Envelopes.AD.Instance;
      State            : in out Cymbal_State;
      Phase            : in out U32;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Boolean);

   P_Cutoff : constant Param_Id := 1;
   P_Noise  : constant Param_Id := 2;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Cutoff => "Cutoff",
          when P_Noise  => "Noise",
          when others   => "N/A");

private

   type Cymbal_Phase_Array is array (0 .. 5) of U32;

   type Cymbal_State is record
      Phase : Cymbal_Phase_Array := (others => 0);
      Rng : Random.Instance;
      Last_Noise : U32 := 0;
   end record;

end Tresses.Drums.Cymbal;
