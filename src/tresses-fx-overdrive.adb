with Tresses.DSP;
with Tresses.Resources;

package body Tresses.FX.Overdrive is

   -------------
   -- Process --
   -------------

   procedure Process (Buffer : in out Mono_Buffer;
                      Amount :        Param_Range)
   is
      Fuzzed : Tresses.Mono_Point;
   begin
      for Elt of Buffer loop
         --  Symmetrical soft clipping
         Fuzzed := DSP.Interpolate88
           (Resources.WS_Violent_Overdrive,
            U16 (S32 (Elt) + 32_768));

         --  Mix clean and overdrive signals
         Elt := DSP.Mix (Elt, Fuzzed, U16 (Amount));
      end loop;
   end Process;

end Tresses.FX.Overdrive;
