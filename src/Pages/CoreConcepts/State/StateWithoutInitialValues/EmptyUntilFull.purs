module Pages.CoreConcepts.State.StateWithoutInitialValues.EmptyUntilFull where

import Contracts (Subsection, subsection)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D

emptyUntilFull :: forall lock payload. Subsection lock payload
emptyUntilFull = subsection
  { title: "Empty until full"
  , matter:
      [ D.p_
          [ text_ "This subsection will be about "
          , D.span (D.Class !:= "font-bold") [ text_ "Empty until full" ]
          , text_ "."
          ]
      ]
  }
