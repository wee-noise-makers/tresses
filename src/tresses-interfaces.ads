package Tresses.Interfaces
with Preelaborate
is

   type Four_Params_Voice is abstract tagged record
      Params    : Param_Array  := (others => Param_Range'Last / 2);
      Pitch     : Pitch_Range  := Init_Pitch;
      Do_Strike : Strike_State := (others => <>);
   end record;

   procedure Set_Pitch (This  : in out Four_Params_Voice;
                        Pitch :        Pitch_Range);

   procedure Note_On (This : in out Four_Params_Voice;
                      Velocity : Param_Range);

   procedure Note_Off (This : in out Four_Params_Voice);

   procedure Set_Param (This : in out Four_Params_Voice;
                        Id   :        Param_Id;
                        P    :        Param_Range);

   function Param_Label (This : Four_Params_Voice; Id : Param_Id)
                         return String
   is abstract;

   function Param_Short_Label (This : Four_Params_Voice; Id : Param_Id)
                               return Short_Label
   is abstract;

   type Four_Params_Stereo_FX
   is abstract new Four_Params_Voice with null record;

   procedure Render (This   : in out Four_Params_Stereo_FX;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer)
   is abstract;

end Tresses.Interfaces;
