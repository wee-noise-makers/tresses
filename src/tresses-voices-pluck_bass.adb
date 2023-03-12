with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Pluck_Bass is

   ----------------
   -- Pluck_Bass --
   ----------------

   procedure Pluck_Bass
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Phase_Increment        : in out U32;
      Env, Shape_Env         : in out Envelopes.AR.Instance;
      Filter                 : in out Filters.SVF.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Shape_Release : Param_Range renames Params (P_Shape_Release);
      Cutoff_Param  : Param_Range renames Params (P_Cutoff);
      Attack        : Param_Range renames Params (P_Attack);
      Release       : Param_Range renames Params (P_Release);

      Phase_Incr_Delta : U32 := 0;

      Sample : S32;

      Cutoff : constant Param_Range := Cutoff_Param / 2;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env, Do_Hold => True);
         Set_Attack (Env, U7 (0));

         Init (Shape_Env, Do_Hold => False);
         Set_Attack (Shape_Env, U7 (0));

         Init (Filter);
         Set_Mode (Filter, Low_Pass);
         Set_Resonance (Filter, Param_Range'Last / 4);

         Phase := 0;
         Phase_Increment := 0;

      end if;

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);
      Set_Release (Shape_Env, Param_Range'Last / 2 + Shape_Release / 2);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (Shape_Env, Do_Strike.Velocity);

            Phase_Increment :=
              DSP.Compute_Phase_Increment (S16 (Pitch));

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      for Index in Buffer'Range loop

         Phase := Phase + Phase_Increment;

         --  Envolopes
         Render (Env);
         Render (Shape_Env);

         Sample := S32 (DSP.Crossfade (Resources.WAV_Sine,
                                       Resources.WAV_Sine2_Warp3,
                                       Phase,
                                       N16 (Value (Shape_Env))));

         --  Filter frequency control
         Filters.SVF.Set_Frequency
           (Filter,
            Cutoff + Param_Range (Value (Shape_Env)) / 4);

         Sample := Filters.SVF.Process (Filter, Sample);

         Sample := (Sample * Low_Pass (Env)) / 2**15;

         Buffer (Index) := S16 (Sample);
      end loop;

   end Pluck_Bass;

end Tresses.Voices.Pluck_Bass;
