(* Component_Database -- Software component to access the Database

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

val initdb : unit -> unit
(** Initialise the database by creating the appropriate tables. *)

val importdb : string -> unit
(** Import files under the given path into the database. *)

val files : Anvil_Index.t -> (string * string) list
(** [files index] return a list of [file * contents] pairs based on
    the information provided by the index. *)

val env : Anvil_Index.t -> Anvil_Environment.t
(** [env index] return an environment for variable expansion based on
    the information provided by the index. *)

val list_templates : unit -> (string * string) list
(** Return a list of pairs whose first members is a template name and
    a short description for the template. *)

val template : string -> string
(** [template name] return the template called [name]. *)
