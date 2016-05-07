(* Anvil_Index -- Index information for a project

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

(** Index record for a project. *)
type t

(** The type of properties. *)
type prop = private {
  name: string;
  display_name: string;
  description: string;
}

val find : prop -> t -> string
(** Retrieve the given property.
@raise Not_found if the property cannot be found. *)

val make : (prop -> string) -> t
(** Make an index value of a function used to determine the
    value of properties. *)

val input : string -> t
(** Retrieve the index information for the package having a working
    copy located at the given path. *)

val output : string -> t -> unit
(** Save the index information for the package having a working copy
    located at the given path. *)

val pp_print_index : Format.formatter -> t -> unit
(** Pretty-printer for index information. *)

(** {6 Properties} *)

val package : prop
(** Package name, this should be a valid Unix filename. *)

val vendorname : prop
(** Vendor name for the package. *)

val author : prop
(** Author Name *)

val officer : prop
(** GPG identity of the release officer *)

val url : prop
(** Package URL *)

val license : prop
(** Package license. *)

val build : prop
(** Build system. *)

val properties : prop list
(** The list of all properties. *)


(** {6 Environment} *)

val env : t -> (string * string) list
(** Prepare an environment out of an index. *)
