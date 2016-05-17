(* Component_Database -- Software component to access the Database

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

let _db = ref None
let _bootstrap = ref ignore
let _shutdown = ref ignore

let comp =
  Application.Component.make
    ~name:"database"
    ~description:"Database parameters"
    ~bootstrap:(fun () -> !_bootstrap())
    ~shutdown:(fun() -> !_shutdown())
    ()

let module_lst = [
  (module Anvil_License : Anvil_Database.S);
  (module Anvil_Build : Anvil_Database.S);
  (module Anvil_Template : Anvil_Database.S)
]

let withdb f =
  match !_db with
  | Some(db) -> f db
  | None -> failwith "Component_Database: Component not initialised."


module Configuration =
struct
  open Application.Configuration

  let filename =
    make_string comp ~flag:'f'
      "filename" Anvil_Configuration.ac_resource_db
      "The filename of the application database"
end

let () = begin
  _bootstrap := begin fun () ->
    _db := Some(Lemonade_Sqlite.opendb (Configuration.filename()))
  end;
  _shutdown := begin fun () ->
    match !_db with
    | Some(db) -> Lemonade_Sqlite.closedb db
    | None -> ()
  end;
end


let initdb () =
  withdb (Anvil_Database.initdb module_lst)

let importdb path =
  withdb (Anvil_Database.importdb module_lst path)

let files index =
  let get f prop db =
    f (Anvil_Index.(find prop index)) db
  in
  withdb begin fun db ->
    get Anvil_Build.files Anvil_Index.build db
    @ get Anvil_License.files Anvil_Index.license db
  end

let env index =
  withdb (Anvil_Environment.make index)

let list_templates () =
  withdb Anvil_Template.list

let template name =
  withdb (Anvil_Template.contents name)
