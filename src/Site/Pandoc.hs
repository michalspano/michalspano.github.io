-- | How Markdown is turned into HTML: Pandoc's options plus the document
-- transformations applied between parsing and rendering.
module Site.Pandoc
  ( markdownCompiler
  ) where

import Data.Text (Text)
import Data.Text qualified as T
import Hakyll
  ( Compiler
  , Item
  , defaultHakyllReaderOptions
  , defaultHakyllWriterOptions
  , pandocCompilerWithTransform
  )
import Site.Config (SiteConfig (..), siteConfig)
import Text.Pandoc.Definition (Inline (..), Pandoc)
import Text.Pandoc.Options
  ( Extension (..)
  , HTMLMathMethod (..)
  , ReaderOptions (..)
  , WriterOptions (..)
  , enableExtension
  )
import Text.Pandoc.Walk (walk)

-- | Render the current item's Markdown body to HTML.
markdownCompiler :: Compiler (Item String)
markdownCompiler = pandocCompilerWithTransform readerOptions writerOptions transform

-- | Pandoc Markdown (with smart punctuation, @$…$@ math, footnotes, tables,
-- @{.class}@ attributes, @:::@ divs and raw HTML) plus bare-URL autolinks.
readerOptions :: ReaderOptions
readerOptions =
  defaultHakyllReaderOptions
    { readerExtensions =
        enableExtension Ext_autolink_bare_uris (readerExtensions defaultHakyllReaderOptions)
    }

-- | Math is emitted as @\\(…\\)@ / @\\[…\\]@ and typeset in the browser by
-- MathJax, which @templates/partials/math.html@ loads only on pages that need it.
writerOptions :: WriterOptions
writerOptions = defaultHakyllWriterOptions {writerHTMLMathMethod = MathJax ""}

-- | Document transformations, applied in order from right to left.
transform :: Pandoc -> Pandoc
transform = walk openExternalLinksInNewTab . walk lazyLoadImages

openExternalLinksInNewTab :: Inline -> Inline
openExternalLinksInNewTab = \case
  Link (ident, classes, attrs) content target@(url, _)
    | isExternal url && "target" `notElem` map fst attrs ->
        Link (ident, classes, attrs <> [("target", "_blank"), ("rel", "noopener")]) content target
  inline -> inline

lazyLoadImages :: Inline -> Inline
lazyLoadImages = \case
  Image (ident, classes, attrs) alt target
    | "loading" `notElem` map fst attrs ->
        Image (ident, classes, attrs <> [("loading", "lazy")]) alt target
  inline -> inline

-- | An absolute http(s) URL that does not point back at this site.
isExternal :: Text -> Bool
isExternal url =
  any (`T.isPrefixOf` url) ["http://", "https://"]
    && not (T.pack (siteRoot siteConfig) `T.isPrefixOf` url)
