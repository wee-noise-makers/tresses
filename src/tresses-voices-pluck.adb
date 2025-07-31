with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;

with Tresses.DSP;
with Tresses.Resources;

package body Tresses.Voices.Pluck is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Wave                   :        Analog_Oscillator.Shape_Kind;
      Osc                    : in out Analog_Oscillator.Instance;
      Env, Shape_Env         : in out Envelopes.AR.Instance;
      Filter                 : in out Filters.SVF.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Shape        : Param_Range renames Params (P_Shape);
      Cutoff_Param : Param_Range renames Params (P_Cutoff);
      Reso         : Param_Range renames Params (P_Reso);
      Release      : Param_Range renames Params (P_Release);

      Sample : S32;
      Env_V : S32;
      Cutoff : constant Param_Range := Cutoff_Param / 2;
   begin
      if Do_Init then
         Do_Init := False;

         Analog_Oscillator.Init (Osc);
         Analog_Oscillator.Set_Shape (Osc, Wave);

         Init (Env, Do_Hold => False);
         Set_Attack (Env, Param_Range'Last / 100);

         Init (Filter);
         Set_Mode (Filter, Low_Pass);
      end if;

      Set_Release (Env, Release);

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Analog_Oscillator.Set_Pitch (Osc, Pitch);
      Analog_Oscillator.Set_Param (Osc, 0, Shape);
      Analog_Oscillator.Render (Osc, Buffer);

      Set_Resonance (Filter, Reso);
      for Index in Buffer'Range loop

         --  Envolopes
         Render (Env);
         --  Render (Shape_Env);
         Env_V := Low_Pass (Env);

         --  Filter frequency control
         Filters.SVF.Set_Frequency
           (Filter,
            Cutoff + Param_Range (Env_V) / 4);

         Sample := Filters.SVF.Process (Filter, S32 (Buffer (Index)));

         Sample := (Sample * Env_V) / 2**15;

         Buffer (Index) := S16 (Sample);
      end loop;

   end Render;

end Tresses.Voices.Pluck;
