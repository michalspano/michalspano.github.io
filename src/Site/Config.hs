-- | Site-wide settings: everything that is not page content but that you may
-- want to change without touching the build logic.
module Site.Config
  ( Link (..)
  , SiteConfig (..)
  , siteConfig
  , hakyllConfig
  ) where

import Hakyll (Configuration (..), defaultConfiguration)

-- | A labelled hyperlink, used for the navigation bar and the social links.
data Link = Link
  { linkLabel :: String
  , linkHref :: String
  }

data SiteConfig = SiteConfig
  { siteTitle :: String
  -- ^ Shown in the header and appended to every @<title>@.
  , siteDescription :: String
  -- ^ Tagline under the title; also the fallback @<meta name="description">@.
  , siteAuthor :: String
  , siteRoot :: String
  -- ^ Absolute origin without a trailing slash, used for canonical URLs.
  , siteNavigation :: [Link]
  -- ^ Header links, in display order.
  , siteSocials :: [Link]
  -- ^ Footer links, in display order.
  , siteAnalyticsId :: Maybe String
  -- ^ Google Analytics measurement ID; 'Nothing' disables tracking.
  }

siteConfig :: SiteConfig
siteConfig =
  SiteConfig
    { siteTitle = "Michal Spano"
    , siteDescription = "Computer Science | Recreational Programming"
    , siteAuthor = "Michal Spano"
    , siteRoot = "https://michalspano.com"
    , siteNavigation =
        [ Link "~" "/"
        , Link "Blog" "/blog/"
        , -- Published by the separate `cv` repository under the same domain,
          -- so it is not part of this build.
          Link "CV" "https://michalspano.com/cv/"
        , Link "Teaching" "/teaching/"
        , Link "FP" "https://fp.michalspano.com/"
        , Link "etc" "/etc/"
        ]
    , siteSocials =
        [ Link "Email" "mailto:spano@michalspano.com"
        , Link "LinkedIn" "https://www.linkedin.com/in/michalspano"
        , Link "Twitter" "https://www.twitter.com/michalspano"
        , Link "Flickr" "https://www.flickr.com/people/197352203@N08"
        , Link "GitHub" "https://www.github.com/michalspano"
        ]
    , siteAnalyticsId = Just "G-R0D6FNJLTB"
    }

-- | Hakyll's own settings. The directories match Hakyll's defaults but are
-- spelled out because the Makefile and CI workflow refer to them.
hakyllConfig :: Configuration
hakyllConfig =
  defaultConfiguration
    { providerDirectory = "."
    , destinationDirectory = "_site"
    , storeDirectory = "_cache"
    , tmpDirectory = "_cache/tmp"
    }
