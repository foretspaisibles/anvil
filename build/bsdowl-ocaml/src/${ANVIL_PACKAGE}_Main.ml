(* ${ANVIL_PACKAGE:C}_Main -- Main program module

   ${ANVIL_LICENSE_BLOB} *)

open Printf
open ${ANVIL_PACKAGE:C}_Configuration

let () =
  printf "This is %s v%s\n" ac_package ac_version
