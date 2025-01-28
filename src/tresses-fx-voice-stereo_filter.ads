with Tresses.Interfaces; use Tresses.Interfaces;

private with Tresses.Filters.SVF;

package Tresses.FX.Voice.Stereo_Filter
with Preelaborate
is

   type Instance
   is new Four_Params_Stereo_FX
   with private;

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer);

   P_Mode      : constant Param_Id := 1;
   P_Cutoff    : constant Param_Id := 2;
   P_Resonance : constant Param_Id := 3;
   P_Nope      : constant Param_Id := 4;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String
   is (case Id is
          when P_Mode      => "Mode",
          when P_Cutoff    => "Cutoff",
          when P_Resonance => "Resonance",
          when P_Nope      => "N/A");

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (case Id is
          when P_Mode      => "MOD",
          when P_Cutoff    => "CTF",
          when P_Resonance => "RES",
          when P_Nope      => "N/A");

private

   type Instance
   is new Four_Params_Stereo_FX
   with record
      Left  : Tresses.Filters.SVF.Instance;
      Right : Tresses.Filters.SVF.Instance;
   end record;

end Tresses.FX.Voice.Stereo_Filter;
