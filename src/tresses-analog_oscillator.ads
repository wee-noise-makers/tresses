package Tresses.Analog_Oscillator
with Preelaborate
is

   type Shape_Kind is (Saw, Variable_Saw, Square, Triangle, Sine,
                       Triangle_Fold, Sine_Fold, Buzz);

   type Param_Id is range 0 .. 0;
   type Param_Array is array (Param_Id) of Param_Range;

   type Instance
   is tagged record
      Pitch       : Pitch_Range := Init_Pitch;
      Shape       : Shape_Kind := Shape_Kind'First;
      Prev_Shape  : Shape_Kind := Shape_Kind'Last;
      Params      : Param_Array := (others => Param_Range'Last);
      Prev_Params : Param_Array := (others => Param_Range'Last);

      Phase      : U32 := 0;
      Phase_Increment : U32 := 1;
      Prev_Phase_Increment : U32 := 1;
      High : Boolean := False; -- For square wave, saw, variable saw

      Discontinuity_Depth : S16 := 0;
      Next_Sample : Mono_Point := 0;

   end record;

   procedure Init (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Sync (This : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Shape (This : in out Instance; S : Shape_Kind)
     with Linker_Section => Code_Linker_Section;

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Param (This : in out Instance;
                        Id   :        Param_Id;
                        P    :        Param_Range)
     with Linker_Section => Code_Linker_Section;

   procedure Set_Pitch (This : in out Instance; P : Pitch_Range)
     with Linker_Section => Code_Linker_Section;

private

   type Param_Interpolator is record
      Id    : Param_Id;
      Start : S32;
      Delt  : S32;
      Increment : S32;
      Xfade : S32;
   end record;

   procedure Begin_Interpolate
     (This        : in out Param_Interpolator;
      Osc         : in out Instance;
      Id          :        Param_Id;
      Buffer_Size :        U32)
     with Linker_Section => Code_Linker_Section;

   function Interpolate
     (This : in out Param_Interpolator)
      return Param_Range
     with Inline_Always;

   procedure End_Interpolate
     (This : in out Param_Interpolator;
      Osc  : in out Instance)
     with Linker_Section => Code_Linker_Section;

   type Phase_Increment_Interpolator is record
      Phase_Increment           : U32 := 1;
      Phase_Increment_Increment : U32 := 1;
   end record;

   procedure Begin_Interpolate
     (This        : in out Phase_Increment_Interpolator;
      Osc         : in out Instance;
      Buffer_Size :        U32)
     with Linker_Section => Code_Linker_Section;

   function Interpolate
     (This : in out Phase_Increment_Interpolator)
      return U32
   with Inline_Always;

   procedure End_Interpolate
     (This : in out Phase_Increment_Interpolator;
      Osc  : in out Instance)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Saw (This   : in out Instance;
                         Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Variable_Saw (This   : in out Instance;
                                  Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Square (This   : in out Instance;
                            Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Triangle (This   : in out Instance;
                              Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Sine (This   : in out Instance;
                          Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Triangle_Fold (This   : in out Instance;
                                   Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Sine_Fold (This   : in out Instance;
                               Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

   procedure Render_Buzz (This   : in out Instance;
                          Buffer :    out Mono_Buffer)
     with Linker_Section => Code_Linker_Section;

end Tresses.Analog_Oscillator;
