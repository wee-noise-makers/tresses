with Tresses.DSP;
with Tresses.Resources;

package body Tresses.LFO is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This.Phase := 0;
      This.Phase_Increment := 1;
      This.Rate := Param_Range'Last / 2;
      This.Amplitude := Param_Range'Last / 2;
   end Init;

   ----------
   -- Sync --
   ----------

   procedure Sync (This : in out Instance) is
   begin
      This.Phase := 0;
   end Sync;

   ---------------
   -- Set_Shape --
   ---------------

   procedure Set_Shape (This : in out Instance; S : Shape_Kind) is
   begin
      This.Shape := S;
   end Set_Shape;

   --------------
   -- Set_Rate --
   --------------

   procedure Set_Rate (This  : in out Instance;
                       R     : Param_Range;
                       Scale : U32 := 1)
   is

      Index : constant U16 := U16 (R) / 2**7;
      A : constant U32 := Resources.LUT_Lfo_Increments (Index);
      B : constant U32 := Resources.LUT_Lfo_Increments (Index + 1);

   begin
      This.Phase_Increment :=
        A + ((((B - A) / 2) * (U32 (R) and 16#7F#)) / 2**6);
      This.Phase_Increment := This.Phase_Increment * Scale;
   end Set_Rate;

   -------------------
   -- Set_Amplitude --
   -------------------

   procedure Set_Amplitude (This : in out Instance; A : Param_Range) is
   begin
      This.Amplitude := A;
   end Set_Amplitude;

   ------------
   -- Render --
   ------------

   function Render (This : in out Instance) return Param_Range is
      Sample : S32;
   begin
      This.Phase := This.Phase + This.Phase_Increment;

      Sample := S32 (DSP.Interpolate824 (Resources.WAV_Sine, This.Phase));
      Sample := (Sample + 32_512) / 2;
      Sample := (Sample * S32 (This.Amplitude)) / 2**15;
      return Param_Range (Sample);
   end Render;

end Tresses.LFO;
