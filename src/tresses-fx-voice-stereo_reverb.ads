with Tresses.Interfaces; use Tresses.Interfaces;
with Tresses.FX.Reverb;

generic
   with package Reverb_Pck is new Tresses.FX.Reverb (<>);
package Tresses.FX.Voice.Stereo_Reverb
with Preelaborate
is

   type Instance (Buffer : not null access Reverb_Pck.Reverb_Buffer)
   is new Four_Params_Stereo_FX
   with private;

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer);

   P_Amount    : constant Param_Id := 1;
   P_Time      : constant Param_Id := 2;
   P_Diffusion : constant Param_Id := 3;
   P_Cutoff    : constant Param_Id := 4;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String
   is (case Id is
          when P_Amount    => "Amount",
          when P_Time      => "Time",
          when P_Diffusion => "Diffusion",
          when P_Cutoff    => "LP Cutoff");

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (case Id is
          when P_Amount    => "AMT",
          when P_Time      => "TIM",
          when P_Diffusion => "DIF",
          when P_Cutoff    => "CTF");

private

   type Instance (Buffer : not null access Reverb_Pck.Reverb_Buffer)
   is new Four_Params_Stereo_FX
   with record
      Rev : Reverb_Pck.Instance (Buffer);
   end record;

end Tresses.FX.Voice.Stereo_Reverb;
