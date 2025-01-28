package body Tresses.FX.Voice.Stereo_Reverb is

   ------------
   -- Render --
   ------------

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer)
   is
   begin
      Reverb_Pck.Set_Amount (This.Rev, This.Params (P_Amount));
      Reverb_Pck.Set_Time (This.Rev, This.Params (P_Time));
      Reverb_Pck.Set_Diffusion (This.Rev, This.Params (P_Diffusion));
      Reverb_Pck.Set_Low_Pass (This.Rev, This.Params (P_Cutoff));
      Reverb_Pck.Process (This.Rev, Left, Right);
   end Render;

end Tresses.FX.Voice.Stereo_Reverb;
