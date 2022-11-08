with Tresses;    use Tresses;
with Tresses.Macro;

with Tresses.Analog_Oscillator;

with MIDI;

with GNAT.OS_Lib;
procedure Tests is

   Macro : Tresses.Macro.Instance;

   Buffer : Tresses.Mono_Buffer (1 .. 44_100 / 4);

   Ignore : Integer;

   Pitch_Vals : constant array (Natural range <>) of Pitch_Range :=
     (Pitch_Range'First, Pitch_Range'Last);

   Param_Vals : constant array (Natural range <>) of Param_Range :=
     (Param_Range'First, Param_Range'Last);

   Env_Vals : constant array (Natural range <>) of U7 :=
     (U7'First, U7'Last);

   A : Tresses.Analog_Oscillator.Instance;

   Some_Pitch_Vals : constant array (Natural range <>) of Pitch_Range :=
     (MIDI_Pitch (MIDI.C4),
      MIDI_Pitch (MIDI.E4),
      MIDI_Pitch (MIDI.C5));

begin

   A.Set_Shape (Tresses.Analog_Oscillator.Sine_Fold);
   for Pitch of Some_Pitch_Vals loop
      A.Set_Pitch (Pitch);
      for X in Param_Range range 0 .. 32 loop
         A.Set_Param1 (X * 1_000);
         A.Set_Param2 (X * 1_000);
         A.Render (Buffer);

         for Elt of Buffer loop
            Ignore := GNAT.OS_Lib.Write
              (GNAT.OS_Lib.Standout,
               Elt'Address,
               Elt'Size / 8);
         end loop;
      end loop;
   end loop;

   --  Run every engine with all combinations of limit settings

   for Engine in Tresses.Engines loop
      Macro.Set_Engine (Engine);

      for Pitch of Pitch_Vals loop
         Macro.Set_Pitch (Pitch);

         for Param_1 of Param_Vals loop
            Macro.Set_Param1 (Param_1);

            for Param_2 of Param_Vals loop
               Macro.Set_Param2 (Param_2);

               for Attack of Env_Vals loop
                  Macro.Set_Attack (Attack);

                  for Decay of Env_Vals loop
                     Macro.Set_Decay (Decay);

                     Macro.Strike;

                     Macro.Render (Buffer);

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
