module Main (main) where

import Data.Time   (getCurrentTime)
import Hakyll      (hakyllWith)
import Site.Config (hakyllConfig)
import Site.Rules  (rules)

main :: IO ()
main = getCurrentTime >>= hakyllWith hakyllConfig . rules
