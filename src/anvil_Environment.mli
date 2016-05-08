(* Anvil_Environment -- Compute the environment for variable expansion

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

type t = (string * string) list
(** The type of environments for variable expansion. *)

val make : Anvil_Index.t -> Lemonade_Sqlite.handle -> t
(** Compute the environment for variable expansion associated to an index. *)
