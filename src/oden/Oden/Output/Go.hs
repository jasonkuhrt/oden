module Oden.Output.Go where

import           Data.List
import           Text.PrettyPrint

import           Oden.Go as G
import           Oden.Output

instance OdenOutput PackageImportError where
  outputType _ = Error
  name (PackageImportError _ _)      = "Go.PackageImportError"
  header (PackageImportError n _) s    = text "Failed to import Go package:"
                                          <+> strCode s (intercalate "/" n)
  details (PackageImportError _ err) _    = text err

instance OdenOutput UnsupportedTypesWarning where
  outputType _  = Warning
  name _        = "Go.UnsupportedTypesWarning"
  header u s    = text "Some definitions could not be imported from package" <+> strCode s (intercalate "/" (pkg u)) <> colon
  details u s   = vcat (map formatMessage (messages u))
    where formatMessage (n, msg) = strCode s n
                                   <+> parens (text msg <+> text "are not supported")
