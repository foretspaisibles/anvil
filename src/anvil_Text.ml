(* Anvil_Text -- Operations on text variables

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

open Printf
open Str

let variable_re =
  regexp "\\${ANVIL_\\([a-zA-Z0-9_]*\\)\\(:\\([CLUX]*\\)\\)?}"

let license_re ident =
  ksprintf regexp "^\\(.*\\)\\${ANVIL_%s}\\(.*\\)$" ident

let newline_re =
  regexp "\n"

let trailing_spaces_re =
  regexp " *\n"

let expand_blob prefix suffix blob =
  let f m =
    sprintf "%s%s%s" suffix (matched_string m) prefix
  in
  global_substitute newline_re f blob

let spaces s =
  String.(make (length s) ' ')

let remove_trailing_spaces s =
  global_replace trailing_spaces_re "\n" s

let replace_license ident blob s =
  let f m =
    match (matched_group 1 s), (matched_group 2 s) with
    | prefix, ((" *)" | " */") as suffix )->
        prefix ^ (expand_blob (spaces prefix) "" blob) ^ suffix
    | prefix, suffix ->
        prefix ^ (expand_blob prefix suffix blob) ^ suffix
  in
  global_substitute (license_re ident) f s
  |> remove_trailing_spaces

let transformation_table = [
  'C', String.capitalize;
  'L', String.lowercase;
  'U', String.uppercase;
  'X', Filename.chop_extension;
]

let string_fold f s ax =
  let current = ref ax in
  for i = 0 to String.length s - 1 do
    current := f s.[i] !current
  done;
  !current

let transform code s =
  let loop c s =
    let f =
      try List.assoc c transformation_table
      with Not_found -> ksprintf failwith "Anvil_Text: %c: Unknown transformation code." c
    in
    f s
  in
  string_fold loop code s

let replace_text env s =
  let f m =
    let code =
      try matched_group 3 s
      with Not_found -> ""
    in
    try transform code (List.assoc (matched_group 1 s) env)
    with Not_found -> (matched_string m)
  in
  global_substitute variable_re f s
