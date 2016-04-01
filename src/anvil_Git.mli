(* Anvil_Git -- Git operations

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

val topleveldir : ?workdir:string -> unit -> string
(** Show the absolute path of the top-level directory. *)

val config : ?workdir:string -> string -> string option
(** Retrieve the value associated to the configuration key. *)
