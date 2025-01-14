module Examples.KnowThySelf where

import Prelude

import Data.String.Utils (words)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Control (text)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState')
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (Milliseconds(..), delay, launchAff_)
import Effect.Class (liftEffect)
import Web.DOM.Element (toParentNode)
import Web.DOM.HTMLCollection as HTMLCollection
import Web.DOM.ParentNode (children)

main :: Effect Unit
main = runInBody Deku.do
  setLength /\ length <- useState'
  D.div
    [ D.Self !:= \e -> launchAff_ do
        delay (Milliseconds 0.0)
        liftEffect do
          kids <- children (toParentNode e)
          HTMLCollection.length kids >>= setLength
    ]
    ( (words "I have this many kids:" <#> D.div__) <>
        [ D.div_ [ text (show <$> length) ] ]
    )