(* Anvil_Database -- Handle the database

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

open Printf
open Lemonade_Sqlite

module type S =
sig
  val initdb : string
  val importdb : string -> handle -> unit
end

let run_unsafe m =
  match run m with
  | Success(x) -> x
  | Error(name, mesg) -> ksprintf failwith "%s: %s" name mesg

let withdb filename f =
  Lemonade_Sqlite.withdb filename f

let initdb lst db =
  let loop m =
    let module M = (val m : S) in
    run_unsafe (exec (statement M.initdb) db)
  in
  List.iter loop lst

let importdb lst path db =
  let loop m =
    let module M = (val m : S) in
    M.importdb path db
  in
  List.iter loop lst

(* Scanning directories for import jobs *)

let file_contents ?workdir filename =
  Rashell_Command.(exec_utility (command ?workdir ("", [| "cat"; filename |])))

let find workdir path =
  Rashell_Posix.(find ~workdir (Has_kind S_REG) [path])
  |> Lwt_stream.map_s
    (function filename ->
      let open Lwt.Infix in
      file_contents ~workdir filename
      >>= fun contents -> Lwt.return (filename, contents))
  |> Lwt_stream.to_list
  |> Lwt_main.run


(* Simplified queries *)

let rows_to_list convert rows =
  let open Lemonade_Sqlite.Infix in
  S.map convert rows
  |> S.to_list
  >|= dist
  |> join
  |> run_unsafe

let get ?binding sql convert db =
  let open Lemonade_Sqlite.Infix in
  query ?binding (statement sql) db
  |> one
  >>= convert
  |> run_unsafe

let query ?binding sql convert db =
  query ?binding (statement sql) db
  |> rows_to_list convert
