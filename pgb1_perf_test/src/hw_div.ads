with Tresses; use Tresses;

package HW_Div is
   function DivU32 (A, B : U32) return U32;
   pragma Export (C, DivU32, "__wrap___aeabi_uidiv");

   function ModU32 (A, B : U32) return U32;
   pragma Export (C, ModU32, "__wrap___aeabi_uidivmod");

   function DivS32 (A, B : S32) return S32;
   pragma Export (C, DivS32, "__wrap___aeabi_idiv");

   function ModS32 (A, B : S32) return S32;
   pragma Export (C, ModS32, "__wrap___aeabi_idivmod");
end HW_Div;
