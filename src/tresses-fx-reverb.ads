with Tresses.FX.Delay_Line; use Tresses.FX.Delay_Line;

with Tresses.LFO;

package Tresses.FX.Reverb
with Preelaborate
is

   type Instance
   is record
      Buffer : Delay_Buffer (0 .. 16_384 - 1);

      Amount : Param_Range := Param_Range (0.54 * 32_767.0);
      Input_Gain : Param_Range := Param_Range (0.2 * 32_767.0);
      Reverb_Time : Param_Range := Param_Range (0.35 * 32_767.0);
      Diffusion : Param_Range := Param_Range (0.7 * 32_767.0);
      LP : Param_Range := Param_Range ((0.6 + 0.37) * 32_767.0);
      LP_Decay_1 : S16 := 0;
      LP_Decay_2 : S16 := 0;

      LFO_1, LFO_2 : Tresses.LFO.Instance;

      Write_Ptr : S16 := 0;

   end record;

   procedure Reset (This : in out Instance);

   procedure Process (This  : in out Instance;
                      Left  : in out Mono_Buffer;
                      Right : in out Mono_Buffer);

end Tresses.FX.Reverb;
