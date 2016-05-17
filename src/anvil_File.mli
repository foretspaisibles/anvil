(* Anvil_File -- File operations

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

(** File operations. *)

val install_dir : string -> unit
(** Create the directory with the given path. Parent directories
    are created as needed. *)

val install_file : string -> string -> unit
(** [install_file path contents] create a file with the given contents. *)

val populate : (string * string) list -> string -> (string * string) list -> unit
(** [populate env rootdir filespec] populate [rootdir] with the list
    of files with their contents specified by [filespec].  The
    environment [env] is used to perform variable expansion in the
    file contents. *)
