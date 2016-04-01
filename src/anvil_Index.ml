(* Anvil_Index -- Index information for a project

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

module Maybe =
  Lemonade_Maybe

type t = {
  package: string; (* Package name *)
  vendorname: string; (* Vendor name *)
  author: string; (* Author Name *)
  officer: string; (* GPG identity of the release officer *)
  url: string; (* Package URL *)
  license: string; (* License name *)
}

let from_repository workdir =
  let get key =
    match Anvil_Git.config ~workdir ("anvil."^key) with
    | Some(x) -> x
    | None -> raise Exit
  in try Some {
    package = get "package";
    vendorname = get "vendorname";
    author = get "author";
    officer = get "officer";
    url = get "url";
    license = get "license";
    }
  with Exit -> None

let pp_print_index fmt index =
  Format.fprintf fmt
    "{@[@ package = %S;@ vendorname = %S;@ author = %S;@ officer = %S;@ url = %S;@ licence = %S;@]}"
    index.package
    index.vendorname
    index.author
    index.officer
    index.url
    index.license
