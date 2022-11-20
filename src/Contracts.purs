module Contracts where

import Prelude

import Data.Array (intercalate)
import Data.String (Pattern(..), split, toLower)
import Deku.Core (Domable)
import Record (union)

newtype Docs lock paylaod = Docs (Array (Chapter lock paylaod))

newtype Chapter lock payload = Chapter
  { title :: String, pages :: Array (Page lock payload) }

type Page' lock payload r =
  { path :: String
  , title :: String
  , topmatter :: Array (Domable lock payload)
  , sections :: Array (Section lock payload)
  | r
  }

newtype Page lock payload = Page (Page' lock payload ())
type FullPage lock payload = Page' lock payload (showBanner :: Boolean)

page
  :: forall lock payload
   . { title :: String
     , topmatter :: Array (Domable lock payload)
     , sections :: Array (Section lock payload)
     }
  -> Page lock payload
page i = Page
  ( i `union`
      { path: "/" <>
          (intercalate "-" $ map toLower $ split (Pattern " ") i.title)
      }
  )

newtype Section lock payload = Section
  { title :: String
  , id :: String
  , topmatter :: Array (Domable lock payload)
  , subsections :: Array (Subsection lock payload)
  }

section
  :: forall lock payload
   . { title :: String
     , topmatter :: Array (Domable lock payload)
     , subsections :: Array (Subsection lock payload)
     }
  -> Section lock payload
section i = Section
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )

newtype Subsection lock payload = Subsection
  { title :: String, id :: String, matter :: Array (Domable lock payload) }

subsection
  :: forall lock payload
   . { title :: String
     , matter :: Array (Domable lock payload)
     }
  -> Subsection lock payload
subsection i = Subsection
  ( i `union`
      { id: intercalate "-" $ map toLower $ split (Pattern " ") i.title }
  )