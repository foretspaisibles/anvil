(* Anvil_Configuration -- Compile time configuration

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

(** {6 Package description} *)

val ac_package : string
(** The name of the software package. *)


(** {6 Directories} *)

val ac_dir_prefix : string
(** Installation prefix for the package. *)

val ac_dir_exec_prefix : string
(** Installation prefix for binaries of the pacakge. *)

val ac_dir_bindir : string
(** Directory for package executable programs that users can run. *)

val ac_dir_sbindir : string
(** Directory for package executable programs used by sysadmins. *)

val ac_dir_libexecdir : string
(** Directory for package executable programs to be run by other programs. *)

val ac_dir_datarootdir : string
(** Root for read-only architecture-independent package data files. *)

val ac_dir_datadir : string
(** Directory for read-only architecture-independent package data files. *)

val ac_dir_sysconfdir : string
(** Directory for read-only package data files that pertain to a single host. *)

val ac_dir_sharedstatedir : string
(** Directory for runtime architecture-independent package data files. *)

val ac_dir_docdir : string
(** Directory for documentation files (other than Info) for package. *)

val ac_dir_localstatedir : string
(** Directory for runtime host-specific package data files. *)

val ac_dir_runstatedir : string
(** Directory for volatile host-specific package data files. *)

val ac_dir_infodir : string
(** Directory for the Info files for package. *)

val ac_dir_libdir : string
(** Directory for package object files and libraries of object code. *)

val ac_dir_localedir : string
(** Directory for locale-specific message catalogs for the package. *)


(** {6 Path to utilities} *)

val ac_path_git : string
(** The compile-time path to the git program. *)


(** {6 Resources} *)

val ac_resource_db : string
(** The compile-time path to the database. *)
