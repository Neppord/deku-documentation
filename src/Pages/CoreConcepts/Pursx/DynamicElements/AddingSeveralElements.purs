module Pages.CoreConcepts.Pursx.DynamicElements.AddingSeveralElements where

import Prelude

import Components.Code (psCodeWithLink)
import Components.ExampleBlockquote (exampleBlockquote)
import Contracts (Subsection, subsection)
import Control.Alt ((<|>))
import Data.Tuple.Nested ((/\))
import Deku.Attribute (class Attr, Attribute)
import Deku.Attributes (klass, klass_)
import Deku.Control (text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (click_)
import Deku.Pursx ((~~))
import Effect (Effect)
import Examples as Examples
import FRP.Event (Event)
import Type.Proxy (Proxy(..))

liHtml =
  ( Proxy
      :: Proxy
           """<li ~atts~>
      <div class="flex items-center">
        <svg class="h-full w-6 flex-shrink-0 text-gray-200" viewBox="0 0 24 44" preserveAspectRatio="none" fill="currentColor" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <path d="M.293 0l22 22-22 22h1.414l22-22-22-22H.293z" />
        </svg>
        <span class="cursor-pointer ml-4 text-sm font-medium text-gray-500 hover:text-gray-700" aria-current="page">~name~</span>
      </div>
    </li>"""
  )

myHtml =
  ( Proxy
      :: Proxy
           """<nav class="flex" aria-label="Breadcrumb">
  <ol role="list" class="flex space-x-4 rounded-md bg-white px-6 shadow">
    <li ~homeAtts~>
      <div class="flex items-center">
        <span class="cursor-pointer text-gray-400 hover:text-gray-500">
          <!-- Heroicon name: mini/home -->
          <svg class="h-5 w-5 flex-shrink-0" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M9.293 2.293a1 1 0 011.414 0l7 7A1 1 0 0117 11h-1v6a1 1 0 01-1 1h-2a1 1 0 01-1-1v-3a1 1 0 00-1-1H9a1 1 0 00-1 1v3a1 1 0 01-1 1H5a1 1 0 01-1-1v-6H3a1 1 0 01-.707-1.707l7-7z" clip-rule="evenodd" />
          </svg>
          <span class="sr-only cursor-pointer">Home</span>
        </span>
      </div>
    </li>

    ~lis~
  </ol>
</nav>"""
  )

addingSeveralElements :: Subsection
addingSeveralElements = subsection
  { title: "Adding several DOM elements as a component"
  , matter: pure
      [ D.p_
          [ text_ "To add several elements, one can use "
          , D.code__ "fixed"
          , text_ " or "
          , D.code__ "<>"
          , text_ "."
          ]
      , psCodeWithLink Examples.AddingSeveralElementsToPursx
      , exampleBlockquote
          [ Deku.do
              setProjects /\ projects <- useState true
              setNero /\ nero <- useState true
              let
                hideOnFalse e =
                  klass $ e <#> (if _ then "" else "hidden ") >>>
                    (_ <> "flex")

                toggleHome
                  :: forall element24
                   . Attr element24 D.OnClick (Effect Unit)
                  => Event (Attribute element24)
                toggleHome = click_ (setProjects false *> setNero false)

                toggleProjs
                  :: forall element24
                   . Attr element24 D.OnClick (Effect Unit)
                  => Event (Attribute element24)
                toggleProjs = click_ (setProjects true *> setNero false)

                toggleNero
                  :: forall element24
                   . Attr element24 D.OnClick (Effect Unit)
                  => Event (Attribute element24)
                toggleNero = click_ (setProjects true *> setNero true)
              D.div_
                [ D.div_
                    [ D.a [klass_ "cursor-pointer mr-4", toggleHome]
                        [ text_ "Go home" ]
                    , D.a [klass_ "cursor-pointer mr-4" , toggleProjs]
                        [ text_ "Go to projects" ]
                    , D.a [klass_ "cursor-pointer" ,toggleNero]
                        [ text_ "Go to nero" ]
                    ]
                , D.div_
                    [ myHtml ~~
                        { homeAtts: toggleHome <|> klass_ "flex h-12"
                        , lis:
                            fixed
                              [ liHtml ~~
                                  { atts: toggleProjs <|> hideOnFalse projects
                                  , name: text_ "Projects"
                                  }
                              , liHtml ~~
                                  { atts: toggleNero <|> hideOnFalse nero
                                  , name: text_ "Project Nero"
                                  }
                              ]
                        }
                    ]
                ]
          ]

      ]
  }
