with Noise_Nugget_SDK.Audio;
with Test_Audio;
with System.Storage_Elements;
with Tresses.Resources;

package body CPU_Core_1 is

   procedure Main;

   -----------------
   -- Entry_Point --
   -----------------

   function Entry_Point return HAL.UInt32
   is (HAL.UInt32 (System.Storage_Elements.To_Integer (Main'Address)));

   ----------
   -- Main --
   ----------

   procedure Main is
   begin
      if not Noise_Nugget_SDK.Audio.Start
        (Tresses.Resources.SAMPLE_RATE,
         Output_Callback => Test_Audio.Output_Callback'Access,
         Input_Callback  => null)
      then
         raise Program_Error with "MDM";
      end if;

      Noise_Nugget_SDK.Audio.Set_HP_Volume (0.4, 0.4);
      Noise_Nugget_SDK.Audio.Enable_Speaker (True, True);
      Noise_Nugget_SDK.Audio.Set_Speaker_Volume (0.4, 0.4);

      loop
         Test_Audio.Update_Buffer;
      end loop;
   end Main;

end CPU_Core_1;
