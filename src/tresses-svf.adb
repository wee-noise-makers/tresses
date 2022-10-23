with Tresses.DSP;
with Tresses.Lookup_Tables;

package body Tresses.SVF is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.LP := 0;
      This.BP := 0;
      This.Frequency := 33 * 2**7;
      This.Resonance := 16_384;
      This.Dirty := True;
      This.Punch := 0;
      This.Mode := Band_Pass;
   end Init;

   -------------------
   -- Set_Frequency --
   -------------------

   procedure Set_Frequency (This : in out Instance; Frequency : S16) is
   begin
      This.Dirty := This.Dirty or else (This.Frequency /= Frequency);
      This.Frequency := Frequency;
   end Set_Frequency;

   -------------------
   -- Set_Resonance --
   -------------------

   procedure Set_Resonance (This : in out Instance; Resonance : S16) is
   begin
      This.Resonance := Resonance;
      This.Dirty := True;
   end Set_Resonance;

   ---------------
   -- Set_Punch --
   ---------------

   procedure Set_Punch (This : in out Instance; Punch : U16) is
   begin
      This.Punch := S32 (Shift_Right (U32 (Punch)**2, 24));
   end Set_Punch;

   --------------
   -- Set_Mode --
   --------------

   procedure Set_Mode (This : in out Instance; Mode : Mode_Kind) is
   begin
      This.Mode := Mode;
   end Set_Mode;

   -------------
   -- Process --
   -------------

   function Process (This : in out Instance; Input : S32) return S32 is
      F, Damp : S32;
   begin
      if This.Dirty then
         This.F := S32 (DSP.Interpolate824 (Lookup_Tables.SVF_Cutoff,
                        Shift_Left (U32 (This.Frequency), 17)));

         This.Damp := S32 (DSP.Interpolate824 (Lookup_Tables.SVF_Damp,
                           Shift_Left (U32 (This.Resonance), 17)));
         This.Dirty := False;
      end if;

      F := This.F;
      Damp := This.Damp;

      if This.Punch /= 0 then
         declare
            Punch_Signal : constant S32 := (if This.LP > 4096
                                            then This.LP
                                            else 2048);
         begin
            F := F + (((Punch_Signal / 2**4) * This.Punch) / 2**9);
            Damp := Damp + ((Punch_Signal - 2048) / 2**3);
         end;
      end if;

      declare
         Notch : constant S32 := Input - ((This.BP * Damp) / 2**15);
      begin
         This.LP := This.LP + ((F * This.BP) / 2**15);

         DSP.Clip_S16 (This.LP);

         declare
            HP : constant S32 := Notch - This.LP;
         begin
            This.BP := This.BP + ((F * HP) / 2**15);
            DSP.Clip_S16 (This.BP);

            case This.Mode is
            when Band_Pass =>
               return This.BP;
            when Low_Pass =>
               return This.LP;
            when High_Pass =>
               return HP;
            end case;
         end;
      end;
   end Process;

end Tresses.SVF;
