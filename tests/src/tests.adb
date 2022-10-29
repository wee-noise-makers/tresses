with Tresses;    use Tresses;
with Tresses.Macro;
with MIDI;

with GNAT.OS_Lib;

procedure Tests is

   Macro : Tresses.Macro.Instance;

   Buffer : Tresses.Mono_Buffer (1 .. 44_100 / 4);

   Ignore : Integer;

begin
   for Engine in Tresses.Engines loop
      Macro.Set_Engine (Engine);

      case Macro.Engine is
         when Tresses.Drum_Kick =>
            Macro.Set_Pitch (Tresses.MIDI_Pitch (MIDI.C2));
         when others =>
            Macro.Set_Pitch (Tresses.MIDI_Pitch (MIDI.C4));
      end case;

      for X in Tresses.Param_Range range 0 .. 32 loop
         Macro.Set_Param1 (X * 1_000);
         Macro.Set_Param2 (X * 1_000);
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
end Tests;
