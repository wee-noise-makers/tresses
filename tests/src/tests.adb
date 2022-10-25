with Tresses.Drums.Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Cymbal;
with Tresses.Voices.Saw_Swarm;

with GNAT.OS_Lib;

with Interfaces; use Interfaces;

procedure Tests is
   K : Tresses.Drums.Kick.Instance;
   S : Tresses.Drums.Snare.Instance;
   C : Tresses.Drums.Cymbal.Instance;
   Swarm : Tresses.Voices.Saw_Swarm.Instance;

   MAX_PARAM : constant := 32767;

   P : constant := MAX_PARAM / 2;

   Buffer : Tresses.Mono_Buffer (1 .. 48_000 / 4);

   Ignore : Integer;

begin

   Tresses.Drums.Cymbal.Init (C);
   for X in Unsigned_16 range 0 .. 65 loop
      Tresses.Drums.Cymbal.Set_Cutoff (C, 65_000 - X * 1_000);
      Tresses.Drums.Cymbal.Set_Noise (C, X * 1_000);
      Tresses.Drums.Cymbal.Strike (C);
      Tresses.Drums.Cymbal.Render (C, Buffer);
      for Elt of Buffer loop

         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   for X in Unsigned_16 range 0 .. 65 loop
      Tresses.Voices.Saw_Swarm.Set_Detune (Swarm, X * 1_000);
      Tresses.Voices.Saw_Swarm.Set_High_Pass (Swarm, X * 1_000);
      Tresses.Voices.Saw_Swarm.Strike (Swarm);
      Tresses.Voices.Saw_Swarm.Render (Swarm, Buffer);
      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   Tresses.Drums.Snare.Init (S);
   for X in Unsigned_16 range 0 .. 65 loop
      Tresses.Drums.Snare.Set_Tone (S, 1_000);
      Tresses.Drums.Snare.Set_Noise (S, X * 1_000);
      Tresses.Drums.Snare.Strike (S);
      Tresses.Drums.Snare.Render (S, Buffer);

      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   Tresses.Drums.Kick.Init (K);
   for X in Unsigned_16 range 0 .. 65 loop
      Tresses.Drums.Kick.Set_Coefficient (K, P);
      Tresses.Drums.Kick.Set_Decay (K, X * 1000);
      Tresses.Drums.Kick.Strike (K);
      Tresses.Drums.Kick.Render (K, Buffer);

      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;
end Tests;
