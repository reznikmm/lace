--  SPDX-FileCopyrightText: 2021 Max Reznik <reznikmm@gmail.com>
--
--  SPDX-License-Identifier: MIT
-------------------------------------------------------------

with Ada.Characters.Conversions;
with Ada.Command_Line;
with Ada.Text_IO;
with Ada.Wide_Wide_Text_IO;

with LLVM.Core;

with Program.Compilations;
with Program.Error_Listeners;
with Program.Plain_Contexts;

with Program.Storage_Pools.Instance;
pragma Unreferenced (Program.Storage_Pools.Instance);

with Lace.LLVM_Contexts;

procedure Lace.Run is
   type Error_Listener is new Program.Error_Listeners.Error_Listener
     with null record;

   Ctx     : aliased Program.Plain_Contexts.Context;
   Errors  : aliased Error_Listener;
   Context : Lace.LLVM_Contexts.LLVM_Context;
   Done    : Integer;
begin
   Ada.Wide_Wide_Text_IO.Put_Line ("🎇 Hello!");
   Ctx.Initialize (Errors'Unchecked_Access);

   for J in 1 .. Ada.Command_Line.Argument_Count loop
      declare
         Arg : constant Wide_Wide_String :=
           Ada.Characters.Conversions.To_Wide_Wide_String
             (Ada.Command_Line.Argument (J));
      begin
         if Arg'Length > 2 and then Arg (1 .. 2) = "-I" then
            Ctx.Add_Search_Directory (Arg (3 .. Arg'Last));
         else
            Ctx.Parse_File (Arg);
         end if;
      end;
   end loop;

   Ctx.Complete_Analysis;

   Context.Context := LLVM.Core.Context_Create;
   Context.Builder := LLVM.Core.Create_Builder_In_Context (Context.Context);

   for Cursor in Ctx.Compilation_Unit_Bodies.Each_Unit loop
      Context.Module := LLVM.Core.Module_Create_With_Name_In_Context
        (Ada.Characters.Conversions.To_String
           (Cursor.Unit.Compilation.Text_Name),
         Context.Context);

      --  For each body calculate a dummy property Done. As side effect it will
      --  build LLVM representation in the Context.Module
      Done := Context.LLVM_Int.Get_Property
        (Cursor.Unit.Unit_Declaration, Lace.LLVM_Contexts.Done);

      Ada.Text_IO.Put ("; Done=");
      Ada.Text_IO.Put_Line (Done'Image);

      --  Output LLVM code:
      Ada.Text_IO.Put_Line (LLVM.Core.Print_Module_To_String (Context.Module));
   end loop;

end Lace.Run;
