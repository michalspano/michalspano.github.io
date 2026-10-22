-- | Where each kind of source file ends up in the generated site.
--
-- Pages are written to @\<dir\>/index.html@ so that they are served at the
-- clean URL @/\<dir\>/@.
module Site.Routes
  ( PostName (..)
  , parsePostName
  , rootRoute
  , prettyRoute
  , postRoute
  , staticRoute
  , cleanUrl
  ) where

import Data.Char (isDigit)
import Hakyll (Routes, customRoute, toFilePath)
import System.FilePath (dropFileName, makeRelative, takeBaseName, takeFileName, (<.>), (</>))

-- | The parts of a post's file name, @YYYY-MM-DD-slug.md@, that its URL uses.
data PostName = PostName
  { postYear :: String
  , postSlug :: String
  }

-- | Parse a post's base name, e.g. @2023-02-14-ActInSpace-finals@.
parsePostName :: String -> Either String PostName
parsePostName name = case splitAt 11 name of
  ([y1, y2, y3, y4, '-', m1, m2, '-', d1, d2, '-'], slug@(_ : _))
    | all isDigit [y1, y2, y3, y4, m1, m2, d1, d2] ->
        Right (PostName [y1, y2, y3, y4] slug)
  _ -> Left ("post file names must look like YYYY-MM-DD-slug.md, got: " <> name <> ".md")

-- | @content/index.md@ ↦ @index.html@ and @content/404.md@ ↦ @404.html@.
rootRoute :: Routes
rootRoute = customRoute $ \ident -> takeBaseName (toFilePath ident) <.> "html"

-- | @prettyRoute "projects"@ maps @content/projects/dotfiles.md@ ↦
-- @projects/dotfiles/index.html@; @prettyRoute ""@ maps
-- @content/pages/teaching.md@ ↦ @teaching/index.html@.
prettyRoute :: FilePath -> Routes
prettyRoute dir = customRoute $ \ident ->
  dir </> takeBaseName (toFilePath ident) </> "index.html"

-- | @content/posts/2023-02-14-ActInSpace-finals.md@ ↦
-- @blog/2023/ActInSpace-finals/index.html@, the URL scheme of the old site.
--
-- Malformed names fall back to @blog/\<name\>/index.html@; the post compiler
-- rejects them with a readable error, so they never reach the output.
postRoute :: Routes
postRoute = customRoute $ \ident ->
  let name = takeBaseName (toFilePath ident)
   in case parsePostName name of
        Right post -> "blog" </> postYear post </> postSlug post </> "index.html"
        Left _ -> "blog" </> name </> "index.html"

-- | @static/assets/docs/a.pdf@ ↦ @assets/docs/a.pdf@.
staticRoute :: Routes
staticRoute = customRoute (makeRelative "static" . toFilePath)

-- | Drop a trailing @index.html@ so links point at directories:
-- @/blog/index.html@ ↦ @/blog/@.
cleanUrl :: String -> String
cleanUrl url
  | takeFileName url == "index.html" = dropFileName url
  | otherwise = url
