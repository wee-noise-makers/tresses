with Ada.Text_IO;
with Ada.Command_Line;

with Tresses;    use Tresses;
with Tresses.Macro;

with GNAT.OS_Lib; use GNAT.OS_Lib;
procedure Tests is

   Macro : Tresses.Macro.Instance;

   Buffer : Tresses.Mono_Buffer (1 .. 44_100 / 4);
   Aux_Buffer : Tresses.Mono_Buffer (Buffer'Range);

   Ignore : Integer;

   Pitch_Vals : constant array (Natural range <>) of Pitch_Range :=
     (Pitch_Range'First, Pitch_Range'Last / 2, Pitch_Range'Last);

   Param_Vals : constant array (Natural range <>) of Param_Range :=
     (Param_Range'First, Param_Range'Last);

   Out_FD : File_Descriptor := Invalid_FD;
begin

   case Ada.Command_Line.Argument_Count is
      when 0 =>
         Ada.Text_IO.Put_Line ("No audio output for this run.");
         Ada.Text_IO.Put_Line
           ("Use `./bin/tests -- | aplay -f S16_LE -c1 -r44100` " &
              "to listen to the generated sound");
      when 1 =>
         declare
            Filename : constant String :=
              Ada.Command_Line.Argument (1);
         begin
            if Filename = "--" then
               Out_FD := Standout;
            else

               Out_FD := Open_Read_Write (Filename, Binary);
               if Out_FD = Invalid_FD then
                  Ada.Text_IO.Put_Line
                    ("Cannot open output file '" &  Filename & "': " &
                       Errno_Message);
                  OS_Exit (1);
               end if;
            end if;
         end;
      when others =>
         Ada.Text_IO.Put_Line
           ("Invalid number of argument. " &
              "Just specify a filename or '--' for stdout");
         OS_Exit (1);
   end case;

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
                     for Velocity of Param_Vals loop

                        Macro.Note_On (Velocity);

                        Macro.Render (Buffer, Aux_Buffer);

                        if Out_FD /= Invalid_FD then
                           for Elt of Buffer loop
                              Ignore := GNAT.OS_Lib.Write
                                (Out_FD,
                                 Elt'Address,
                                 Elt'Size / 8);
                           end loop;
                        end if;
                     end loop;
                  end loop;
               end loop;
            end loop;
         end loop;
      end loop;
   end loop;
end Tests;
