module Examples.UsingTheHookInAnAttribute where

import Prelude

import Data.String (Pattern(..), Replacement(..), replaceAll)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (href, klass_, style)
import Deku.Control (text_)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (click)
import Deku.Toplevel (runInBody)
import Effect (Effect)

buttonClass :: String -> String
buttonClass color =
  replaceAll (Pattern "COLOR") (Replacement color)
    """ml-4 inline-flex items-center rounded-md
border border-transparent bg-COLOR-600 px-3 py-2
text-sm font-medium leading-4 text-white shadow-sm
hover:bg-COLOR-700 focus:outline-none focus:ring-2
focus:ring-COLOR-500 focus:ring-offset-2"""

main :: Effect Unit
main = runInBody Deku.do
  setHrefSwitch /\ hrefSwitch <- useState false
  setStyleSwitch /\ styleSwitch <- useState false
  D.div_
    [ D.a
        [ D.Target !:= "_blank"
        , href $ hrefSwitch <#>
            if _ then "https://cia.gov" else "https://fbi.gov"
        , style $ styleSwitch <#>
            if _ then "color:magenta;" else "color:teal;"
        ]
        [ text_ "Click me" ]
    , D.button
        [ klass_ $ buttonClass "indigo"
        , click $ hrefSwitch <#> not >>> setHrefSwitch
        ]
        [ text_ "Switch href" ]
    , D.button
        [ klass_ $ buttonClass "green"
        , click $ hrefSwitch <#> not >>> setStyleSwitch
        ]
        [ text_ "Switch style" ]
    ]