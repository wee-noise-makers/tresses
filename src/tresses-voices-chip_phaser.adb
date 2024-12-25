with Tresses.Envelopes.AR; use Tresses.Envelopes.AR;

with Tresses.DSP;
with Tresses.Resources;

with Ada.Unchecked_Conversion;

package body Tresses.Voices.Chip_Phaser is

   ------------
   -- Render --
   ------------

   procedure Render
     (BufferA, BufferB :    out Mono_Buffer;
      Params           :        Param_Array;
      Phase_Increment  : in out U32;
      Osc1, Osc2       : in out Analog_Oscillator.Instance;
      Env              : in out Envelopes.AR.Instance;
      Pitch            :        Pitch_Range;
      Do_Init          : in out Boolean;
      Do_Strike        : in out Strike_State)
   is
      Phaser  : Param_Range renames Params (P_Phaser);
      Shape   : Param_Range renames Params (P_Shape);
      Attack  : Param_Range renames Params (P_Attack);
      Release : Param_Range renames Params (P_Release);

      SampleA, SampleB : S32;

   begin
      if Do_Init then
         Do_Init := False;

         Analog_Oscillator.Init (Osc1);
         Analog_Oscillator.Set_Shape (Osc1, Analog_Oscillator.Square);
         Analog_Oscillator.Init (Osc2);
         Analog_Oscillator.Set_Shape (Osc2, Analog_Oscillator.Square);

         Init (Env, Do_Hold => True);
      end if;

      case Do_Strike.Event is
         when On =>
            Do_Strike.Event := None;
            On (Env, Do_Strike.Velocity);

         when Off =>
            Do_Strike.Event := None;
            Off (Env);

         when None => null;
      end case;

      Phase_Increment := DSP.Compute_Phase_Increment (S16 (Pitch));

      Analog_Oscillator.Set_Param (Osc1, 0, Shape);
      Analog_Oscillator.Render (Osc1, BufferA, Phase_Increment);
      Analog_Oscillator.Set_Param (Osc2, 0, Shape);
      Analog_Oscillator.Render (Osc2, BufferB,
                                Phase_Increment + u32 (Phaser) * 8);

      Set_Attack (Env, Attack);
      Set_Release (Env, Release);

      for Index in BufferA'Range loop
         SampleA := S32 (BufferA (Index));
         SampleB := S32 (BufferB (Index));

         --  Envolopes
         Render (Env);
         SampleA := (SampleA + SampleB) / 2;
         SampleA := (SampleA * S32 (LoFi (Env))) / 2**15;
         BufferA (Index) := S16 (SampleA);
      end loop;

   end Render;

end Tresses.Voices.Chip_Phaser;
