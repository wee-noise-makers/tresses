
with Interfaces;

pragma Warnings (Off, "has no effect");
use Interfaces;
pragma Warnings (On, "has no effect");

with MIDI;
with Tresses_Config;

package Tresses
with Preelaborate
is

   subtype U8 is Interfaces.Unsigned_8;
   subtype U16 is Interfaces.Unsigned_16;
   type U32 is new Interfaces.Unsigned_32;
   subtype U64 is Interfaces.Unsigned_64;

   type U7 is mod 2**7 with Size => 7;

   subtype S8 is Interfaces.Integer_8;
   subtype S16 is Interfaces.Integer_16;
   type S32 is new Interfaces.Integer_32;
   subtype S64 is Interfaces.Integer_64;

   type S8_Array is array (U32 range <>) of S8;

   type N16 is new S16 range 0 .. S16'Last;
   --  Natural on 16 bit

   type Param_Range is new N16;

   function Add_Sat (A, B : Param_Range) return Param_Range;
   function Sub_Sat (A, B : Param_Range) return Param_Range;

   type Param_Id is range 1 .. 4;
   type Param_Array is array (Param_Id) of Param_Range;

   type Pitch_Range is new S16 range 0 .. 127 * 128;

   function Add_Sat (A, B : Pitch_Range) return Pitch_Range;
   function Sub_Sat (A, B : Pitch_Range) return Pitch_Range;

   Semitone   : constant Pitch_Range := 128;
   Octave     : constant Pitch_Range := 12 * Semitone;
   Init_Pitch : constant Pitch_Range := 60 * Semitone;

   function MIDI_Pitch (Key : MIDI.MIDI_Key) return Pitch_Range
   is (Pitch_Range (Key) * 128);
   --  Convert a MIDI note to Tresses Pitch

   function MIDI_Param (Val : MIDI.MIDI_Data) return Param_Range
   is (Param_Range (Val) *
       (Param_Range'Last / Param_Range (MIDI.MIDI_Data'Last)));
   --  Convert a MIDI Data to Tresses Param_Range

   subtype Mono_Point is S16;
   type Mono_Buffer is array (Natural range <>) of Mono_Point;

   type Engines is (Drum_Kick,
                    Drum_Sine_Kick,
                    Drum_Triangle_Kick,
                    Drum_Chip_Kick,
                    Drum_Sine_Noise_Kick,
                    Drum_Snare,
                    Drum_Sine_Snare,
                    Drum_Saw_Snare,
                    Drum_Triangle_Snare,
                    Drum_Clap,
                    Drum_Cymbal,
                    Drum_Percussion,
                    Drum_Bell,
                    Drum_909_Hats,
                    Drum_707_Hats,

                    Voice_Plucked,
                    Voice_Saw_Swarm,
                    Voice_Acid,
                    Voice_FM2OP,
                    Voice_Analog_Buzz,
                    Voice_Analog_Morph,
                    Voice_Sand,
                    Voice_Bass_808,
                    Voice_House_Bass,
                    Voice_Pluck_Bass,
                    Voice_Reese,
                    Voice_Screech,
                    Voice_PDR_Sine,
                    Voice_PDR_Triangle,
                    Voice_PDR_Sine_Square,
                    Voice_PDR_Square_Sine,
                    Voice_PDR_Square_Full_Sine,
                    Voice_PDL_Trig_Warp,
                    Voice_PDL_Triangle_Screech,
                    Voice_Chip_Glide,
                    Voice_Chip_Echo_Square,
                    Voice_Chip_Echo_Square_Saw,
                    Voice_Chip_Phaser,
                    Voice_Chip_Bass,
                    Voice_Sine_Phaser,
                    Voice_Triangle_Phaser,
                    Voice_Sine_Pluck,
                    Voice_Triangle_Pluck,
                    Voice_Chip_Pluck);

   subtype Drum_Engines is Engines range Drum_Kick .. Drum_Bell;
   subtype Synth_Engines is Engines range Voice_Plucked .. Engines'Last;

   function Img (E : Engines) return String
   is (case E is
          when Drum_Kick                  => "Kick",
          when Drum_Sine_Kick             => "Sine Kick",
          when Drum_Triangle_Kick         => "Triangle Kick",
          when Drum_Chip_Kick             => "Chip Kick",
          when Drum_Sine_Noise_Kick       => "Sine Noise Kick",
          when Drum_Snare                 => "Analog Snare",
          when Drum_Sine_Snare            => "Sine Snare",
          when Drum_Saw_Snare             => "Saw Snare",
          when Drum_Triangle_Snare        => "Triangle Snare",
          when Drum_Clap                  => "Clap",
          when Drum_Cymbal                => "Cymbal",
          when Drum_Percussion            => "Percussion",
          when Drum_Bell                  => "Bell",
          when Drum_909_Hats              => "909 HiHat",
          when Drum_707_Hats              => "707 HiHat",
          when Voice_Plucked              => "Plucked",
          when Voice_Saw_Swarm            => "Saw Swarm",
          when Voice_Acid                 => "Acid",
          when Voice_Analog_Buzz          => "Buzz",
          when Voice_Analog_Morph         => "Morph",
          when Voice_FM2OP                => "FM 2 OP",
          when Voice_Sand                 => "Sand",
          when Voice_Bass_808             => "808 Bass",
          when Voice_House_Bass           => "House Bass",
          when Voice_Pluck_Bass           => "Pluck Bass",
          when Voice_Reese                => "Reese",
          when Voice_Screech              => "Screech",
          when Voice_PDR_Sine             => "PDR Sine",
          when Voice_PDR_Triangle         => "PDR Triangle",
          when Voice_PDR_Sine_Square      => "PDR Sine Square",
          when Voice_PDR_Square_Sine      => "PDR Square Sine",
          when Voice_PDR_Square_Full_Sine => "PDR Square Full Sine",
          when Voice_PDL_Trig_Warp        => "PDL Trig Warp",
          when Voice_PDL_Triangle_Screech => "PDL Triangle Screech",
          when Voice_Chip_Glide           => "Chip Glide",
          when Voice_Chip_Echo_Square     => "Chip Echo Square",
          when Voice_Chip_Echo_Square_Saw => "Chip Echo Square + Saw",
          when Voice_Chip_Phaser          => "Chip Phaser",
          when Voice_Chip_Bass            => "Chip Bass",
          when Voice_Sine_Phaser          => "Sine Phaser",
          when Voice_Triangle_Phaser      => "Triangle Phaser",
          when Voice_Sine_Pluck           => "Sine Pluck",
          when Voice_Triangle_Pluck       => "Triangle Pluck",
          when Voice_Chip_Pluck           => "Chip Pluck");

   subtype Short_Label is String (1 .. 3);

   type Strike_Event_Kind is (None, On, Off);
   type Strike_State is record
      Event    : Strike_Event_Kind := None;
      Velocity : Param_Range := Param_Range'Last;
   end record;

   Code_Linker_Section : constant String :=
     Tresses_Config.Code_Linker_Section;

end Tresses;
