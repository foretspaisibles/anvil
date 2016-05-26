(* Anvil_File -- File operation

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

let debug label f x =
  Format.fprintf Format.str_formatter "DEBUG: %s: %a"
    label f x;
  Printf.eprintf "%s\n%!" (Format.flush_str_formatter ())

let variable_re =
  regexp "\\${\\([a-zA-Z0-9_]*\\)}"

let _perm_dir = 0o770
let _perm_file = 0o660
let _license_ident = "LICENSE"
let _license_blob_ident = "LICENSE_BLOB"

let install_dir path =
  Unix.mkdir path _perm_dir

let install_file path contents =
  let c = open_out_gen [
      Open_wronly;
      Open_creat;
      Open_trunc;
      Open_excl;
      Open_text;
    ] _perm_file path
  in
  output_string c contents;
  close_out c


let replace env contents =
  let maybe_blob =
    try Some(List.assoc _license_blob_ident env)
    with Not_found -> None
  in
  let contents =
    match maybe_blob with
    | Some(blob) -> Anvil_Text.replace_license _license_blob_ident blob contents
    | None -> contents
  in
  Anvil_Text.replace_text env contents

let string_split delim s =
  let q = Queue.create () in
  let b = Buffer.create 100 in
  let add () =
    (Queue.add (Buffer.contents b) q; Buffer.clear b)
  in
  let loop c =
    if c = delim then
      add ()
    else
      Buffer.add_char b c
  in
  String.iter loop s;
  add ();
  List.rev(Queue.fold (fun ax item -> item :: ax) [] q)

let populate env rootdir filespec =
  let maybe_mkdir path =
    try
      if Sys.is_directory path then
        ()
      else
        ksprintf failwith
          "%s: Cannot create (file already exists)."
          path
    with Sys_error(_) -> install_dir path
  in
  let maybe_mkparentdir toplevel path =
    let rec loop ax = function
      | [] | [ _ ] -> ()
      | hd :: tl ->
          let next = Filename.concat ax hd in
          maybe_mkdir next;
          loop next tl
    in
    loop toplevel (string_split '/' path)
  in
  let mkfile (path, contents) =
    maybe_mkparentdir rootdir path;
    install_file (Filename.concat rootdir path) (replace env contents)
  in
  let expand_paths (path, contents) =
    (Anvil_Text.replace_text env path, contents)
  in
  List.iter mkfile (List.map expand_paths filespec)
