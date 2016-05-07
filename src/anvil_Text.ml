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
  regexp "\\${ANVIL_\\([a-zA-Z0-9_]*\\)}"

let license_re ident =
  ksprintf regexp "^\\(.*\\)\\${ANVIL_%s}\\(.*\\)$" ident

let newline_re =
  regexp "\n"

let expand_blob prefix suffix blob =
  let f m =
    sprintf "%s%s%s" suffix (matched_string m) prefix
  in
  global_substitute newline_re f blob

let spaces s =
  String.(make (length s) ' ')

let replace_license ident blob s =
  let f m =
    match (matched_group 1 s), (matched_group 2 s) with
    | prefix, ((" *)" | " */") as suffix )->
        prefix ^ (expand_blob (spaces prefix) "" blob) ^ suffix
    | prefix, suffix ->
        prefix ^ (expand_blob prefix suffix blob) ^ suffix
  in
  global_substitute (license_re ident) f s

let replace_text env s =
  let f m =
    try List.assoc (matched_group 1 s) env
    with _ -> (matched_string m)
  in
  global_substitute variable_re f s
