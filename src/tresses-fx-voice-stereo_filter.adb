with Tresses.Filters.SVF; use Tresses.Filters.SVF;

package body Tresses.FX.Voice.Stereo_Filter is

   ------------
   -- Render --
   ------------

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer)
   is
   begin
      Set_Frequency (This.Left, This.Params (P_Cutoff));
      Set_Frequency (This.Right, This.Params (P_Cutoff));

      Set_Resonance (This.Left, This.Params (P_Resonance));
      Set_Resonance (This.Right, This.Params (P_Resonance));

      declare
         Third : constant Tresses.Param_Range := Tresses.Param_Range'Last / 3;
         Filter_Mode : constant Mode_Kind :=
           (case This.Params (P_Mode) is
               when 0 .. Third => Low_Pass,
               when Third + 1 .. 2 * Third => Band_Pass,
               when others => High_Pass);
      begin
         Tresses.Filters.SVF.Set_Mode (This.Left, Filter_Mode);
         Tresses.Filters.SVF.Set_Mode (This.Right, Filter_Mode);
      end;

      for Elt of Left loop
         Elt := S16 (Tresses.Filters.SVF.Process (This.Left, S32 (Elt)));
      end loop;

      for Elt of Right loop
         Elt := S16 (Tresses.Filters.SVF.Process (This.Right, S32 (Elt)));
      end loop;

   end Render;

end Tresses.FX.Voice.Stereo_Filter;
