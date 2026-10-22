-- | What gets built from which sources. Each kind of content has its own
-- rule set below; 'rules' wires them together.
module Site.Rules
  ( rules
  ) where

import Data.List (sortOn)
import Data.Maybe (isJust)
import Data.Time (UTCTime)
import Hakyll
import Site.Context (itemContext, postContext, projectContext, siteContext)
import Site.Pandoc (markdownCompiler)
import Site.Routes (parsePostName, postRoute, prettyRoute, rootRoute, staticRoute)
import System.FilePath (takeBaseName)
import Text.Read (readMaybe)

-- | All rules; @built@ is the build time shown in the footer.
rules :: UTCTime -> Rules ()
rules built = do
  -- What every page can use: its own fields plus the site-wide ones.
  let base = itemContext <> siteContext built
  templates
  staticFiles
  stylesheet
  scripts
  pages base
  posts base
  projects base

--------------------------------------------------------------------------------
-- Assets

templates :: Rules ()
templates = match "templates/**" $ compile templateBodyCompiler

-- | Everything under @static/@ is copied verbatim to the site root.
staticFiles :: Rules ()
staticFiles = match "static/**" $ do
  route staticRoute
  compile copyFileCompiler

-- | The stylesheets, concatenated in this order into one minified
-- @/css/main.css@. Add new files here.
stylesheets :: [Identifier]
stylesheets = ["css/theme.css", "css/base.css", "css/syntax.css"]

stylesheet :: Rules ()
stylesheet = do
  match (fromList stylesheets) $ compile getResourceString
  create ["css/main.css"] $ do
    route idRoute
    compile $ do
      sheets <- traverse loadBody stylesheets
      makeItem (compressCss (concat sheets :: String))

scripts :: Rules ()
scripts = match "js/*.js" $ do
  route idRoute
  compile copyFileCompiler

--------------------------------------------------------------------------------
-- Pages

-- | @content/*.md@ become root-level files (@/index.html@, @/404.html@);
-- @content/pages/*.md@ become directories (@/teaching/@).
pages :: Context String -> Rules ()
pages base = do
  match "content/*.md" $ do
    route rootRoute
    compile $ markdownCompiler >>= layout "templates/page.html" base
  match "content/pages/*.md" $ do
    route (prettyRoute "")
    compile $ markdownCompiler >>= layout "templates/page.html" base

--------------------------------------------------------------------------------
-- Blog

postsPattern :: Pattern
postsPattern = "content/posts/*.md"

posts :: Context String -> Rules ()
posts base = do
  match postsPattern $ do
    route postRoute
    compile $ do
      name <- takeBaseName . toFilePath <$> getUnderlying
      either fail (const (pure ())) (parsePostName name)
      markdownCompiler >>= layout "templates/post.html" (postContext <> base)

  create ["blog/index.html"] $ do
    route idRoute
    compile $ do
      entries <- recentFirst =<< loadAll postsPattern
      let ctx =
            constField "title" "Blog"
              <> listField "posts" postContext (pure entries)
              <> base
      makeItem "" >>= layout "templates/blog.html" ctx

--------------------------------------------------------------------------------
-- Projects

projectsPattern :: Pattern
projectsPattern = "content/projects/*.md"

-- | Projects with a @link@ only appear in the list on @/projects/@; the others
-- also get a page of their own.
projects :: Context String -> Rules ()
projects base = do
  matchMetadata projectsPattern (not . hasLink) $ do
    route (prettyRoute "projects")
    compile $ markdownCompiler >>= layout "templates/page.html" base
  matchMetadata projectsPattern hasLink $
    compile (makeItem ("" :: String))

  create ["projects/index.html"] $ do
    route idRoute
    compile $ do
      entries <- byOrder =<< loadAll projectsPattern
      let ctx =
            constField "title" "Projects"
              <> listField "projects" projectContext (pure entries)
              <> base
      makeItem "" >>= layout "templates/projects.html" ctx
  where
    hasLink = isJust . lookupString "link"

-- | Sort items by their integer @order@ front matter field, ascending.
byOrder :: [Item a] -> Compiler [Item a]
byOrder items = map snd . sortOn fst <$> traverse withOrder items
  where
    withOrder item = do
      let ident = itemIdentifier item
      raw <- getMetadataField' ident "order"
      case readMaybe raw :: Maybe Int of
        Just n -> pure (n, item)
        Nothing -> fail ("`order` must be an integer in " <> toFilePath ident <> ", got: " <> raw)

--------------------------------------------------------------------------------
-- Helpers

-- | Render an item with a content template, then wrap it in the site shell.
layout :: Identifier -> Context String -> Item String -> Compiler (Item String)
layout template ctx item =
  loadAndApplyTemplate template ctx item
    >>= loadAndApplyTemplate "templates/default.html" ctx
