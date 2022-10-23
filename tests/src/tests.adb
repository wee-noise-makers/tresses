with Tresses.Drums.Kick;
with Tresses.Drums.Snare;
with Tresses.Drums.Cymbal;
with Tresses.Envelopes.AD;
with GNAT.OS_Lib;

with Interfaces; use Interfaces;

with Tresses; use Tresses;

procedure Tests is
   K : Tresses.Drums.Kick.Instance;
   S : Tresses.Drums.Snare.Instance;
   C : Tresses.Drums.Cymbal.Instance;

   Env : Tresses.Envelopes.AD.Instance;

   MAX_PARAM : constant := 32767;

   P : constant := MAX_PARAM / 2;

   Buffer : Tresses.Mono_Buffer (1 .. 48_000 / 2);

   Ignore : Integer;

begin

   Tresses.Drums.Cymbal.Init (C);
   for X in Unsigned_16 range 0 .. 32 loop

      Tresses.Drums.Cymbal.Set_Cutoff (C, 1_000);
      Tresses.Drums.Cymbal.Set_Noise (C, X * 1_000);
      Tresses.Drums.Cymbal.Strike (C);
      Tresses.Drums.Cymbal.Render (C, Buffer);
      Tresses.Envelopes.AD.Set_Attack (Env, 0);
      Tresses.Envelopes.AD.Set_Decay (Env, 50);

      Tresses.Envelopes.AD.Trigger (Env, Tresses.Envelopes.AD.Attack);

      for Elt of Buffer loop

         declare
            Gain : constant S32 := S32 (Tresses.Envelopes.AD.Render (Env));
         begin

            Elt := S16 ((S32 (Elt) * Gain) / 2**15);
            Ignore := GNAT.OS_Lib.Write
              (GNAT.OS_Lib.Standout,
               Elt'Address,
               Elt'Size / 8);
         end;
      end loop;
   end loop;

   Tresses.Drums.Snare.Init (S);
   for X in Unsigned_16 range 0 .. 32 loop
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
   for X in Unsigned_16 range 0 .. 32 loop
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
