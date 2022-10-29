with Tresses;    use Tresses;
with Tresses.Drums.Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Cymbal;
with Tresses.Drums.Macro;
with Tresses.Voices.Saw_Swarm;
with Tresses.Voices.Plucked;
with Tresses.Voices.Macro;

with GNAT.OS_Lib;

procedure Tests is

   K : Tresses.Drums.Kick.Instance;
   S : Tresses.Drums.Snare.Instance;
   C : Tresses.Drums.Cymbal.Instance;
   DM : Tresses.Drums.Macro.Instance;

   Swarm : Tresses.Voices.Saw_Swarm.Instance;
   Pluck : Tresses.Voices.Plucked.Instance;
   VM    : Tresses.Voices.Macro.Instance;

   Buffer : Tresses.Mono_Buffer (1 .. 44_100 / 2);

   Ignore : Integer;

begin

   for X in Tresses.Param_Range range 0 .. 32 loop
      Tresses.Voices.Plucked.Set_Decay (Pluck, X * 1_000);
      Tresses.Voices.Plucked.Set_Position (Pluck, X * 1_000);
      Tresses.Voices.Plucked.Strike (Pluck);
      Tresses.Voices.Plucked.Render (Pluck, Buffer);
      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   for X in Tresses.Param_Range range 0 .. 32 loop
      DM.Set_Param1 (X * 1_000);
      DM.Set_Param2 (X * 1_000);
      DM.Strike;
      DM.Render (Buffer);
      DM.Next_Engine;
      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   for X in Tresses.Param_Range range 0 .. 32 loop
      VM.Set_Param1 (X * 1_000);
      VM.Set_Param2 (X * 1_000);
      VM.Strike;
      VM.Render (Buffer);
      VM.Next_Engine;
      for Elt of Buffer loop
         Ignore := GNAT.OS_Lib.Write
           (GNAT.OS_Lib.Standout,
            Elt'Address,
            Elt'Size / 8);
      end loop;
   end loop;

   Tresses.Drums.Cymbal.Init (C);
   for X in Tresses.Param_Range range 0 .. 32 loop
      Tresses.Drums.Cymbal.Set_Cutoff (C, 32_000 - X * 1_000);
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

   for X in Tresses.Param_Range range 0 .. 32 loop
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
   for X in Tresses.Param_Range range 0 .. 32 loop
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
   for X in Tresses.Param_Range range 0 .. 32 loop
      Tresses.Drums.Kick.Set_Coefficient (K, X * 1_000);
      Tresses.Drums.Kick.Set_Decay (K, X * 1_000);
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
