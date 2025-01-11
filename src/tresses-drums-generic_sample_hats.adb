with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;
with Tresses.Filters.SVF; use Tresses.Filters.SVF;
with Tresses.Random; use Tresses.Random;
with Tresses.DSP;

package body Tresses.Drums.Generic_Sample_Hats is

   procedure Render
     (Buffer           :    out Mono_Buffer;
      Params           :        Param_Array;
      Filter           : in out Filters.SVF.Instance;
      Env              : in out Envelopes.AR.Instance;
      Rng              : in out Tresses.Random.Instance;
      Phase            : in out U32;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
   is
      Mix_Param    : Param_Range renames Params (P_Mix);
      Cutoff_Param : Param_Range renames Params (P_Cutoff);
      Rng_Param    : Param_Range renames Params (P_Randomness);
      Rel_Param    : Param_Range renames Params (P_Release);

      Sample : constant not null access constant S8_Array :=
        (if Mix_Param < Param_Range'Last / 2
         then Close_Sample
         else Open_Sample);

      Org, Point_S32 : S32;
      Idx : Natural := Buffer'First;
   begin
      if Do_Init then

         Do_Init := False;

         Phase := U32'Last;

         Init (Filter);
         Set_Mode (Filter, Low_Pass);

         Init (Env,
               Do_Hold => False,
               Release_Speed => S_1_Seconds);
         Set_Attack (Env, 0);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;

            Phase := Open_Sample'First +
              Get_Word (Rng) mod
              (1 + DSP.Mix (U32 (0),
                            Max_Random_Start_Point,
                            Rng_Param));

            On (Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;
            Off (Env);

         when None => null;
      end case;

      Set_Release (Env, Rel_Param);
      Set_Frequency (Filter, Param_Range'Last / 4 + Cutoff_Param / 4);
      Set_Resonance (Filter, Rng_Param);

      while Idx <= Buffer'Last loop
         if Phase in Sample'Range then
            Org := S32 (Sample (Phase)) * 2**8;
            Phase := Phase + 1;
         else
            Org := 0;
         end if;

         Point_S32 := Process (Filter, Org);
         Render (Env);
         Point_S32 := (Point_S32 * Low_Pass (Env)) / 2**15;
         Buffer (Idx) := S16 (Point_S32);
         Idx := Idx + 1;

         --  Point_S32 := Process (Filter, Org);
         --  Render (Env);
         --  Point_S32 := (Point_S32 * Low_Pass (Env)) / 2**15;
         --  Buffer (Idx + 1) := S16 (Point_S32);
         --  Idx := Idx + 2;
      end loop;
   end Render;

end Tresses.Drums.Generic_Sample_Hats;
