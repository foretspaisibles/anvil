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
type t = {
  package: string;
  (** Package name, this should be a valid Unix filename. *)

  vendorname: string;
  (** Vendor name for the package. *)

  author: string;
  (** Author Name *)

  officer: string;
  (** GPG identity of the release officer *)

  url: string;
  (** Package URL *)

  license: string;
  (** License name *)
}

val from_repository : string -> t option
(** Retrieve the index information for the package having a working
    copy located at the given path. *)

val pp_print_index : Format.formatter -> t -> unit
(** Pretty-printer for index information. *)
