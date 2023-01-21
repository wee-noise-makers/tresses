package Tresses.FX.Delay_Line
with Preelaborate
is

   type Delay_Buffer is array (U16 range <>) of S16;

   type Instance (Max_Delay : U16) is record
      Buffer : Delay_Buffer (0 .. Max_Delay);
      Del : U16 := 1;
      Write_Ptr : U16 := 1;
   end record;

   procedure Reset (This : in out Instance);

   procedure Set_Delay (This : in out Instance; Del : U16);

   procedure Write (This : in out Instance; Sample : S16);

   function Read (This : Instance) return S16;

   procedure Process (This     : in out Instance;
                      Buffer   : in out Mono_Buffer;
                      Time     :        Param_Range;
                      Feedback :        Param_Range);

end Tresses.FX.Delay_Line;
