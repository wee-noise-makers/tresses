with Tresses.DSP;

package body Tresses.FX.Delay_Line is

   -----------
   -- Reset --
   -----------

   procedure Reset (This : in out Instance) is
   begin
      This.Buffer := (others => 0);
      This.Del := 1;
      This.Write_Ptr := This.Buffer'First;
   end Reset;

   ---------------
   -- Set_Delay --
   ---------------

   procedure Set_Delay (This : in out Instance; Del : U16) is
   begin
      This.Del := Del;
   end Set_Delay;

   -----------
   -- Write --
   -----------

   procedure Write (This : in out Instance; Sample : S16) is
   begin
      This.Buffer (This.Write_Ptr) := Sample;
      This.Write_Ptr :=
        (This.Write_Ptr - 1 + This.Max_Delay) mod This.Max_Delay;
   end Write;

   ----------
   -- Read --
   ----------

   function Read (This : Instance) return S16 is
   begin
      return This.Buffer ((This.Write_Ptr + This.Del) mod This.Max_Delay);
   end Read;

   -------------
   -- Process --
   -------------

   procedure Process (This     : in out Instance;
                      Buffer   : in out Mono_Buffer;
                      Time     :        Param_Range;
                      Feedback :        Param_Range)
   is
      Time_F : constant Float := Float (Time) / Float (Param_Range'Last);
      In_Sample : S32;
      Out_Sample : S32;
      Fdb_Sample : S32;
      Read_Sample : S32;
   begin
      Set_Delay (This, U16 (Float (This.Max_Delay) * Time_F));

      for Elt of Buffer loop
         In_Sample := S32 (Elt);
         Read_Sample := S32 (Read (This));

         Out_Sample := In_Sample + Read_Sample;
         DSP.Clip_S16 (Out_Sample);
         Elt := S16 (Out_Sample);

         --  Feedback
         Fdb_Sample := In_Sample +
           ((Read_Sample * S32 (Feedback)) / 2**16);
         Write (This, S16 (Fdb_Sample));

      end loop;

   end Process;

end Tresses.FX.Delay_Line;
