package Tresses.FFT.Fixed
with Preelaborate
is

   type Block_Processing
     (Window_Size      : Positive;
      Half_Window_Size : Positive;
      Hop_Size         : Positive)
   is tagged
   private;

   type Frequency_Domain (Window_Size : Positive) is tagged private;

   type Magnitudes (Half_Window_Size : Positive) is tagged private
     with Constant_Indexing  => Mag;

   --  type Phases (Half_Window_Size : Positive) is tagged private
   --    with Constant_Indexing  => Phase;

   function Push_Frame (This    : in out Block_Processing;
                        Frame   :        S16)
                        return Boolean;
   --  Push an audio frame for analysis and return true if a new FFT can be
   --  computed. (The FFT can computed every Hop_Size frame).

   procedure Push_Frame (This    : in out Block_Processing;
                         Frame   :        S16);
   --  Push an audio frame for analysis

   procedure Process_FFT (This         : in out Block_Processing;
                          FD           :    out Frequency_Domain'Class;
                          Apply_Window :        Boolean := True)
     with Pre => FD.Window_Size = This.Window_Size;
   --  Compute the FFT and store results in the Frequency_Domain object

   function Rel (This : Frequency_Domain; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Window_Size / 2;
   --  Return the Real component of the FFT Bin

   function Img (This : Frequency_Domain; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Window_Size / 2;
   --  Return the Imaginary component of the FFT Bin

   procedure Bin_Magnitudes (FD   :     Frequency_Domain;
                             Mags : out Magnitudes'Class)
     with Pre => Mags.Half_Window_Size = FD.Window_Size / 2;
   --  Compute all the magnitudes of bins in the frequency domain

   function Mag (This : Magnitudes; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Half_Window_Size;
   --  Return the Magnitude of the FFT Bin

   function Max_Mag_Bin (This : Magnitudes) return Positive
     with Post => Max_Mag_Bin'Result in 1 .. This.Half_Window_Size;
   --  Return the index of the bin with highest magnitude

   --  procedure Bin_Phases (FD     :     Frequency_Domain;
   --                        Pha    : out Phases'Class)
   --    with Pre => Pha.Half_Window_Size = FD.Window_Size / 2;
   --  --  Compute all the phases of bins in the frequency domain
   --
   --  function Phase (This : Phases; Bin : Natural) return S16
   --    with Pre => Bin in 1 .. This.Half_Window_Size;
   --  --  Return the Phase of the FFT Bin

   function Bin_Center_Frequency (This : in out Block_Processing;
                                  Bin  : Natural)
                                  return Float
     with Pre => Bin in 1 .. This.Half_Window_Size;
   --  Return the center frequency of a given Bin (based on sample rate and
   --  window size).

private

   type Frequency_Domain (Window_Size : Positive)
   is tagged record
      Data : Mono_Buffer (1 .. Window_Size) := (others => 0);
   end record;

   type Magnitudes (Half_Window_Size : Positive)
   is tagged record
      Data : Mono_Buffer (1 .. Half_Window_Size) := (others => 0);
      Max_Bin : Natural := 1;
   end record;

   type Phases (Half_Window_Size : Positive)
   is tagged record
      Data : Mono_Buffer (1 .. Half_Window_Size) := (others => 0);
   end record;

   type Float_Array is array (Natural range <>) of Float;

   type Block_Processing
     (Window_Size      : Positive;
      Half_Window_Size : Positive;
      Hop_Size         : Positive)
   is tagged
           record
              Input_Circular : Mono_Buffer (1 .. Window_Size) :=
                (others => 0);

              Circular_Ptr : Positive := 1;
              Hop_Counter : Natural := 0;

              Center_Frequency : Float_Array (1 .. Half_Window_Size) :=
                (others => 0.0);
           end record;

end Tresses.FFT.Fixed;
