(* ${ANVIL_PACKAGE:C}_Configuration -- Compile time configuration

   ${ANVIL_LICENSE_BLOB} *)

(** {6 Package description} *)

val ac_package : string
(** The name of the software package. *)

val ac_version : string
(** The version of the software package. *)


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
