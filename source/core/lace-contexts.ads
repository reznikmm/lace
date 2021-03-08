--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers;

with Lace.Generic_Engines;

package Lace.Contexts is
   pragma Preelaborate;

   type Context;

   subtype Dummy_Variant is Ada.Containers.Hash_Type;

   type Boolean_Property is (Is_Static);

   package Boolean_Engines is new Lace.Generic_Engines
     (Property_Name    => Boolean_Property,
      Property_Value   => Boolean,
      Abstract_Context => Context,
      Variant_Kind     => Dummy_Variant,
      Hash             => Dummy_Variant'Mod);

   type Context is tagged limited record
      Boolean : aliased Boolean_Engines.Engine (Context'Unchecked_Access);
   end record;

end Lace.Contexts;
