(* Anvil_Template -- Handling templates

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

module Sqlite =
  Lemonade_Sqlite

open Printf
open Str
open Sqlite
open Sqlite.Infix

let paragraph_re =
  regexp "\n\n"

let header_re =
  regexp "^\\([A-Za-z0-9-]+\\): *\\(.*\\)$"

let header_split s =
  try Pervasives.ignore(search_forward paragraph_re s 0);
    (string_before s (match_beginning()),
     string_after s (match_end()))
  with Not_found -> ("", s)

let headers s =
  let rec loop ax i =
    let next =
      try Some(search_forward header_re s i)
      with Not_found -> None
    in
    match next with
    | Some(i) -> loop ((String.lowercase (matched_group 1 s), matched_group 2 s) :: ax) (i+1)
    | None -> ax
  in
  loop [] 0

let description assoc =
  try List.assoc "description" assoc
  with Not_found -> ""

let run_unsafe m =
  match run m with
  | Success(x) -> x
  | Error(name, mesg) -> ksprintf failwith "%s: %s" name mesg

let string_split delim s =
  let q = Queue.create () in
  let b = Buffer.create 100 in
  let add () =
    (Queue.add (Buffer.contents b) q; Buffer.clear b)
  in
  let loop c =
    if c = delim then
      add ()
    else
      Buffer.add_char b c
  in
  String.iter loop s;
  add ();
  List.rev(Queue.fold (fun ax item -> item :: ax) [] q)

let initdb = {sql|CREATE TABLE template_index (
  name TEXT PRIMARY KEY,
  description TEXT
);
CREATE TABLE template_file (
  name TEXT,
  filename TEXT,
  contents BLOB
)|sql}

let importdb_job workdir =
  let filename_split name =
    string_split '/' name
  in
  let convert =
    (function
      | [ "."; "template"; template ] -> template
      | whatever ->
          ksprintf failwith "Anvil_Template.importdb: %s: %s: Bad directory structure."
            workdir
            (String.concat "/" whatever))
  in
  let list_map_first f lst =
    List.map (fun (x, y) -> (f x, y)) lst
  in
  let contents_split (a, c) =
    let (envelope, contents) = header_split c in
    (a, headers envelope, contents)
  in
  Anvil_Database.find workdir "./template"
  |> list_map_first filename_split
  |> list_map_first convert
  |> List.map contents_split

let importdb workdir db =
  let bindings lst =
    bindings [
      "$template", (fun (template, _, _) -> TEXT(template));
      "$contents", (fun (_ , _, contents) -> BLOB(contents));
      "$description", (fun (_ , header, _) -> TEXT(description header));
    ] lst
  in
  let program lst =
    S.concat (S.of_list [
        bindings_apply
          (bindings (S.of_list lst))
          (statement "INSERT OR REPLACE INTO template_index (name, description) VALUES ($template, $description)");

        bindings_apply
          (bindings (S.of_list lst))
          (statement "DELETE FROM template_file WHERE name = $template; INSERT INTO template_file (name, contents) VALUES($template, $contents)");
      ])
  in
  Anvil_Database.insert begin
    importdb_job workdir
    |> program
  end db

let list db =
  Anvil_Database.query
    "SELECT name, description FROM template_index"
    (function
      | [| TEXT(name); TEXT(description) |] -> return (name, description)
      | _ -> error("Anvil_Template.list","Protocol mismatch."))
    db

let contents name db =
  Anvil_Database.get ~binding:["$name", TEXT(name)]
    "SELECT contents FROM template_file WHERE name = $name"
    (function
      | [| BLOB(contents) |] -> return contents
      | _ -> error("Anvil_Template.files","Protocol mismatch."))
    db
