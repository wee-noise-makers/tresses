with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

with Tresses.DSP;

package body Tresses.Voices.Wave_Portamento is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Phase                  : in out U32;
      Start_Phase_Incr       : in out U32;
      Current_Phase_Incr     : in out U32;
      Target_Phase_Incr      : in out U32;
      Wave                   : Wave_Ref;
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

      Sample : S32;

      Diff : U32;
      Amount : Param_Range;
   begin
      if Do_Init then
         Do_Init := False;

         Init (Env, Do_Hold => True);
         Set_Attack (Env, 0);

         Init (Shape_Env, Do_Hold => False,
               Release_Curve => Envelopes.AR.Exponential,
               Release_Speed => Envelopes.AR.S_Half_Second);
         Set_Attack (Shape_Env, 0);

         Init (Filter);
         Set_Mode (Filter, Low_Pass);
         Set_Resonance (Filter, Param_Range'Last / 4);

         Target_Phase_Incr := 1;
         Current_Phase_Incr := 1;
         Start_Phase_Incr := 1;
      end if;

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);
      Set_Release (Shape_Env, Shape_Release);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            On (Shape_Env, Do_Strike.Velocity);

            Start_Phase_Incr := Current_Phase_Incr;

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Target_Phase_Incr := DSP.Compute_Phase_Increment (S16 (Pitch));

      Render (Shape_Env);

      if Target_Phase_Incr > Start_Phase_Incr then
         Diff := Target_Phase_Incr - Start_Phase_Incr;
         Amount := Param_Range'Last - Param_Range (LoFi (Shape_Env));
         Current_Phase_Incr := Start_Phase_Incr + DSP.Modulate (Diff, Amount);
      else
         Diff := Start_Phase_Incr - Target_Phase_Incr;
         Amount := Param_Range'Last - Param_Range (LoFi (Shape_Env));
         Current_Phase_Incr :=
           Start_Phase_Incr - DSP.Modulate (Diff, Amount);
      end if;

      for Index in Buffer'Range loop
         Phase := Phase + Current_Phase_Incr;
         Sample := S32 (DSP.Interpolate824 (Wave.all, Phase));

         --  Envolopes
         Render (Env);

         --  We render the glide envelope for every sample to not have it
         --  depend on the size of the buffer.
         Render (Shape_Env);

         --  Filter frequency control
         Filters.SVF.Set_Frequency
           (Filter,
            Param_Range'Last / 4 + Cutoff_Param / 4);

         Sample := Filters.SVF.Process (Filter, Sample);

         --  Sample := (Sample * Low_Pass (Env)) / 2**15;
         Sample := (Sample * S32 (LoFi (Env))) / 2**15;

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render;

end Tresses.Voices.Wave_Portamento;
