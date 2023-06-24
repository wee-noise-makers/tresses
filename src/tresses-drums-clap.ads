with Tresses.Filters.SVF;
with Tresses.Random;
with Tresses.Envelopes.AR;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Clap
with Preelaborate
is

   procedure Render_Clap
     (Buffer    :    out Mono_Buffer;
      Params    :        Param_Array;
      Filter    : in out Filters.SVF.Instance;
      Rng       : in out Random.Instance;
      Env       : in out Envelopes.AR.Instance;
      Re_Trig   : in out U32;
      Pitch     :        Pitch_Range;
      Do_Init   : in out Boolean;
      Do_Strike : in out Strike_State);

   P_Decay : constant Param_Id := 1;
   P_Sync  : constant Param_Id := 2;
   P_Tone  : constant Param_Id := 3;
   P_Drive : constant Param_Id := 4;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Decay => "Decay",
          when P_Sync  => "Sync",
          when P_Tone  => "Tone",
          when P_Drive => "Drive");

   function Param_Short_Label (Id : Param_Id) return Short_Label
   is (case Id is
          when P_Decay => "DCY",
          when P_Sync  => "SYN",
          when P_Tone  => "TON",
          when P_Drive => "DRV");

   -- Interfaces --

   type Instance
   is new Four_Params_Voice
   with private;

   overriding
   function Param_Label (This : Instance; Id : Param_Id)
                         return String
   is (Param_Label (Id));

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (Param_Short_Label (Id));
   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

private

   type Instance
   is new Four_Params_Voice
   with record
      Re_Trig : U32 := 0;
      Filter  : Filters.SVF.Instance;
      Rng     : Random.Instance;
      Env     : Envelopes.AR.Instance;
      Do_Init : Boolean := True;
   end record;

end Tresses.Drums.Clap;
