with Tresses;    use Tresses;
with Tresses.Macro;

with GNAT.OS_Lib;
procedure Tests is

   Macro : Tresses.Macro.Instance;

   Buffer : Tresses.Mono_Buffer (1 .. 44_100 / 4);
   Aux_Buffer : Tresses.Mono_Buffer (Buffer'Range);

   Ignore : Integer;

   Pitch_Vals : constant array (Natural range <>) of Pitch_Range :=
     (Pitch_Range'First, Pitch_Range'Last / 2, Pitch_Range'Last);

   Param_Vals : constant array (Natural range <>) of Param_Range :=
     (Param_Range'First, Param_Range'Last);

begin

   --  Run every engine with all combinations of limit settings

   for Engine in Tresses.Engines loop
      Macro.Set_Engine (Engine);

      for Pitch of Pitch_Vals loop
         Macro.Set_Pitch (Pitch);

         for Param_1 of Param_Vals loop
            Macro.Set_Param (1, Param_1);

            for Param_2 of Param_Vals loop
               Macro.Set_Param (2, Param_2);

               for Param_3 of Param_Vals loop
                  Macro.Set_Param (3, Param_3);

                  for Param_4 of Param_Vals loop
                     Macro.Set_Param (4, Param_4);

                     Macro.Strike;

                     Macro.Render (Buffer, Aux_Buffer);

                     for Elt of Buffer loop
                        Ignore := GNAT.OS_Lib.Write
                          (GNAT.OS_Lib.Standout,
                           Elt'Address,
                           Elt'Size / 8);
                     end loop;
                  end loop;
               end loop;
            end loop;
         end loop;
      end loop;
   end loop;

end Tests;
