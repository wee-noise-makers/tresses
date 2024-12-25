with Core_1_Utils;
with CPU_Core_1;
with Noise_Nugget_SDK; use Noise_Nugget_SDK;
with PGB1; use PGB1;
with RP.Device;
with RP.Multicore.FIFO;
with Test_Audio; use Test_Audio;

with Tresses; use Tresses;

with HW_Div;

procedure Pgb1_Perf_Test is

   Events : PGB1.BM_Definition.Button_Event_Array;

   type TP_Img is delta 0.01 range 0.0 .. 100.0;
begin
   Core_1_Utils.Start (CPU_Core_1.Entry_Point);
   RP.Device.Timer.Enable;

   loop
      PGB1.Button_State.Update;
      Events := PGB1.Button_State.Events;

      if Events (PAD_B) = Falling then
         RP.Multicore.FIFO.Push_Blocking (Test_Audio.Cmd_Reset_Measurements);
      end if;
      if Events (PAD_Up) = Falling then
         RP.Multicore.FIFO.Push_Blocking (Test_Audio.Cmd_Next_Engine);
      end if;
      if Events (PAD_Down) = Falling then
         RP.Multicore.FIFO.Push_Blocking (Test_Audio.Cmd_Prev_Engine);
      end if;

      pragma Style_Checks ("M120");

      Screen.Clear;
      PGB1.Print (0, 0, "Eng:" & Test_Audio.Engine'Img);
      PGB1.Print (0, 10, "Last:" & Last_Render_Time'Img &
                    TP_Img'Image (TP_Img (Last_CPU_Charge_Percent * 100.0)) & "%");
      PGB1.Print (0, 20, "Max:" & Max_Render_Time'Img &
                    TP_Img'Image (TP_Img (Max_CPU_Charge_Percent * 100.0)) & "%");
      PGB1.Print (0, 30, "Min:" & Min_Render_Time'Img);
      PGB1.Print (0, 40, "Mean:" & Mean_Render_Time'Img &
                    TP_Img'Image (TP_Img (Mean_CPU_Charge_Percent * 100.0)) & "%");
      Screen.Update;
      LED_Strip.Update;

      RP.Device.Timer.Delay_Milliseconds (100);
   end loop;
end Pgb1_Perf_Test;
