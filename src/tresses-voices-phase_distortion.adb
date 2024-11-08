with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

package body Tresses.Voices.Phase_Distortion is

   ------------
   -- Render --
   ------------

   procedure Render
     (Buffer                 :    out Mono_Buffer;
      Params                 :        Param_Array;
      Osc                    : in out Phase_Distortion_Oscillator.Instance;
      Env                    : in out Envelopes.AR.Instance;
      Pitch                  :        Pitch_Range;
      Do_Init                : in out Boolean;
      Do_Strike              : in out Strike_State)
   is
      Amount        : Param_Range renames Params (P_Distort);
      Shape_Release : Param_Range renames Params (P_Shape_Release);
      Attack        : Param_Range renames Params (P_Attack);
      Release       : Param_Range renames Params (P_Release);
   begin
      if Do_Init then
         Do_Init := False;

         PDO.Init (Osc, Envelopes.AR.Linear, Envelopes.AR.S_2_Seconds);

         Init (Env, Do_Hold => True);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            On (Env, Do_Strike.Velocity);
            PDO.Trigger (Osc, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;

            Off (Env);

         when None => null;
      end case;

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);

      PDO.Set_Pitch (Osc, Pitch);

      Render_Osc (Osc, Buffer, Amount, Shape_Release);

      for Sample of Buffer loop
         Render (Env);
         Sample := S16 ((S32 (Sample) * Low_Pass (Env)) / 2**15);
      end loop;
   end Render;

end Tresses.Voices.Phase_Distortion;
