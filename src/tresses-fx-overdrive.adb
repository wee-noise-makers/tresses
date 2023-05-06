with Tresses.DSP;
with Tresses.Resources;

package body Tresses.FX.Overdrive is

   -------------
   -- Process --
   -------------

   procedure Process (Buffer    : in out Mono_Buffer;
                      Amount    :        Param_Range;
                      Out_Level :        Param_Range)
   is
      Fuzzed : Tresses.Mono_Point;
   begin
      for Elt of Buffer loop
         --  Asymmetrical soft clipping
         if Elt > 0 then
            Fuzzed := DSP.Interpolate88
              (Resources.WS_Violent_Overdrive,
               U16 (S32 (Elt) + 32_768));
         else
            Fuzzed := Elt;
         end if;

         --  Mix clean and overdrive signals
         Elt := DSP.Mix (Elt, Fuzzed, Amount);

         --  Output level
         Elt := S16 ((S32 (Elt) * S32 (Out_Level)) / 2**15);
      end loop;
   end Process;

end Tresses.FX.Overdrive;
