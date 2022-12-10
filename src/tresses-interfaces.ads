package Tresses.Interfaces
with Preelaborate
is

   type Pitched_Voice is interface;

   procedure Set_Pitch (This  : in out Pitched_Voice;
                        Pitch :        Pitch_Range)
   is abstract;

   type Strike_Voice is interface;

   procedure Strike (This : in out Strike_Voice)
   is abstract;

   type Four_Params_Voice is interface;

   type Param_Id is range 1 .. 4;
   type Param_Array is array (Param_Id) of Param_Range;

   procedure Set_Param (This : in out Four_Params_Voice;
                        Id   :        Param_Id;
                        P    :        Param_Range)
   is abstract;

   function Param_Label (This : Four_Params_Voice; Id : Param_Id)
                         return String
   is abstract;

end Tresses.Interfaces;
