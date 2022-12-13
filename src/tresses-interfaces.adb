package body Tresses.Interfaces is

   ---------------
   -- Set_Pitch --
   ---------------

   procedure Set_Pitch (This  : in out Four_Params_Voice;
                        Pitch :        Pitch_Range)
   is
   begin
      This.Pitch := Pitch;
   end Set_Pitch;

   ------------
   -- Strike --
   ------------

   procedure Strike (This : in out Four_Params_Voice) is
   begin
      This.Do_Strike := True;
   end Strike;

   ---------------
   -- Set_Param --
   ---------------

   procedure Set_Param (This : in out Four_Params_Voice;
                        Id   :        Param_Id;
                        P    :        Param_Range)
   is
   begin
      This.Params (Id) := P;
   end Set_Param;

end Tresses.Interfaces;
