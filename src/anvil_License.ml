(* Anvil_License -- Handling licenses

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
open Sqlite
open Sqlite.Infix

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

let initdb = {sql|CREATE TABLE license_index (
  name TEXT PRIMARY KEY,
  description TEXT
);
CREATE TABLE license_file (
  name TEXT,
  filename TEXT,
  contents BLOB
);
CREATE TABLE license_blob (
  name TEXT PRIMARY KEY,
  blob BLOB
)|sql}

let importdb_job workdir =
  let split name =
    string_split '/' name
  in
  let convert =
    (function
      | [ "."; "license"; license; filename ] ->
          (license, filename)
      | whatever ->
          ksprintf failwith "Anvil_License.importdb: %s: %s: Bad directory structure."
            workdir
            (String.concat "/" whatever))
  in
  let list_map_first f lst =
    List.map (fun (x, y) -> (f x, y)) lst
  in
  let recombine ((a,b),c) =
    (a,b,c)
  in
  Anvil_Database.find workdir "./license"
  |> list_map_first split
  |> list_map_first convert
  |> List.map recombine

let importdb workdir db =
  let has_filename name (_, filename, _) =
    filename = name
  in
  let bindings lst =
    bindings [
      "$license", (fun (license, _, _) -> TEXT(license));
      "$filename", (fun (_, filename, _) -> TEXT(filename));
      "$contents", (fun (_ , _, contents) -> BLOB(contents));
      "$description", (fun (_ , _, contents) -> TEXT(Rashell_Command.chomp contents));
    ] lst
  in
  let program lst =
    S.concat (S.of_list [
        bindings_apply
          (bindings (S.filter (has_filename "blob") (S.of_list lst)))
          (statement "INSERT OR REPLACE INTO license_blob (name, blob) VALUES ($license, $contents)");

        bindings_apply
          (bindings (S.filter (has_filename "description") (S.of_list lst)))
          (statement "INSERT OR REPLACE INTO license_index (name, description) VALUES ($license, $description)");

        bindings_apply
          (bindings (S.filter (fun x -> not(has_filename "description" x || has_filename "blob" x)) (S.of_list lst)))
          (statement "DELETE FROM license_file WHERE name = $license AND filename = $filename; INSERT INTO license_file (name, filename, contents) VALUES($license, $filename, $contents)");

      ])
  in
  Anvil_Database.insert begin
    importdb_job workdir
    |> program
  end db

let list db =
  Anvil_Database.query
    "SELECT name FROM license_index"
    (function
      | [| TEXT(name) |] -> return name
      | _ -> error("Anvil_License.list","Protocol mismatch."))
    db

let files name db =
  Anvil_Database.query ~binding:["$name", TEXT(name)]
    "SELECT filename, contents FROM license_file WHERE name = $name"
    (function
      | [| TEXT(filename); BLOB(contents) |] -> return(filename, contents)
      | _ -> error("Anvil_License.files","Protocol mismatch."))
    db

let blob name db =
  Anvil_Database.get ~binding:["$name", TEXT(name)]
    "SELECT blob FROM license_blob WHERE name = $name"
    (function
      | [| BLOB(blob); |] -> return blob
      | _ -> error("Anvil_License.blob","Protocol mismatch."))
    db
