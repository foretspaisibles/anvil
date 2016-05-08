(* Anvil_Environment -- Compute the environment for variable expansion

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

type t = (string * string) list

let maybe_add_blob env db =
  let _license_ident = "LICENSE" in
  let _license_blob_ident = "LICENSE_BLOB" in
  if List.mem_assoc _license_ident env then
    let license_blob =
      Anvil_License.blob (List.assoc _license_ident env) db
    in
    (_license_blob_ident, Rashell_Command.chomp license_blob) :: env
  else
    env

let make index db =
  let now = Rashell_Timestamp.now() in
  let year =
    1900 + (Rashell_Timestamp.to_unix now).Unix.tm_year
  in
  maybe_add_blob
    (("TIMESTAMP", Rashell_Timestamp.to_string now)
     :: ("YEAR", string_of_int year)
     :: (Anvil_Index.env index))
    db
