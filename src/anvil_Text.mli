(* Anvil_Text -- Operations on text variables

   Anvil (https://github.com/michipili/anvil)
   This file is part of Anvil

   Copyright © 2013–2016 Michael Grünewald

   This file must be used under the terms of the CeCILL-B.
   This source file is licensed as described in the file COPYING, which
   you should have received as part of this distribution. The terms
   are also available at
   http://www.cecill.info/licences/Licence_CeCILL-B_V1-en.txt *)

val replace_license : string -> string -> string -> string
(** [replace_license ident blob template] return a copy of [template] where
    the text variable [ident] has been substituted by the [blob]
    contents according to the rules for substituting license blobs. *)

val replace_text : (string * string) list -> string -> string
(** [replace_text env template] expand placeholders from the given
    [template], using the values defined by [env]. *)
