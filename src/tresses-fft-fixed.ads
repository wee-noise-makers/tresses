package Tresses.FFT.Fixed
with Preelaborate
is

   type Instance
     (Window_Size      : Positive;
      Half_Window_Size : Positive;
      Hop_Size         : Positive)
   is tagged
   private;

   function Push_Frame (This    : in out Instance;
                        Frame   :        S16)
                        return Boolean;
   --  Push an audio frame for analysis and return true if a new FFT was
   --  computed. (The FFT is computed every Hop_Size frame).

   procedure Push_Frame (This    : in out Instance;
                         Frame   :        S16);
   --  Push an audio frame for analysis

   function Rel (This : Instance; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Half_Window_Size;
   --  Return the Real component of the FFT Bin

   function Img (This : Instance; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Half_Window_Size;
   --  Return the Imaginary component of the FFT Bin

   function Amp (This : Instance; Bin : Natural) return S16
     with Pre => Bin in 1 .. This.Half_Window_Size;
   --  Return the Amplitude of the FFT Bin

   function Max_Amp_Bin (This : Instance) return Positive
     with Post => Max_Amp_Bin'Result in 1 .. This.Half_Window_Size;

   function Bin_Center_Frequency (This : in out Instance;
                                  Bin  : Natural)
                                  return Float
     with Pre => Bin in 1 .. This.Half_Window_Size;

   function Copy_Frequency_Domain (This : Instance) return Mono_Buffer;
   --  Return a copy of the frequency-domain bins

private

   type Hop_Data
     (Window_Size      : Positive;
      Half_Window_Size : Positive)
   is record
      Frequency_Domain : Mono_Buffer (1 .. Window_Size) :=
        (others => 0);
      Amplitude : Mono_Buffer (1 .. Half_Window_Size) :=
        (others => 0);
      --  Phase : Mono_Buffer (1 .. Half_Window_Size) :=
      --    (others => 0);
   end record;

   type Float_Array is array (Natural range <>) of Float;

   type Instance
     (Window_Size      : Positive;
      Half_Window_Size : Positive;
      Hop_Size         : Positive)
   is tagged
           record
              Input_Circular : Mono_Buffer (1 .. Window_Size) :=
                (others => 0);

              Circular_Ptr : Positive := 1;
              Hop_Counter : Natural := 0;

              Hop      : Hop_Data (Window_Size, Half_Window_Size);
              --  Prev_Hop : Hop_Data (Window_Size, Half_Window_Size);

              Center_Frequency : Float_Array (1 .. Half_Window_Size) :=
                (others => 0.0);

              Max_Bin : Natural := 1;
           end record;

end Tresses.FFT.Fixed;
