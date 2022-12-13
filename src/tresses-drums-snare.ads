with Tresses.Excitation;
with Tresses.Filters.SVF;
with Tresses.Random;

with Tresses.Interfaces; use Tresses.Interfaces;

package Tresses.Drums.Snare
with Preelaborate
is

   procedure Render_Snare
     (Buffer                         :    out Mono_Buffer;
      Params                         :        Param_Array;
      Pulse0, Pulse1, Pulse2, Pulse3 : in out Excitation.Instance;
      Filter0, Filter1, Filter2      : in out Filters.SVF.Instance;
      Rng                            : in out Random.Instance;
      Pitch                          :        Pitch_Range;
      Do_Init                        : in out Boolean;
      Do_Strike                      : in out Boolean);

   P_Tone  : constant Param_Id := 1;
   P_Noise : constant Param_Id := 2;

   function Param_Label (Id : Param_Id) return String
   is (case Id is
          when P_Tone  => "Tone",
          when P_Noise => "Noise",
          when others  => "N/A");

   -- Interfaces --

   type Instance
   is new Four_Params_Voice
   with private;

   overriding
   function Param_Label (This : Instance; Id : Param_Id)
                         return String
   is (Param_Label (Id));

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

private

   type Instance
   is new Four_Params_Voice
   with record
      Pulse0, Pulse1, Pulse2, Pulse3 : Excitation.Instance;
      Filter0, Filter1, Filter2      : Filters.SVF.Instance;
      Rng                            : Random.Instance;
      Do_Init                        : Boolean := True;
   end record;

end Tresses.Drums.Snare;
