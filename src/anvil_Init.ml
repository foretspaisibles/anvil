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
    (module Anvil_Build : Anvil_Database.S)
  ]

  let initdb () =
    Anvil_Database.withdb (Configuration.filename())
      (Anvil_Database.initdb module_lst)

  let importdb path =
    Anvil_Database.withdb (Configuration.filename())
      (Anvil_Database.importdb module_lst path)

  let files index =
    let get f prop db =
      f (Anvil_Index.(find prop index)) db
    in
    Anvil_Database.withdb (Configuration.filename()) begin fun db ->
      get Anvil_Build.files Anvil_Index.build db
      @ get Anvil_License.files Anvil_Index.license db
    end

  let blob env =
    let _license_ident = "LICENSE" in
    if List.mem_assoc _license_ident env then
      let license_blob =
        Anvil_Database.withdb (Configuration.filename()) begin fun db ->
          Anvil_License.blob (List.assoc _license_ident env) db
        end
      in
      (_license_ident, Rashell_Command.chomp license_blob)
      :: (List.remove_assoc _license_ident env)
    else
      env
end


module Component_Main =
struct

  let comp =
    Application.Component.make
      ~name:"main"
      ~description:"The main component of our application"
      ()

  module Configuration =
  struct
    open Application.Configuration

    let _default_action =
      "populate"

    let action =
      make_string comp
        "#action" _default_action
        "Create a new repository."

    let initdb =
      make_string comp ~optarg:"initdb" ~flag:'I'
        "#action" _default_action
        "Initialise the database instead of performing the normal action."

    let importdb =
      make_string comp ~optarg:"importdb" ~flag:'J'
        "#action" _default_action
        "Import data in the database instead of performing the normal action."

    let convert =
      make_string comp ~optarg:"convert" ~flag:'C'
        "#action" _default_action
        "Convert an existing repository instead of performing the normal action."
  end

  let env index =
    let now = Rashell_Timestamp.now() in
    let year =
      1900 + (Rashell_Timestamp.to_unix now).Unix.tm_year
    in
    Component_Database.blob
      (("TIMESTAMP", Rashell_Timestamp.to_string now)
       :: ("YEAR", string_of_int year)
       :: (Anvil_Index.env index))

  let convert = function
    | [repo] ->
        Anvil_Index.output repo (Anvil_Wizard.run())
    | [] -> failwith "convert: Missing argument."
    | _ -> failwith "convert: Please convert repositories one at a time."

  let populate = function
    | [ repo ] ->
        let index = Anvil_Wizard.run () in
        Anvil_Git.init repo;
        Anvil_File.populate
          (env index)
          repo
          (Component_Database.files index);
        Anvil_Index.output repo index
    | _ -> failwith "init: Please initialise repositories one at a time."


  let importdb arglist =
    List.iter Component_Database.importdb arglist

  let initdb = function
    | [] -> Component_Database.initdb ()
    | hd :: _ -> Printf.ksprintf failwith "Usage: %s: Unexpected argument." hd
end


let main arglist =
  let open Component_Main in
  let f =
    match Configuration.action () with
    | "populate" -> populate
    | "convert" -> convert
    | "importdb" -> importdb
    | "initdb" -> initdb
    | whatever ->
        Printf.ksprintf failwith "%s: Unrecognised action." whatever
  in
  f arglist



let () =
  Application.run "anvil"
    "[-h]"
    "Initialise a project"
    ~configuration:Application.Configuration.Command_line
    main
