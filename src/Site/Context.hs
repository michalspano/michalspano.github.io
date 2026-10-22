-- | The variables available to templates.
--
-- Front matter keys are exposed under their own names (@$title$@,
-- @$description$@, …); site-wide values are prefixed with @site-@.
module Site.Context
  ( siteContext
  , itemContext
  , postContext
  , projectContext
  ) where

import Control.Monad ((<=<))
import Data.List (isInfixOf, isPrefixOf)
import Data.Time (UTCTime, defaultTimeLocale, formatTime)
import Hakyll
  ( Compiler
  , Context
  , Item (..)
  , bodyField
  , boolField
  , constField
  , dateField
  , field
  , fromFilePath
  , getMetadataField
  , getRoute
  , listField
  , listFieldWith
  , metadataField
  , noResult
  , pathField
  , toUrl
  )
import Site.Config (Link (..), SiteConfig (..), siteConfig)
import Site.Routes (cleanUrl)

-- | Fields shared by every page: site settings, navigation, footer data and
-- whether the page needs MathJax. @built@ is the time of the build.
siteContext :: UTCTime -> Context String
siteContext built =
  mconcat
    [ constField "site-title" (siteTitle siteConfig)
    , constField "site-description" (siteDescription siteConfig)
    , constField "site-author" (siteAuthor siteConfig)
    , constField "site-root" (siteRoot siteConfig)
    , maybe mempty (constField "analytics-id") (siteAnalyticsId siteConfig)
    , constField "build-year" (formatTime defaultTimeLocale "%Y" built)
    , constField "build-date" (formatTime defaultTimeLocale "%B %-d, %Y" built)
    , navigationField
    , listField "socials" (linkContext id) (pure (map (labelledItem linkHref) (siteSocials siteConfig)))
    , boolField "math" (usesMath . itemBody)
    ]

-- | An item's body, front matter, path and clean URL. Unlike Hakyll's
-- @defaultContext@, @$title$@ is only set when the front matter sets it.
itemContext :: Context String
itemContext =
  mconcat
    [ bodyField "body"
    , metadataField
    , field "url" routedUrl
    , pathField "path"
    ]

-- | 'itemContext' plus the publication date taken from the file name.
postContext :: Context String
postContext =
  dateField "date" "%B %-d, %Y"
    <> dateField "date-iso" "%Y-%m-%d"
    <> itemContext

-- | 'itemContext' plus @$href$@: the project's @link@ if it has one,
-- otherwise its own page.
projectContext :: Context String
projectContext = field "href" href <> itemContext
  where
    href item = getMetadataField (itemIdentifier item) "link" >>= maybe (routedUrl item) pure

-- | @$navigation$@: the header links, each with @$current$@ set when it points
-- at the page being rendered or one of its ancestors.
navigationField :: Context String
navigationField = listFieldWith "navigation" navContext $ \page -> do
  current <- itemUrl page
  pure [labelledItem (linkHref . fst) (link, isCurrent current link) | link <- siteNavigation siteConfig]
  where
    navContext = linkContext fst <> boolField "current" (snd . itemBody)
    isCurrent current (Link _ href) = case current of
      Just url -> href == url || (href /= "/" && href `isPrefixOf` url)
      Nothing -> False

linkContext :: (a -> Link) -> Context a
linkContext toLink =
  field "label" (pure . linkLabel . toLink . itemBody)
    <> field "href" (pure . linkHref . toLink . itemBody)

-- | Wrap a value in an 'Item' so it can be used in a template list.
labelledItem :: (a -> String) -> a -> Item a
labelledItem name x = Item (fromFilePath (name x)) x

-- | The clean URL of an item, if it is written to the site.
itemUrl :: Item a -> Compiler (Maybe String)
itemUrl = fmap (fmap (cleanUrl . toUrl)) . getRoute . itemIdentifier

-- | Like 'itemUrl', but leaves the template field unset for unrouted items.
routedUrl :: Item a -> Compiler String
routedUrl = maybe (noResult "item has no route") pure <=< itemUrl

-- | Pandoc wraps TeX in @<span class="math inline|display">@.
usesMath :: String -> Bool
usesMath = isInfixOf "<span class=\"math "
