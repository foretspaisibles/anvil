(* Anvil_Configuration -- Compile time configuration

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

let ( / ) =
  Filename.concat

let ac_package =
  "anvil"

let ac_dir_prefix =
  "/usr/local"

let ac_dir_exec_prefix =
  "/usr/local"

let ac_dir_bindir =
  "/usr/local/bin"

let ac_dir_sbindir =
  "/usr/local/sbin"

let ac_dir_libexecdir =
  "/usr/local/libexec" / ac_package

let ac_dir_datarootdir =
  "/usr/local/share"

let ac_dir_datadir =
  "/usr/local/share"/ ac_package

let ac_dir_sysconfdir =
  "/usr/local/etc"

let ac_dir_sharedstatedir =
  "/usr/local/com" / ac_package

let ac_dir_localstatedir =
  "/usr/local/var" / ac_package

let ac_dir_runstatedir =
  "/usr/local/var" / "run"

let ac_dir_docdir =
  "/usr/local/share/doc/anvil"

let ac_dir_infodir =
  "/usr/local/share/info"

let ac_dir_libdir =
  "/usr/local/lib"

let ac_dir_localedir =
  "/usr/local/share/locale"

let ac_path_git =
  "/usr/bin/git"

let ac_resource_db =
  "/usr/local/var" / "db" / ac_package
