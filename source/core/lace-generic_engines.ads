--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Containers.Hashed_Maps;

with Program.Elements;
with Program.Element_Vectors;
with Lace.Element_Flat_Kinds;

generic
   type Property_Name is (<>);
   type Property_Value is private;
   type Abstract_Context;

   type Variant_Kind is private;

   with function Hash
     (Value : Variant_Kind) return Ada.Containers.Hash_Type is <>;

package Lace.Generic_Engines is
   pragma Preelaborate;

   type Engine (Context : access Abstract_Context) is
     tagged limited private;

   function Get_Property
     (Self    : access Engine;
      Element : Program.Elements.Element_Access;
      Name    : Property_Name) return Property_Value;
   --  Evaluate a property (with Name) for given Element

   function Get_Property
     (Self    : access Engine;
      List    : Program.Element_Vectors.Element_Vector_Access;
      Name    : Property_Name;
      Empty   : Property_Value;
      Sum     : access function
        (Left, Right : Property_Value) return Property_Value)
      return Property_Value;
   --  Evaluate a property (with Name) for each Element and aggregate results
   --  with Sum function taking Empty as a start value.

   type Formula_Access is access function
        (Engine  : access Abstract_Context;
         Element : Program.Elements.Element_Access;
         Name    : Property_Name) return Property_Value;

   procedure Register_Formula
     (Self    : in out Engine;
      Kind    : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name    : Property_Name;
      Formula : not null Formula_Access);
   --  Register given function (Formula) as a calculator given property (with
   --  Name) for elements of given Kind. No selector could be set if there is
   --  a formula.

   type Selector_Access is access function
        (Engine  : access Abstract_Context;
         Element : Program.Elements.Element_Access;
         Name    : Property_Name) return Variant_Kind;

   procedure Register_Selector
     (Self     : in out Engine;
      Kind     : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name     : Property_Name;
      Selector : not null Selector_Access);
   --  Turn property with Name to multivariant form. Use Selector to choose
   --  a variant for particular Element. No formula could be set if there is
   --  a selector.

   procedure Register_Variant
     (Self    : in out Engine;
      Kind    : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name    : Property_Name;
      Variant : Variant_Kind;
      Formula : access function
        (Engine  : access Abstract_Context;
         Element : Program.Elements.Element_Access;
         Name    : Property_Name) return Property_Value);
   --  Register given function (Formula) as a calculator of the property
   --  Variant. The property should have a selector.

private

   type Property_Key is record
      Kind : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name : Property_Name;
   end record;

   function Hash (Value : Property_Key) return Ada.Containers.Hash_Type;

   type Property_Descriptor is record
      Formula  : Formula_Access;  --  Formula, only if no variant selector
      Selector : Selector_Access;  --  Selector, only if no formula
   end record;

   package Property_Descriptor_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type        => Property_Key,
      Element_Type    => Property_Descriptor,
      Hash            => Hash,
      Equivalent_Keys => "=",
      "="             => "=");

   type Varian_Key is record
      Property : Property_Key;
      Variant  : Variant_Kind;
   end record;

   function Hash (Value : Varian_Key) return Ada.Containers.Hash_Type;

   package Varian_Descriptor_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type        => Varian_Key,
      Element_Type    => Formula_Access,
      Hash            => Hash,
      Equivalent_Keys => "=",
      "="             => "=");

   type Engine (Context : access Abstract_Context) is tagged limited
   record
      Descriptor : Property_Descriptor_Maps.Map;
      Varian     : Varian_Descriptor_Maps.Map;
   end record;

end Lace.Generic_Engines;
