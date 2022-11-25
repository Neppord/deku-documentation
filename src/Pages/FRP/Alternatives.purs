module Pages.FRP.Alternatives where

import Contracts (Page, page)
import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.DOM as D
import Pages.FRP.Alternatives.Alt (alt)
import Pages.FRP.Alternatives.Plus (plus)

alternatives :: forall lock payload. Page lock payload
alternatives = page
  { title: "Alternatives"
  , topmatter:
          [ D.p (D.Class !:= "lead")
              [ text_ "This page will be about "
                , D.span (D.Class !:= "font-bold") [ text_ "Alternatives"]
                , text_ "."
              ]
          , D.p_
              [ text_
                  "Possimus saepe veritatis sint nobis et quam eos. Architecto consequatur odit perferendis fuga eveniet possimus rerum cumque. Ea deleniti voluptatum deserunt voluptatibus ut non iste."
              ]
          ]
  , sections:
      [ alt,plus]
  }