--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers;

with LLVM.Types;

with Lace.Contexts;
with Lace.Generic_Engines;

package Lace.LLVM_Contexts is
--   pragma Preelaborate;

   type LLVM_Context;

   type LLVM_Type_Property is (LLVM_Type);

   subtype Dummy_Variant is Ada.Containers.Hash_Type;

   type Integer_Property is (Done);

   package Integer_Engines is new Lace.Generic_Engines
     (Property_Name    => Integer_Property,
      Property_Value   => Integer,
      Abstract_Context => LLVM_Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   package LLVM_Type_Engines is new Lace.Generic_Engines
     (Property_Name    => LLVM_Type_Property,
      Property_Value   => LLVM.Types.Type_T,
      Abstract_Context => LLVM_Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   type LLVM_Value_Property is (LLVM_Value);

   package LLVM_Value_Engines is new Lace.Generic_Engines
     (Property_Name    => LLVM_Value_Property,
      Property_Value   => LLVM.Types.Value_T,
      Abstract_Context => LLVM_Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   type LLVM_Block_Property is (LLVM_Block);

   package LLVM_Block_Engines is new Lace.Generic_Engines
     (Property_Name    => LLVM_Block_Property,
      Property_Value   => LLVM.Types.Basic_Block_T,
      Abstract_Context => LLVM_Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   type LLVM_Meta_Property is (LLVM_Meta);

   package LLVM_Meta_Engines is new Lace.Generic_Engines
     (Property_Name    => LLVM_Meta_Property,
      Property_Value   => LLVM.Types.Metadata_T,
      Abstract_Context => LLVM_Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   type LLVM_Context is new Lace.Contexts.Context with record
      LLVM_Int   : aliased Integer_Engines.Engine
                            (LLVM_Context'Unchecked_Access);
      LLVM_Type  : aliased LLVM_Type_Engines.Engine
                            (LLVM_Context'Unchecked_Access);
      LLVM_Value : aliased LLVM_Value_Engines.Engine
                            (LLVM_Context'Unchecked_Access);
      LLVM_Block : aliased LLVM_Block_Engines.Engine
                            (LLVM_Context'Unchecked_Access);
      LLVM_Meta  : aliased LLVM_Meta_Engines.Engine
                            (LLVM_Context'Unchecked_Access);

      Context   : LLVM.Types.Context_T;
      Module    : LLVM.Types.Module_T;
      Builder   : LLVM.Types.Builder_T;
   end record;

end Lace.LLVM_Contexts;
