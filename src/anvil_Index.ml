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

module PropertyList =
  Map.Make(String)

type t = string PropertyList.t

type prop = {
  name: string;
  display_name: string;
  description: string;
}

let find prop index =
  PropertyList.find prop.name index

let package = {
  name = "package";
  display_name = "Package name";
  description = "The name of the software package, it should be a valid \
                 UNIX file name.";
}

let vendorname = {
  name = "vendorname";
  display_name = "Vendor name";
  description = "The name used to refer to the package, \
                 for instance in the documentation.";
}

let author = {
  name = "author";
  display_name = "Author name";
  description = "The name of the author of the software package, \
                 as used in copyright notices.";
}

let officer = {
  name = "officer";
  display_name = "Release officer";
  description = "The release officer signing the release artefacts, \
                 it must be a valid GPG-key handle.";
}

let url = {
  name = "url";
  display_name = "Package URL";
  description = "The URL of the software package website.";
}

let license = {
  name = "license";
  display_name = "License";
  description = "The license under which the software package is distributed.";
}

let build = {
  name = "build";
  display_name = "Build System";
  description = "The build system used to generate artefacts for the software package.";
}

let description = {
  name = "description";
  display_name = "Short Description";
  description = "The short description used to present the package.";
}

let properties = [
  package;
  vendorname;
  description;
  author;
  officer;
  url;
  license;
  build;
]

let make f =
  List.fold_right
    (fun (k,v) m -> PropertyList.add k v m)
    (List.map (fun prop -> (prop.name, f prop)) properties)
    PropertyList.empty

let input workdir =
  let read prop =
    Anvil_Git.config_find ~workdir ("anvil."^prop.name)
  in
  make read

let output workdir index =
  let write prop =
    Anvil_Git.config_add ~workdir
      ("anvil."^prop.name)
      (find prop index)
  in
  List.iter write properties


let env index =
  List.map
    (fun prop -> (String.uppercase prop.name, find prop index))
    properties

let pp_print_index ff index =
  let pp_print_prop ff prop =
    Format.fprintf ff "@[<hv 1>(%S,@ %S)@]"
      prop.name (find prop index)
  in
  Lemonade_List.pp_print pp_print_prop ff properties
