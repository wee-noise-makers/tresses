with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Bell
with Preelaborate
is

   type Additive_State is private;

   procedure Render_Bell (Buffer    :     out Mono_Buffer;
                          Params    :        Param_Array;
                          State     : in out Additive_State;
                          Pitch     :        Pitch_Range;
                          Do_Strike : in out Boolean);

   P_Damping     : constant Param_Id := 1;
   P_Coefficient : constant Param_Id := 2;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Damping     => "Damping",
          when P_Coefficient => "Coefficient",
          when others        => "N/A");

private

   Num_Bell_Partials : constant := 11;

   subtype Partials_Index is Natural range 0 .. Num_Bell_Partials - 1;
   type U32_Partials is array (Partials_Index) of U32;
   type S32_Partials is array (Partials_Index) of S32;
   type LP_Noise_Array is array (0 .. 2) of S32;

   type Additive_State is record
      Partial_Phase : U32_Partials := (others => 0);
      Partial_Phase_Increment : U32_Partials := (others => 0);
      Partial_Amplitude : S32_Partials := (others => 0);
      Previous_Sample : S16 := 0;
      Current_Partial : Partials_Index := 0;
   end record;

end Tresses.Drums.Bell;
