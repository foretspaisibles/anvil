(* Anvil_Git -- Git operations

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

open Printf
open Rashell_Command
open Anvil_Configuration

let debug =
  ref false

let supervise t =
  try Lwt_main.run t
  with Error(cmd, status, stderr) ->
    (if !debug then Format.eprintf "Debug: %a\n%!" pp_print_command cmd);
    ksprintf failwith "git: %s" (chomp stderr)

let git_command ?workdir argv =
  command ?workdir (ac_path_git, Array.append [| ac_path_git |] argv)

let utility ?workdir argv =
  supervise (exec_utility ~chomp:true (git_command ?workdir argv))

let query ?workdir argv =
  supervise (Lwt_stream.to_list (exec_query (git_command ?workdir argv)))

let topleveldir ?workdir () =
  utility ?workdir [| "rev-parse"; "--show-toplevel" |]

let config_find ?workdir key =
  let t =
    exec_utility ~chomp:true (git_command ?workdir [| "config"; key |])
  in
  supervise t

let config_add ?workdir key value =
  let t =
    let open Lwt.Infix in
    exec_utility ~chomp:true (git_command ?workdir [| "config"; key; value |])
    >|= ignore
  in
  supervise t

let init ?workdir repo =
  let t =
    let open Lwt.Infix in
    exec_utility ~chomp:true (git_command ?workdir [| "init"; repo |])
    >|= ignore
  in
  supervise t
