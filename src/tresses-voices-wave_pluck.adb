with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.DSP;

package body Tresses.Voices.Wave_Pluck is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer          :    out Mono_Buffer;
      Params          :        Param_Array;
      Wave            :        Wave_Ref;
      Phase           : in out U32;
      Phase_Increment : in out U32;
      Env             : in out Envelopes.AR.Instance;
      Filter          : in out Filters.SVF.Instance;
      Pitch           :        Pitch_Range;
      Do_Init         : in out Boolean;
      Do_Strike       : in out Strike_State)
   is
      Fold         : Param_Range renames Params (P_Fold);
      Cutoff_Param : Param_Range renames Params (P_Cutoff);
      Reso         : Param_Range renames Params (P_Reso);
      Release      : Param_Range renames Params (P_Release);

      Sample : S32;
      Env_V : S32;
      Folded : S16;
      Cutoff : constant Param_Range := Cutoff_Param / 2;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env, Do_Hold => False);
         Set_Attack (Env, Param_Range'Last / 100);

         Phase := 0;
         Init (Filter);
         Set_Mode (Filter, Low_Pass);
      end if;

      Set_Release (Env, Release);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);

            Phase_Increment := DSP.Compute_Phase_Increment (S16 (Pitch));

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Resonance (Filter, Reso);

      for Index in Buffer'Range loop
         Phase := Phase + Phase_Increment;

         Sample := S32 (DSP.Interpolate824 (Wave.all, Phase));
         Folded := DSP.Interpolate88 (Resources.WS_Sine_Fold,
                                      U16 (Sample + 32_768));
         --  Mix clean and folded signals
         Sample := S32 (DSP.Mix (S16 (Sample), Folded, Fold));

         --  Envolopes
         Render (Env);

         --  Render (Shape_Env);
         Env_V := Low_Pass (Env);

         --  Filter frequency control
         Filters.SVF.Set_Frequency
           (Filter,
            Cutoff + Param_Range (Env_V) / 4);

         Sample := Filters.SVF.Process (Filter, Sample);

         Sample := (Sample * Env_V) / 2**15;

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render;

end Tresses.Voices.Wave_Pluck;
