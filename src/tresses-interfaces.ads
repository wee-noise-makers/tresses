package Tresses.Interfaces
with Preelaborate
is

   type Param_Id is range 1 .. 4;
   type Param_Array is array (Param_Id) of Param_Range;

   type Four_Params_Voice is abstract tagged record
      Params    : Param_Array := (others => Param_Range'Last / 2);
      Pitch     : Pitch_Range := Init_Pitch;
      Do_Strike : Boolean := False;
   end record;

   procedure Set_Pitch (This  : in out Four_Params_Voice;
                        Pitch :        Pitch_Range);

   procedure Strike (This : in out Four_Params_Voice);

   procedure Set_Param (This : in out Four_Params_Voice;
                        Id   :        Param_Id;
                        P    :        Param_Range);

   function Param_Label (This : Four_Params_Voice; Id : Param_Id)
                         return String
   is abstract;

end Tresses.Interfaces;
