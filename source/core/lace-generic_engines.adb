--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

package body Lace.Generic_Engines is

   ------------------
   -- Get_Property --
   ------------------

   function Get_Property
     (Self    : access Engine;
      Element : Program.Elements.Element_Access;
      Name    : Property_Name)
      return Property_Value
   is
      Key : constant Property_Key :=
        (Lace.Element_Flat_Kinds.Flat_Kind (Element), Name);

      Descriptor : constant Property_Descriptor := Self.Descriptor (Key);
      Variant    : Variant_Kind;
      Formula    : Formula_Access;
   begin
      if Descriptor.Selector = null then
         return  Descriptor.Formula (Self.Context, Element, Name);
      else
         Variant := Descriptor.Selector (Self.Context, Element, Name);
         Formula := Self.Varian.Element ((Key, Variant));
         return Formula.all (Self.Context, Element, Name);
      end if;
   end Get_Property;

   ------------------
   -- Get_Property --
   ------------------

   function Get_Property
     (Self  : access Engine;
      List  : Program.Element_Vectors.Element_Vector_Access;
      Name  : Property_Name;
      Empty : Property_Value;
      Sum   : access function
        (Left, Right : Property_Value) return Property_Value)
          return Property_Value
   is
      Result : Property_Value := Empty;
   begin
      for Cursor in List.Each_Element loop
         declare
            Next : constant Property_Value := Self.Get_Property
              (Cursor.Element, Name);
         begin
            Result := Sum (Result, Next);
         end;
      end loop;

      return Result;
   end Get_Property;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Property_Key) return Ada.Containers.Hash_Type is
      use type Ada.Containers.Hash_Type;
   begin
      return 997 * Ada.Containers.Hash_Type'Mod
        (Lace.Element_Flat_Kinds.Element_Flat_Kind'Pos (Value.Kind))
          + Ada.Containers.Hash_Type'Mod (Property_Name'Pos (Value.Name));
   end Hash;

   ----------
   -- Hash --
   ----------

   function Hash (Value : Varian_Key) return Ada.Containers.Hash_Type is
      use type Ada.Containers.Hash_Type;
   begin
      return 7901 * Hash (Value.Variant) + Hash (Value.Property);
   end Hash;

   ----------------------
   -- Register_Formula --
   ----------------------

   procedure Register_Formula
     (Self    : in out Engine;
      Kind    : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name    : Property_Name;
      Formula : not null Formula_Access) is
   begin
      Self.Descriptor.Insert ((Kind, Name), (Formula, null));
   end Register_Formula;

   -----------------------
   -- Register_Selector --
   -----------------------

   procedure Register_Selector
     (Self     : in out Engine;
      Kind     : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name     : Property_Name;
      Selector : not null Selector_Access) is
   begin
      Self.Descriptor.Insert ((Kind, Name), (null, Selector));
   end Register_Selector;

   ----------------------
   -- Register_Variant --
   ----------------------

   procedure Register_Variant
     (Self    : in out Engine;
      Kind    : Lace.Element_Flat_Kinds.Element_Flat_Kind;
      Name    : Property_Name;
      Variant : Variant_Kind;
      Formula : access function
        (Engine  : access Abstract_Context;
         Element : Program.Elements.Element_Access;
         Name    : Property_Name)
         return Property_Value) is
   begin
      pragma Assert (Self.Descriptor.Element ((Kind, Name)).Selector /= null);
      Self.Varian.Insert (((Kind, Name), Variant), Formula);
   end Register_Variant;

end Lace.Generic_Engines;
