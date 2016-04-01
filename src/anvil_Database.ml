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
