with Tresses.FX.Bitcrusher; use Tresses.FX.Bitcrusher;

package body Tresses.FX.Voice.Stereo_Bitcrusher
with Preelaborate
is

   ------------
   -- Render --
   ------------

   overriding
   procedure Render (This   : in out Instance;
                     Left   : in out Mono_Buffer;
                     Right  : in out Mono_Buffer)
   is

   begin
      Process (This.BTL, Left,
               Param_To_Depth (This.Params (P_Depth)),
               Param_To_Downsampling (This.Params (P_Down)),
               Amount => This.Params (P_Mix),
               Cutoff => This.Params (P_Cutoff));

      Process (This.BTR, Right,
               Param_To_Depth (This.Params (P_Depth)),
               Param_To_Downsampling (This.Params (P_Down)),
               Amount => This.Params (P_Mix),
               Cutoff => This.Params (P_Cutoff));
   end Render;

end Tresses.FX.Voice.Stereo_Bitcrusher;
