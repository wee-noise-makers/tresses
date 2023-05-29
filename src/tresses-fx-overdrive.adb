with Tresses.DSP;
with Tresses.Resources;

package body Tresses.FX.Overdrive is

   -------------
   -- Process --
   -------------

   procedure Process (Buffer    : in out Mono_Buffer;
                      Pre_Gain  :        Param_Range;
                      Amount    :        Param_Range;
                      Out_Level :        Param_Range)
   is
      Fuzzed : Tresses.Mono_Point;

      Sample : S32;
   begin
      for Elt of Buffer loop

         Sample := (S32 (Elt) * (S32 (Pre_Gain) + S32 (S16'Last))) / 2**15;
         DSP.Clip_S16 (Sample);

         Fuzzed := DSP.Interpolate88
           (Resources.WS_Violent_Overdrive,
            U16 (Sample + 32_768));

         --  Mix clean and overdrive signals
         Elt := DSP.Mix (Elt, Fuzzed, Amount);

         --  Output level
         Elt := S16 ((S32 (Elt) * S32 (Out_Level)) / 2**15);
      end loop;
   end Process;

end Tresses.FX.Overdrive;
