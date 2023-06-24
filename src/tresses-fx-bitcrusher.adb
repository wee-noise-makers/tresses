with Ada.Unchecked_Conversion;
with Tresses.DSP;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

package body Tresses.FX.Bitcrusher is

   -------------
   -- Process --
   -------------

   procedure Process (This     : in out Instance;
                      Buffer   : in out Mono_Buffer;
                      Depth    :        Bitdepth;
                      DS       :        Downsampling;
                      Amount   :        Param_Range;
                      Cutoff   :        Param_Range)

   is
      Down_Factor : constant U32 := U32 (DS);

      Shift : constant Natural := 16 - Natural (Depth);

      Mask : constant U16 := Shift_Left (U16'Last, Shift);

      function To_U16 is new Ada.Unchecked_Conversion (S16, U16);
      function To_S16 is new Ada.Unchecked_Conversion (U16, S16);

      function "and" (A : S16; B : U16) return S16
      is (To_S16 (To_U16 (A) and B));

      Filtered : S16;
      Masked   : S16;
   begin

      if This.Do_Init then
         This.Do_Init := False;

         Init (This.Filter);
         Set_Mode (This.Filter, Low_Pass);
      end if;

      Set_Frequency (This.Filter, Cutoff);

      for Elt of Buffer loop

         --  Take one sample every X input sample
         if This.Sample_Count mod Down_Factor = 0 then
            This.Last_Sample := This.Sample;
            This.Sample := Elt;

            --  Prepare for linear interpolation
            This.Acc := This.Last_Sample;
            This.Step :=
              S16 ((S32 (This.Sample) - S32 (This.Last_Sample)) /
                     S32 (Down_Factor));
         else
            --  Next sample interpolation
            This.Acc := This.Acc + This.Step;
         end if;

         --  Apply bit reduction mask
         Masked := This.Acc and Mask;

         --  Filter output
         Filtered := S16 (Process (This.Filter, S32 (Masked)));

         --  Wet/Dry mix
         Elt := DSP.Mix (Elt, Filtered, Amount);

         This.Sample_Count := This.Sample_Count + 1;
      end loop;
   end Process;

end Tresses.FX.Bitcrusher;
