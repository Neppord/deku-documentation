module Pages.FRP.Delegates.Monoid where

import Contracts (Section, section)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D
import Pages.FRP.Delegates.Monoid.EventsAsMonoids (eventsAsMonoids)
import Pages.FRP.Delegates.Monoid.EventsAsSemigroups (eventsAsSemigroups)

monoid :: forall lock payload. Section lock payload
monoid = section
  { title: "Monoid"
  , topmatter:
      [ D.p_
          [ text_ "This section will be about "
          , D.span (D.Class !:= "font-bold") [ text_ "Monoid" ]
          , text_ "."
          ]
      ]
  , subsections:
      [ eventsAsMonoids, eventsAsSemigroups ]
  }
