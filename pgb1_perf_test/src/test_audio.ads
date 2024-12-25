with HAL;
with System;
with Tresses;

package Test_Audio is

   Cmd_Reset_Measurements : constant HAL.UInt32 := 1;
   Cmd_Next_Engine        : constant HAL.UInt32 := 2;
   Cmd_Prev_Engine        : constant HAL.UInt32 := 3;

   Last_Render_Time : HAL.UInt32 := 0
     with Atomic, Volatile;
   Max_Render_Time  : HAL.UInt32 := 0
     with Atomic, Volatile;
   Min_Render_Time  : HAL.UInt32 := HAL.UInt32'Last
     with Atomic, Volatile;
   Mean_Render_Time  : HAL.UInt32 := HAL.UInt32'Last
     with Atomic, Volatile;
   Last_CPU_Charge_Percent : Float := 0.0
     with Atomic, Volatile;
   Max_CPU_Charge_Percent : Float := 0.0
     with Atomic, Volatile;
   Mean_CPU_Charge_Percent : Float := 0.0
     with Atomic, Volatile;

   procedure Output_Callback (Buffer             : out System.Address;
                              Stereo_Point_Count : out HAL.UInt32);

   procedure Update_Buffer;

   function Engine return Tresses.Engines;

end Test_Audio;
