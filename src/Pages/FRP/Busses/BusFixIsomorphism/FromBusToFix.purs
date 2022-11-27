module Pages.FRP.Busses.BusFixIsomorphism.FromBusToFix where

import Contracts (Subsection, subsection)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D

fromBusToFix :: forall lock payload. Subsection lock payload
fromBusToFix = subsection
  { title: "From bus to fix"
  , matter:
      [ D.p_
          [ text_ "This subsection will be about "
          , D.span (D.Class !:= "font-bold") [ text_ "From bus to fix" ]
          , text_ "."
          ]
      ]
  }
