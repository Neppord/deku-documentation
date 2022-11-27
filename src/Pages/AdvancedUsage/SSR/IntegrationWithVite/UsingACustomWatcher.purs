module Pages.AdvancedUsage.SSR.IntegrationWithVite.UsingACustomWatcher where

import Contracts (Subsection, subsection)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.DOM as D

usingACustomWatcher :: forall lock payload. Subsection lock payload
usingACustomWatcher = subsection
  { title: "Using a custom watcher"
  , matter:
      [ D.p_
          [ text_ "This subsection will be about "
          , D.span (D.Class !:= "font-bold") [ text_ "Using a custom watcher" ]
          , text_ "."
          ]
      ]
  }
