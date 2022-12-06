module Pages.FRP.Sampling.SamplingOnAnEvent.FlippingTheFunctionAndArgument where

import Prelude

import Components.Code (psCode)
import Components.ExampleBlockquote (exampleBlockquote)
import Contracts (Env(..), Subsection, subsection)
import Data.Tuple.Nested ((/\))
import Deku.Attributes (klass_)
import Deku.Control (text, text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState')
import Deku.Listeners (slider_)
import FRP.Event.Class ((<**|>))

example :: String
example =
  """module Main where

import Prelude

import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text, text_)
import Deku.Core (fixed)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState')
import Deku.Listeners (slider_)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP.Event.Class ((<**|>))

main :: Effect Unit
main = runInBody Deku.do
  setSlider1 /\ slider1 <- useState'
  setSlider2 /\ slider2 <- useState'
  fixed
    [ D.div (klass_ "flex justify-around")
        [ D.input (slider_ setSlider1) []
        , D.input (slider_ setSlider2) []
        ]
    , text
        ( slider1 <**|>
            ((\a b -> show b <> " " <> show a) <$> slider2)
        )
    ]"""

flippingTheFunctionAndArgument :: forall lock payload. Subsection lock payload
flippingTheFunctionAndArgument = subsection
  { title: "Flipping the temporality"
  , matter: pure
      [ D.p_
          [ text_ "We can flip which event controls time by using "
          , D.code__ "sampleOnLeft"
          , text_ " aka "
          , D.code__ "<**|>"
          , text_ ". The signature is the same as "
          , D.code__ "sampleOnRight"
          , text_ ", namely:"
          ]
      , psCode
          """sampleOnLeft :: forall a b. event a -> event (a -> b) -> event b"""

      , D.p__
          "The example below is the same as the one above save time control - now, the slider on the left controls time. Make sure to move the slider on the right at least once to capture a value!."
      , psCode example
      , exampleBlockquote
          [ Deku.do
              setSlider1 /\ slider1 <- useState'
              setSlider2 /\ slider2 <- useState'
              fixed
                [ D.div (klass_ "flex justify-around")
                    [ D.input (slider_ setSlider1) []
                    , D.input (slider_ setSlider2) []
                    ]
                , text
                    ( slider1 <**|>
                        ((\a b -> show b <> " " <> show a) <$> slider2)
                    )
                ]
          ]
      ]
  }
