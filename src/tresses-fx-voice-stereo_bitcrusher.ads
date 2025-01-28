with Tresses.Interfaces; use Tresses.Interfaces;

private with Tresses.FX.Bitcrusher;

package Tresses.FX.Voice.Stereo_Bitcrusher
with Preelaborate
is

   type Instance
   is new Four_Params_Stereo_FX
   with private;

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer);

   P_Depth  : constant Param_Id := 1;
   P_Down   : constant Param_Id := 2;
   P_Cutoff : constant Param_Id := 3;
   P_Mix    : constant Param_Id := 4;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String
   is (case Id is
          when P_Depth  => "Depth",
          when P_Down   => "Downsampling",
          when P_Cutoff => "Cutoff",
          when P_Mix    => "Mix");

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (case Id is
          when P_Depth  => "DPT",
          when P_Down   => "DSP",
          when P_Cutoff => "CTF",
          when P_Mix    => "MIX");

private

   type Instance
   is new Four_Params_Stereo_FX
   with record
      BTL : Tresses.FX.Bitcrusher.Instance;
      BTR : Tresses.FX.Bitcrusher.Instance;
   end record;

end Tresses.FX.Voice.Stereo_Bitcrusher;
