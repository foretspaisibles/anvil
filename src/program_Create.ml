(* Program_Creat -- Instantiate template

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)
open Printf

module Application =
  Gasoline_Plain_Application

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
      "instantiate"

    let action =
      make_string comp
        "#action" _default_action
        "Instantiate a template."

    let list =
      make_string comp ~optarg:"list" ~flag:'l'
        "#action" _default_action
        "List available templates."

    let template =
      make_string comp ~flag:'t'
        "#template" "shell"
        "The template to instantiate"

    let description =
      make_string comp ~flag:'D'
        "#description" "I am too lazy to write a proper description"
        "The short description for the file to instantiate"
  end

  let list = function
    | [] ->
        List.iter begin fun (template, description) ->
          printf "%16s  %s\n" template description
        end (Component_Database.list_templates ())
    | hd :: _ -> ksprintf failwith "Usage: %s: Unexpected argument." hd

  let instantiate = function
    | files ->
        let env filename =
          ("DESCRIPTION", Configuration.description())
          :: ("FILENAME", filename)
          :: Component_Database.env (Anvil_Index.input ".")
        in
        let template =
          Component_Database.template (Configuration.template())
        in
        let make filename =
          Anvil_File.populate (env filename) "." [filename, template]
        in
        List.iter make files
end


let main arglist =
  let open Component_Main in
  let f =
    match Configuration.action () with
    | "instantiate" -> instantiate
    | "list" -> list
    | whatever -> ksprintf failwith "%s: Unrecognised action." whatever
  in
  f arglist



let () =
  Application.run "anvil"
    "[-h]"
    "Instantiate a template"
    ~configuration:Application.Configuration.Command_line
    main
