with Tresses; use Tresses;
with Tresses.Random;
with Tresses.FFT.Fixed;
with Tresses.Analog_Oscillator; use Tresses.Analog_Oscillator;
with MIDI;

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

with AAA.Table_IO;

with Interfaces; use Interfaces;
with Ada.Unchecked_Conversion;

procedure FFT is
   --  package FIO is new Ada.Text_IO.Float_IO (Float);

   Verbose : constant Boolean := False;

   Data : constant array (0 .. 255) of Interfaces.Unsigned_16 :=
     (16#0000#,
      16#2c70#,
      16#532b#,
      16#6f69#,
      16#7e1a#,
      16#7e5b#,
      16#7185#,
      16#5ae3#,
      16#3f06#,
      16#22ef#,
      16#0b25#,
      16#faf6#,
      16#f3ed#,
      16#f5ad#,
      16#fe27#,
      16#0a1c#,
      16#15e0#,
      16#1e1a#,
      16#2079#,
      16#1c25#,
      16#11de#,
      16#03c7#,
      16#f4e0#,
      16#e85b#,
      16#e0dd#,
      16#dfe4#,
      16#e565#,
      16#efc2#,
      16#fc14#,
      16#06be#,
      16#0c34#,
      16#09b9#,
      16#fe0a#,
      16#e9be#,
      16#cf4c#,
      16#b2b4#,
      16#98d6#,
      16#8698#,
      16#8000#,
      16#8771#,
      16#9d2a#,
      16#bf27#,
      16#e969#,
      16#1697#,
      16#40d9#,
      16#62d6#,
      16#788f#,
      16#7fff#,
      16#7968#,
      16#672a#,
      16#4d4c#,
      16#30b4#,
      16#1642#,
      16#01f6#,
      16#f647#,
      16#f3cc#,
      16#f942#,
      16#03ec#,
      16#103e#,
      16#1a9b#,
      16#201c#,
      16#1f23#,
      16#17a5#,
      16#0b20#,
      16#fc39#,
      16#ee22#,
      16#e3db#,
      16#df87#,
      16#e1e6#,
      16#ea20#,
      16#f5e4#,
      16#01d9#,
      16#0a53#,
      16#0c13#,
      16#050a#,
      16#f4db#,
      16#dd11#,
      16#c0fa#,
      16#a51d#,
      16#8e7b#,
      16#81a5#,
      16#81e6#,
      16#9097#,
      16#acd5#,
      16#d390#,
      16#0000#,
      16#2c70#,
      16#532b#,
      16#6f69#,
      16#7e1a#,
      16#7e5b#,
      16#7185#,
      16#5ae3#,
      16#3f06#,
      16#22ef#,
      16#0b25#,
      16#faf6#,
      16#f3ed#,
      16#f5ad#,
      16#fe27#,
      16#0a1c#,
      16#15e0#,
      16#1e1a#,
      16#2079#,
      16#1c25#,
      16#11de#,
      16#03c7#,
      16#f4e0#,
      16#e85b#,
      16#e0dd#,
      16#dfe4#,
      16#e565#,
      16#efc2#,
      16#fc14#,
      16#06be#,
      16#0c34#,
      16#09b9#,
      16#fe0a#,
      16#e9be#,
      16#cf4c#,
      16#b2b4#,
      16#98d6#,
      16#8698#,
      16#8000#,
      16#8771#,
      16#9d2a#,
      16#bf27#,
      16#e969#,
      16#1697#,
      16#40d9#,
      16#62d6#,
      16#788f#,
      16#7fff#,
      16#7968#,
      16#672a#,
      16#4d4c#,
      16#30b4#,
      16#1642#,
      16#01f6#,
      16#f647#,
      16#f3cc#,
      16#f942#,
      16#03ec#,
      16#103e#,
      16#1a9b#,
      16#201c#,
      16#1f23#,
      16#17a5#,
      16#0b20#,
      16#fc39#,
      16#ee22#,
      16#e3db#,
      16#df87#,
      16#e1e6#,
      16#ea20#,
      16#f5e4#,
      16#01d9#,
      16#0a53#,
      16#0c13#,
      16#050a#,
      16#f4db#,
      16#dd11#,
      16#c0fa#,
      16#a51d#,
      16#8e7b#,
      16#81a5#,
      16#81e6#,
      16#9097#,
      16#acd5#,
      16#d390#,
      16#0000#,
      16#2c70#,
      16#532b#,
      16#6f69#,
      16#7e1a#,
      16#7e5b#,
      16#7185#,
      16#5ae3#,
      16#3f06#,
      16#22ef#,
      16#0b25#,
      16#faf6#,
      16#f3ed#,
      16#f5ad#,
      16#fe27#,
      16#0a1c#,
      16#15e0#,
      16#1e1a#,
      16#2079#,
      16#1c25#,
      16#11de#,
      16#03c7#,
      16#f4e0#,
      16#e85b#,
      16#e0dd#,
      16#dfe4#,
      16#e565#,
      16#efc2#,
      16#fc14#,
      16#06be#,
      16#0c34#,
      16#09b9#,
      16#fe0a#,
      16#e9be#,
      16#cf4c#,
      16#b2b4#,
      16#98d6#,
      16#8698#,
      16#8000#,
      16#8771#,
      16#9d2a#,
      16#bf27#,
      16#e969#,
      16#1697#,
      16#40d9#,
      16#62d6#,
      16#788f#,
      16#7fff#,
      16#7968#,
      16#672a#,
      16#4d4c#,
      16#30b4#,
      16#1642#,
      16#01f6#,
      16#f647#,
      16#f3cc#,
      16#f942#,
      16#03ec#,
      16#103e#,
      16#1a9b#,
      16#201c#,
      16#1f23#,
      16#17a5#,
      16#0b20#,
      16#fc39#,
      16#ee22#,
      16#e3db#,
      16#df87#,
      16#e1e6#,
      16#ea20#,
      16#f5e4#,
      16#01d9#,
      16#0a53#,
      16#0c13#,
      16#050a#,
      16#f4db#,
      16#dd11#,
      16#c0fa#,
      16#a51d#,
      16#8e7b#,
      16#81a5#,
      16#81e6#,
      16#9097#,
      16#acd5#,
      16#d390#,
      16#0000#);

   ---------------------
   -- Simple_FFT_Test --
   ---------------------

   procedure Simple_FFT_Test is
      function To_S16
      is new Ada.Unchecked_Conversion (Interfaces.Unsigned_16, S16);
      FFT_Size : constant := 256;

      FFT      : Tresses.FFT.Fixed.Block_Processing
        (FFT_Size, FFT_Size / 2, FFT_Size);
      Freq_Dom : Tresses.FFT.Fixed.Frequency_Domain (FFT.Window_Size);
      Mag      : Tresses.FFT.Fixed.Magnitudes (FFT.Half_Window_Size);
      --  Phase    : Tresses.FFT.Fixed.Phases (FFT.Half_Window_Size);

      Idx : Natural := Data'First;
   begin
      Put_Line ("256 FFT on AVR-FFT data");

      while not FFT.Push_Frame (To_S16 (Data (Idx))) loop
         if Idx = Data'Last then
            Idx := Data'First;
         else
            Idx := Idx + 1;
         end if;
      end loop;

      FFT.Process_FFT (Freq_Dom, Apply_Window => True);
      Freq_Dom.Bin_Magnitudes (Mag);
      --  Freq_Dom.Bin_Phases (Phase);

      for Bin in 1 .. FFT.Half_Window_Size loop
         for X in 0 .. Mag (Bin) / 100 loop
            Put ("-");
         end loop;
         New_Line;
      end loop;

      --  Put_Line ("++++++++++++++++++++++++");
      --
      --  for Bin in 1 .. FFT.Half_Window_Size loop
      --     FIO.Put (Float (Phase (Bin)) / 2.0**13, Fore => 0, Aft => 5,
      --              Exp => 0);
      --     New_Line;
      --  end loop;
      --
      --  Put_Line ("++++++++++++++++++++++++");

      --  for Bin in 1 .. FFT.Half_Window_Size loop
      --     for X in -50 .. 0 loop
      --        if Phase (Bin) / 1000 > S16 (X) then
      --           Put (" ");
      --        else
      --           Put ("-");
      --        end if;
      --     end loop;
      --     for X in 0 .. Phase (Bin) / 1000 loop
      --        Put ("-");
      --     end loop;
      --     New_Line;
      --  end loop;

      Put_Line ("Max bin center freq: " &
                  Integer (FFT.Bin_Center_Frequency (Mag.Max_Mag_Bin))'Img);
   end Simple_FFT_Test;

   --------------------
   -- Noise_FFT_Test --
   --------------------

   procedure Noise_FFT_Test is
      FFT_Size : constant := 256;
      FFT : Tresses.FFT.Fixed.Block_Processing
        (FFT_Size, FFT_Size / 2, FFT_Size);
      Freq_Dom : Tresses.FFT.Fixed.Frequency_Domain (FFT.Window_Size);
      Mag : Tresses.FFT.Fixed.Magnitudes (FFT.Half_Window_Size);
      Rng : Tresses.Random.Instance;
   begin
      Put_Line ("Noise FFT");
      loop
         exit when FFT.Push_Frame (Tresses.Random.Get_Sample (Rng));
      end loop;

      FFT.Process_FFT (Freq_Dom, Apply_Window => True);
      Freq_Dom.Bin_Magnitudes (Mag);
      for Bin in 1 .. FFT.Half_Window_Size loop
         for X in 0 .. Mag (Bin) / 10 loop
            Put ("-");
         end loop;
         New_Line;
      end loop;
   end Noise_FFT_Test;

   package AF is new Ada.Numerics.Generic_Elementary_Functions (Float);

   function MIDI_Freq (K : MIDI.MIDI_Key) return Float
   is (440.0 * AF."**"(2.0, (Float (K) - 69.0) / 12.0));

   function Wrap_Phase (P : Float) return Float is
      R : Float := P;
   begin
      if R < 0.0 then
         while R < -Ada.Numerics.Pi loop
            R := R + 2.0 * Ada.Numerics.Pi;
         end loop;
      elsif R > 0.0 then
         while R > Ada.Numerics.Pi loop
            R := R - 2.0 * Ada.Numerics.Pi;
         end loop;
      end if;

      return R;
   end Wrap_Phase;
   pragma Unreferenced (Wrap_Phase);

   --------------
   -- Test_FFT --
   --------------

   type Freq_Detection_Error is record
      Center_Freq_Error : Float;
      Adjusted_Error    : Float;
   end record;

   function Test_FFT (FFT_Size : Natural;
                      S        : Shape_Kind;
                      Key      : MIDI.MIDI_Key)
                      return Freq_Detection_Error
   is
      Test_Data : Tresses.Mono_Buffer (0 .. FFT_Size * 2 - 1) := (others => 0);
      Osc       : Tresses.Analog_Oscillator.Instance;
      FFT       : Tresses.FFT.Fixed.Block_Processing
        (FFT_Size, FFT_Size / 2, FFT_Size / 2);
      Freq_Dom  : Tresses.FFT.Fixed.Frequency_Domain (FFT.Window_Size);
      Mag       : Tresses.FFT.Fixed.Magnitudes (FFT.Half_Window_Size);
      --  Phase1, Phase2 : Tresses.FFT.Fixed.Phases (FFT.Half_Window_Size);
      Step1 : Boolean := True;
   begin
      Init (Osc);
      Set_Shape (Osc, S);
      Set_Pitch (Osc, Tresses.MIDI_Pitch (Key));
      Render (Osc, Test_Data);
      Render (Osc, Test_Data);
      Render (Osc, Test_Data);

      for Elt of Test_Data loop
         if FFT.Push_Frame (Elt) then
            if Step1 then
               FFT.Process_FFT (Freq_Dom, Apply_Window => True);
               --  Freq_Dom.Bin_Phases (Phase1);
               Step1 := False;
            else
               FFT.Process_FFT (Freq_Dom, Apply_Window => True);
               Freq_Dom.Bin_Magnitudes (Mag);
               --  Freq_Dom.Bin_Phases (Phase2);

               if Verbose then
                  Put_Line ("------------------------------------------");
                  Put_Line ("FFT Size:" & FFT_Size'Img);
                  Put_Line ("MIDI Key:" & Key'Img);

                  Put_Line ("Max Bin:" & Mag.Max_Mag_Bin'Img);
                  Put_Line ("Max Mag:" & Mag (Mag.Max_Mag_Bin)'Img);
               end if;

               declare
                  Bin : constant Natural := Mag.Max_Mag_Bin;
                  Expected : constant Float := MIDI_Freq (Key);
                  Actual : constant Float :=
                    FFT.Bin_Center_Frequency (Mag.Max_Mag_Bin);

                  Diff : constant Float := Expected - Actual;
                  Error : constant Float := (abs (Diff / Expected)) * 100.0;
                  --  Phase_Diff : constant S32 :=
                  --    S32 (Phase1 (Bin)) - S32 (Phase2 (Bin));

                  --  Phase_Diff_F : constant Float :=
                  --    Float (Phase_Diff) / 2.0**13;

                  Centre_Freq : constant Float :=
                    (2.0 * Ada.Numerics.Pi * Float (Bin - 1))
                      /
                    Float (FFT_Size);

                  Expected_Phase_Shift : constant Float :=
                    Centre_Freq * Float (FFT.Hop_Size);
                  pragma Unreferenced (Expected_Phase_Shift);

                  --  Phase_Reminder : constant Float :=
                  --    Phase_Diff_F - Expected_Phase_Shift;

                  --  Wrap_Phase_Reminder : constant Float :=
                  --    Wrap_Phase (Phase_Reminder);

                  --  Bin_Deviation : constant Float :=
                  --    Wrap_Phase_Reminder * Float (FFT_Size)
                  --    /
                  --    (Float (FFT.Hop_Size) * 2.0 * Ada.Numerics.Pi);
                  --
                  --  Frac_Bin : constant Float :=
                  --    Float (Bin - 1) + Bin_Deviation;
                  --
                  --  Actual_Freq : constant Float :=
                  --    (Frac_Bin * Tresses.Resources.SAMPLE_RATE_REAL)
                  --    /
                  --    Float (FFT_Size);
                  --
                  --  Diff2 : constant Float := Expected - Actual_Freq;
                  --  Error2 : constant Float :=
                  --    (abs (Diff2 / Expected)) * 100.0;

               begin
                  --  Put ("Phase_Diff:" & Phase_Diff'Img & " (");
                  --  FIO.Put (Phase_Diff_F, Fore => 0, Aft => 5, Exp => 0);
                  --  Put_Line (")");

                  --  Put ("Bin deviation:");
                  --  FIO.Put (Bin_Deviation, Fore => 0, Aft => 5, Exp => 0);
                  --  Put_Line ("");

                  if Verbose then
                     Put_Line ("Expected frequency  :" &
                                 Integer (Expected)'Img);
                     Put_Line ("Center bin frequency:" &
                                 Integer (Actual)'Img);
                     Put_Line ("Diff:" & Diff'Img);
                     Put_Line ("Error:" & Integer (Error)'Img & "%");
                     --  Put_Line ("Error2:" & Integer (Error2)'Img & "%");
                  end if;
                  return (Error, 0.0); --  Error2);
               end;
            end if;
         end if;
      end loop;
      return (0.0, 0.0);
   end Test_FFT;

   --------------------
   -- Test_FFT_Range --
   --------------------

   procedure Test_FFT_Range (Table     : in out AAA.Table_IO.Table;
                             FFT_Size  : Natural;
                             Shape     : Shape_Kind;
                             Octave    : MIDI.Octaves)
   is
      subtype Test_Range
        is MIDI.MIDI_Key
      range MIDI.Key (Octave, MIDI.C) .. MIDI.Key (Octave, MIDI.B);

      Error : Freq_Detection_Error;
      Max_Error : Freq_Detection_Error := (0.0, 0.0);
      Acc_Error : Freq_Detection_Error := (0.0, 0.0);
      Unused : Float;
      Count : Natural := 0;
   begin

      for K in Test_Range loop
         Count := Count + 1;
         Error := Test_FFT (FFT_Size, Shape, K);

         Acc_Error.Center_Freq_Error :=
           Acc_Error.Center_Freq_Error + Error.Center_Freq_Error;

         Acc_Error.Adjusted_Error :=
           Acc_Error.Adjusted_Error + Error.Adjusted_Error;

         if Error.Center_Freq_Error > Max_Error.Center_Freq_Error then
            Max_Error.Center_Freq_Error := Error.Center_Freq_Error;
         end if;
         if Error.Adjusted_Error > Max_Error.Adjusted_Error then
            Max_Error.Adjusted_Error := Error.Adjusted_Error;
         end if;

      end loop;

      if Verbose then
         Put_Line ("+++++++++++++++++++++++++++++++++++++++++++");
         Put_Line ("FFT Size:" & FFT_Size'Img);
         Put_Line ("Signal Shape: " & Shape'Img);
         --  Put_Line ("Avg Error:" &
         --              Integer (Acc_Error / Float (Count))'Img & "%");
         --  Put_Line ("Max Error:" & Integer (Max_Error)'Img & "%");
      end if;

      Table.New_Row;
      Table.Append (FFT_Size'Img);
      Table.Append (Octave'Img);
      Table.Append (Shape'Img);
      Table.Append
        (Integer (Acc_Error.Center_Freq_Error / Float (Count))'Img & "%");
      Table.Append (Integer (Max_Error.Center_Freq_Error)'Img & "%");
      Table.Append
        (Integer (Acc_Error.Adjusted_Error / Float (Count))'Img & "%");
      Table.Append (Integer (Max_Error.Adjusted_Error)'Img & "%");
   end Test_FFT_Range;

   -------------------
   -- Test_FFT_Size --
   -------------------

   procedure Test_FFT_Size (FFT_Size : Natural) is
      Shapes : constant array (Natural range <>) of Shape_Kind :=
        (0 => Sine); -- , Square, Triangle);

      Table : AAA.Table_IO.Table;
   begin
      Table.Append ("FFT Size");
      Table.Append ("Octave");
      Table.Append ("Shape");
      Table.Append ("Avg Error (Center)");
      Table.Append ("Max Error (Center)");
      Table.Append ("Avg Error (Adj)");
      Table.Append ("Max Error (Adj)");

      for Oct in MIDI.Octaves loop
         for Shape of Shapes loop
            Test_FFT_Range (Table, FFT_Size, Shape, Oct);
         end loop;
      end loop;
      Table.Print;
   end Test_FFT_Size;

   FFT_Size : Natural;
begin

   Simple_FFT_Test;

   Noise_FFT_Test;

   FFT_Size := 16;
   while FFT_Size <= 2048 loop
      Test_FFT_Size (FFT_Size);
      FFT_Size := FFT_Size * 2;
   end loop;
end FFT;
