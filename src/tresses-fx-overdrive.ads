package Tresses.FX.Overdrive
with Preelaborate
is
   procedure Process (Buffer    : in out Mono_Buffer;
                      Pre_Gain  :        Param_Range;
                      Amount    :        Param_Range;
                      Out_Level :        Param_Range)
     with Linker_Section => Code_Linker_Section;

end Tresses.FX.Overdrive;
