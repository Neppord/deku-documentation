module Scratch where

import Prelude

import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (klass_)
import Deku.Control (text)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState')
import Deku.Toplevel (runInBody)
import Effect (Effect)
import QualifiedDo.Alt as Alt
import Web.HTML.HTMLInputElement (value)

inputKls :: String
inputKls =
  """rounded-md
border-gray-300 shadow-sm
border-2 mr-2
border-solid
focus:border-indigo-500 focus:ring-indigo-500
sm:text-sm"""

main :: Effect Unit
main = runInBody Deku.do
  setTxt /\ txt <- useState'
  setInput /\ input <- useState'
  D.div_
    [ D.input
        Alt.do
          klass_ inputKls
          input <#> \i -> D.OnInput := (value i >>= setTxt)
          D.SelfT !:= setInput
        []
    , D.div_ [ text txt ]
    ]
