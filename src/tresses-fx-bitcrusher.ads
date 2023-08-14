with Tresses.Filters.SVF;

package Tresses.FX.Bitcrusher
with Preelaborate
is
   type Bitdepth is range 1 .. 16;

   function Param_To_Depth (P : Param_Range) return Bitdepth
   is (Bitdepth (1 + (P / (Param_Range'Last / 15))));

   type Downsampling is range 1 .. 32;

   function Param_To_Downsampling (P : Param_Range) return Downsampling
   is (Downsampling (1 + (P / (Param_Range'Last / 31))));

   type Instance is private;

   procedure Process (This     : in out Instance;
                      Buffer   : in out Mono_Buffer;
                      Depth    :        Bitdepth;
                      DS       :        Downsampling;
                      Amount   :        Param_Range;
                      Cutoff   :        Param_Range)
     with Linker_Section => Code_Linker_Section;

private

   type Instance is record
      Do_Init : Boolean := True;
      Filter : Tresses.Filters.SVF.Instance;
      Last_Sample : S16 := 0;
      Sample : S16 := 0;
      Acc : S16 := 0;
      Step   : S16 := 0;
      Sample_Count : U32 := 0;
   end record;

end Tresses.FX.Bitcrusher;
