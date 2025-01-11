package Tresses.LFO
with Preelaborate
is

   type Shape_Kind is (Sine, Triangle, Ramp_Up, Ramp_Down, Exp_Up, Exp_Down);
   type Amplitude_Kind is (Positive, Center, Negative);
   type Loop_Kind is (Repeat, One_Shot);

   type Instance is tagged private;

   procedure Init (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Sync (This : in out Instance; Phase : U32 := 0)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Shape (This : in out Instance; S : Shape_Kind)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Rate (This  : in out Instance;
                       R     : Param_Range;
                       Scale : U32 := 1)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Amplitude (This : in out Instance;
                            A    :        Param_Range)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Amp_Mode (This : in out Instance;
                           Mode :        Amplitude_Kind)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Loop_Mode (This : in out Instance;
                            Mode :        Loop_Kind)
     with Linker_Section => Code_Linker_Section;

   function Render (This : in out Instance) return S16
     with Linker_Section => Code_Linker_Section;

private

   type Instance
   is tagged record
      Shape       : Shape_Kind := Shape_Kind'First;
      Prev_Shape  : Shape_Kind := Shape_Kind'Last;

      Rate : Param_Range := Param_Range'Last / 2;
      Amplitude : Param_Range := Param_Range'Last / 2;
      Amp_Mode : Amplitude_Kind := Amplitude_Kind'First;
      Loop_Mode : Loop_Kind := Repeat;

      Halt : Boolean := False;

      Phase      : U32 := 0;
      Phase_Increment : U32 := 1;
   end record;

end Tresses.LFO;
