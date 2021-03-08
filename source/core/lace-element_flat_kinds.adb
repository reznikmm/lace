--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Program.Elements.Procedure_Body_Declarations;
with Program.Safe_Element_Visitors;

package body Lace.Element_Flat_Kinds is

   type Visitor is new Program.Safe_Element_Visitors.Safe_Element_Visitor with
   record
      Result : Element_Flat_Kind;
   end record;

   overriding procedure Procedure_Body_Declaration
    (Self   : in out Visitor;
     Ignore : not null Program.Elements.Procedure_Body_Declarations
         .Procedure_Body_Declaration_Access);

   overriding procedure Procedure_Body_Declaration
    (Self   : in out Visitor;
     Ignore : not null Program.Elements.Procedure_Body_Declarations
         .Procedure_Body_Declaration_Access) is
   begin
      Self.Result := Procedure_Body_Declaration_Kind;
   end Procedure_Body_Declaration;

   ---------------
   -- Flat_Kind --
   ---------------

   function Flat_Kind
     (Element : not null Program.Elements.Element_Access)
      return Element_Flat_Kind
   is
      V : Visitor;
   begin
      V.Visit (Element);

      return V.Result;
   end Flat_Kind;

end Lace.Element_Flat_Kinds;
