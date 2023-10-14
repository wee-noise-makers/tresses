package body Tresses is

   -------------
   -- Add_Sat --
   -------------

   function Add_Sat (A, B : Param_Range) return Param_Range is
      Res : constant S32 := S32 (A) + S32 (B);
   begin
      if Res > S32  (Param_Range'Last) then
         return Param_Range'Last;
      elsif Res < S32 (Param_Range'First) then
         return Param_Range'First;
      else
         return Param_Range (Res);
      end if;
   end Add_Sat;

   -------------
   -- Sub_Sat --
   -------------

   function Sub_Sat (A, B : Param_Range) return Param_Range is
      Res : constant S32 := S32 (A) - S32 (B);
   begin
      if Res > S32 (Pitch_Range'Last) then
         return Param_Range'Last;
      elsif Res < S32 (Param_Range'First) then
         return Param_Range'First;
      else
         return Param_Range (Res);
      end if;
   end Sub_Sat;

   -------------
   -- Add_Sat --
   -------------

   function Add_Sat (A, B : Pitch_Range) return Pitch_Range is
      Res : constant S32 := S32 (A) + S32 (B);
   begin
      if Res > S32  (Pitch_Range'Last) then
         return Pitch_Range'Last;
      elsif Res < S32 (Pitch_Range'First) then
         return Pitch_Range'First;
      else
         return Pitch_Range (Res);
      end if;
   end Add_Sat;

   -------------
   -- Sub_Sat --
   -------------

   function Sub_Sat (A, B : Pitch_Range) return Pitch_Range is
      Res : constant S32 := S32 (A) - S32 (B);
   begin
      if Res > S32 (Pitch_Range'Last) then
         return Pitch_Range'Last;
      elsif Res < S32 (Pitch_Range'First) then
         return Pitch_Range'First;
      else
         return Pitch_Range (Res);
      end if;
   end Sub_Sat;

end Tresses;
