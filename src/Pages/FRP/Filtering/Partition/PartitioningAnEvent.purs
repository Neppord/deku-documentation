module Pages.FRP.Filtering.Partition.PartitioningAnEvent where

import Contracts (Subsection, subsection)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D

partitioningAnEvent :: forall lock payload. Subsection lock payload
partitioningAnEvent = subsection
  { title: "Partitioning an event"
  , matter:
      [ D.p_
          [ text_ "This subsection will be about "
          , D.span (D.Class !:= "font-bold") [ text_ "Partitioning an event" ]
          , text_ "."
          ]
      ]
  }
