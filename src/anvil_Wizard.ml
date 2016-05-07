(* Anvil_Wizard -- Ask the user for index information for a project

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

let _run () =
  let ask prop =
    Printf.printf "%s: %!" prop.Anvil_Index.display_name;
    read_line ()
  in
  Anvil_Index.make ask

let run () =
  let ask prop =
    try List.assoc prop.Anvil_Index.name [
      "package", "xxx";
      "vendorname", "XxX";
      "author", "A. U. Thor";
      "officer", "author@gpg.me";
      "url", "http://gpg.me";
      "build", "bsdowl-autoconf";
      "license", "CeCILL-B";
      ]
    with Not_found ->
      Printf.ksprintf failwith
        "Anvil_Wizard: %s: Not found." prop.Anvil_Index.name
  in
  Anvil_Index.make ask
