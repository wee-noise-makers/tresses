
package body Tresses.Excitation is

   ----------
   -- Init --
   ----------

   procedure Init (This : in out Instance) is
   begin
      This := (others => <>);
   end Init;

   ---------------
   -- Set_Delay --
   ---------------

   procedure Set_Delay (This : in out Instance; Delayy : U16) is
   begin
      This.Delayy := U32 (Delayy);
   end Set_Delay;

   ---------------
   -- Set_Decay --
   ---------------

   procedure Set_Decay (This : in out Instance; Decay : U16) is
   begin
      This.Decay := U32 (Decay);
   end Set_Decay;

   -------------
   -- Trigger --
   -------------

   procedure Trigger (This : in out Instance; Level : S32) is
   begin
      This.Level := Level;
      This.Counter := S32 (This.Delayy + 1);
   end Trigger;

   ----------
   -- Done --
   ----------

   function Done (This : Instance) return Boolean
   is (This.Counter = 0);

   -------------
   -- Process --
   -------------

   function Process (This : in out Instance) return S32 is
   begin
      This.State := (This.State * S32 (This.Decay)) / 2**12;

      if This.Counter > 0 then
         This.Counter := This.Counter - 1;
         if This.Counter = 0 then
            This.State := This.State + (abs This.Level);
         end if;
      end if;

      return (if This.Level < 0
              then -This.State
              else This.State);
   end Process;

end Tresses.Excitation;
