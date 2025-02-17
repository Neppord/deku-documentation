module Pages.FRP.Filtering.Filter where

import Prelude

import Contracts (Section, section)
import Deku.Control (text_)
import Deku.DOM as D
import Pages.FRP.Filtering.Filter.FilteringAnEvent (filteringAnEvent)
import Pages.FRP.Filtering.Filter.PerformanceConsiderations (performanceConsiderations)

filter :: Section
filter = section
  { title: "Filter"
  , topmatter: pure
      [ D.p_
          [ D.code__ "Event"
          , text_ " implements "
          , D.code__ "Filterable"
          , text_
              ", meaning that you can use the same functions you use to filter arrays and lists on events."
          ]
      ]
  , subsections:
      [ filteringAnEvent, performanceConsiderations ]
  }
