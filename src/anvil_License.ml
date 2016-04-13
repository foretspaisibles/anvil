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

let initdb = {sql|DROP TABLE IF EXISTS license_index;
CREATE TABLE license_index (
  name TEXT PRIMARY KEY,
  description TEXT
);
DROP TABLE IF EXISTS license_file;
CREATE TABLE license_file (
  name TEXT,
  filename TEXT,
  contents BLOB
);
DROP TABLE IF EXISTS license_blob;
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
  let actually_insert (license, filename, contents) () =
    exec ~binding:[
      "$license", TEXT(license);
      "$filename", TEXT(filename);
      "$contents", BLOB(contents);
      "$description", TEXT(Rashell_Command.chomp contents);
    ] (statement (
        if filename = "blob" then
          "INSERT OR REPLACE INTO license_blob (name, blob) VALUES ($license, $contents)"
        else if filename = "description" then
          "INSERT OR REPLACE INTO license_index (name, description) VALUES ($license, $description)"
        else
          "DELETE FROM license_file WHERE name = $license AND filename = $filename; INSERT INTO license_file (name, filename, contents) VALUES($license, $filename, $contents)"))
      db
  in
  importdb_job workdir
  |> S.of_list
  |> (fun s -> S.fold (fun x m -> bind m (actually_insert x)) s (return ()))
  |> join
  |> run_unsafe

let to_list convert rows =
  S.map convert rows
  |> S.to_list
  >|= dist
  |> join
  |> run_unsafe

let list db =
  let convert = function
    | [| TEXT(name) |] -> return name
    | _ -> error("Anvil_License.list","Protocol mismatch.")
  in
  query (statement "SELECT name FROM license_index") db
  |> to_list convert

let files name db =
  let convert = function
    | [| TEXT(filename); BLOB(contents) |] -> return(name, contents)
    | _ -> error("Anvil_License.files","Protocol mismatch.")
  in
  query ~binding:["name", TEXT(name)]
    (statement "SELECT (filename, content) FROM license_file WHERE name = $name")
    db
  |> to_list convert

let blob name db =
  let convert = function
    | [| BLOB(blob); |] -> return blob
    | _ -> error("Anvil_License.blob","Protocol mismatch.")
  in
  query ~binding:["name", TEXT(name)]
    (statement "SELECT blob FROM license_blob WHERE name = $name")
    db
  |> one
  >>= convert
  |> run_unsafe
