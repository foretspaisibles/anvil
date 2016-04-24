(* Anvil_Init -- Initialise a project

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

module Application =
  Gasoline_Plain_Application

module Component_Database =
struct

  let comp =
    Application.Component.make
      ~name:"database"
      ~description:"Database parameters"
      ()

  module Configuration =
  struct
    open Application.Configuration

    let filename =
      make_string comp ~flag:'f'
        "filename" Anvil_Configuration.ac_resource_db
        "The filename of the application database"
  end

  let module_lst = [
    (module Anvil_License : Anvil_Database.S);
    (module Anvil_Build : Anvil_Database.S);
  ]

  let initdb () =
    Anvil_Database.withdb (Configuration.filename())
      (Anvil_Database.initdb module_lst)

  let importdb path =
    Anvil_Database.withdb (Configuration.filename())
      (Anvil_Database.importdb module_lst path)
end

let run_index arglist =
  Format.eprintf "Index: %a\n%!"
    (Lemonade_Maybe.pp_print Anvil_Index.pp_print_index)
    (Anvil_Index.from_repository "/Users/michael/Workshop/lemonade")

let run_initdb arglist =
  Component_Database.initdb ()

let run_importdb arglist =
  List.iter Component_Database.importdb arglist

let () =
  Application.run "anvil"
    "[-h]"
    "Initialise a project"
    ~configuration:Application.Configuration.Command_line
    run_importdb
