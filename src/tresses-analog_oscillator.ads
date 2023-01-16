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

   procedure Init (This : in out Instance);

   procedure Sync (This : in out Instance);

   procedure Set_Shape (This : in out Instance; S : Shape_Kind);

   procedure Render (This   : in out Instance;
                     Buffer :    out Mono_Buffer);

   procedure Set_Param (This : in out Instance;
                        Id   :        Param_Id;
                        P    :        Param_Range);

   procedure Set_Pitch (This : in out Instance; P : Pitch_Range);

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
      Buffer_Size :        U32);

   function Interpolate
     (This : in out Param_Interpolator)
      return Param_Range;

   procedure End_Interpolate
     (This : in out Param_Interpolator;
      Osc  : in out Instance);

   type Phase_Increment_Interpolator is record
      Phase_Increment           : U32 := 1;
      Phase_Increment_Increment : U32 := 1;
   end record;

   procedure Begin_Interpolate
     (This        : in out Phase_Increment_Interpolator;
      Osc         : in out Instance;
      Buffer_Size :        U32);

   function Interpolate
     (This : in out Phase_Increment_Interpolator)
      return U32;

   procedure End_Interpolate
     (This : in out Phase_Increment_Interpolator;
      Osc  : in out Instance);

   procedure Render_Saw (This   : in out Instance;
                         Buffer :    out Mono_Buffer);

   procedure Render_Variable_Saw (This   : in out Instance;
                                  Buffer :    out Mono_Buffer);

   procedure Render_Square (This   : in out Instance;
                            Buffer :    out Mono_Buffer);

   procedure Render_Triangle (This   : in out Instance;
                              Buffer :    out Mono_Buffer);

   procedure Render_Sine (This   : in out Instance;
                          Buffer :    out Mono_Buffer);

   procedure Render_Triangle_Fold (This   : in out Instance;
                                   Buffer :    out Mono_Buffer);

   procedure Render_Sine_Fold (This   : in out Instance;
                               Buffer :    out Mono_Buffer);

   procedure Render_Buzz (This   : in out Instance;
                          Buffer :    out Mono_Buffer);

end Tresses.Analog_Oscillator;
