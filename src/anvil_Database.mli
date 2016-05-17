(* Anvil_Database -- Handle the database

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

(** The module type of modules initialising and importing to the database. *)
module type S =
sig
  val initdb : string
  val importdb : string -> Lemonade_Sqlite.handle -> unit
end

val run_unsafe : 'a Lemonade_Sqlite.t -> 'a
(** Run the given sqlite monad, converting errors to exceptions. *)

val withdb : string -> (Lemonade_Sqlite.handle -> 'a) -> 'a
(** Run the given function on an opened handle. *)

val initdb : (module S) list -> Lemonade_Sqlite.handle -> unit
(** Initialise the database for the given modules. *)

val importdb : (module S) list -> string -> Lemonade_Sqlite.handle -> unit
(** [importdb modules path db] import data found in [path] in the [db]
    for the given [modules]. *)

val find : string -> string -> (string * string) list
(** [find workdir path] return the list of files under [path] paired with
    their contents. *)

val query : ?binding:Lemonade_Sqlite.binding ->
  string -> (Lemonade_Sqlite.row -> 'a Lemonade_Sqlite.t) -> Lemonade_Sqlite.handle -> 'a list
(** [query convert sql db] retrieve the list matching the request [sql]. *)

val get : ?binding:Lemonade_Sqlite.binding ->
  string -> (Lemonade_Sqlite.row -> 'a Lemonade_Sqlite.t) -> Lemonade_Sqlite.handle -> 'a
(** [get convert sql db] retrieve the item matching the request
    [sql]. An error is triggered if several items are returned from the database. *)

val insert : Lemonade_Sqlite.statement Lemonade_Sqlite.S.t -> Lemonade_Sqlite.handle -> unit
(** [insert program db] execute in sequence the statements provided by [program]. *)
