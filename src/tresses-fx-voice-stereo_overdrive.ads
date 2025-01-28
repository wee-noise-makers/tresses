with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.FX.Voice.Stereo_Overdrive
with Preelaborate
is

   type Instance
   is new Four_Params_Stereo_FX
   with private;

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer);

   P_Gain  : constant Param_Id := 1;
   P_Drive : constant Param_Id := 2;
   P_Pan   : constant Param_Id := 3;
   P_Level : constant Param_Id := 4;

   --  Interfaces --

   overriding
   function Param_Label (This : Instance; Id : Param_Id) return String
   is (case Id is
          when P_Gain  => "Pre-Gain",
          when P_Drive => "Drive",
          when P_Pan   => "Pan",
          when P_Level => "Output Level");

   overriding
   function Param_Short_Label (This : Instance; Id : Param_Id)
                               return Short_Label
   is (case Id is
          when P_Gain  => "PRE",
          when P_Drive => "DRV",
          when P_Pan   => "PAN",
          when P_Level => "LVL");

private

   type Instance
   is new Four_Params_Stereo_FX
   with null record;

end Tresses.FX.Voice.Stereo_Overdrive;
