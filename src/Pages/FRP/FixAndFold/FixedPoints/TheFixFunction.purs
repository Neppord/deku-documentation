module Pages.FRP.FixAndFold.FixedPoints.TheFixFunction where

import Contracts (Subsection, subsection)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D

theFixFunction :: forall lock payload. Subsection lock payload
theFixFunction = subsection
    { title: "The fix function"
    , matter:
        [ D.p_
            [ text_ "This subsection will be about "
            , D.span (D.Class !:= "font-bold") [ text_ "The fix function"]
            , text_ "."
            ]
        ]
    }