module Pages.FRP.Events.PureEvents.WhatIsAnEventWithoutTime where

import Prelude

import Components.ProTip (proTip)
import Contracts (Subsection, subsection)
import Deku.Attribute ((!:=))
import Deku.Attributes (href_)
import Deku.Control (text_)
import Deku.DOM as D

whatIsAnEventWithoutTime :: Subsection
whatIsAnEventWithoutTime = subsection
  { title: "What is an event without time?"
  , matter: pure
      [ D.p_
          [ text_
              "For an event to take place out of time, or rather in a sort of \"flat\" time, the time-based aspects of a computation need to be controlled by a different clock than the vagueries of browser-based, inaccurate timers like "
          , D.code__ "setTimeout"
          , text_ " and "
          , D.code__ "setInterval"
          , text_
              ". This doesn't mean that we eschew before/after relationships, but rather that these relationships need to be controlled by an interpreter that is more precise than the browser."
          ]
      , proTip
          { header: text_ "Different flavors of time"
          , message: D.div_
              [ text_
                  "When we talk about precise time, we don't mean time that is precise according to some arbitrary measurement of clock time at some point in the universe. Rather, we mean an environment where we can model and reproduce temporal phenomena. The actual speed of these systems is irrelevant, provided they finish executing before we die or become senile. For example, if we run them on a computer from the 1950s, they will necessarily execute slower than on a MacBook Pro M2. In these cases, it's ok to limit time to that which can be articulated precisely, even if we lose some of the granularity that we gain from the browser's time APIs."
              ]
          }
      , D.p_
          [ D.code__ "purescript-hyrule"
          , text_
              " comes with one version of out-of-time events that executes during a single browser tick. It is wedded to the unique execution environment of a browser that schedules all UI-code to run on a single thread. "
          , D.code__ "purescript-hyrule"
          , text_
              " takes advantage of this design by treating pure events as those that fulfill the following criteria:"
          ]
      , D.ol_
          [ D.li__
              "The event must not use any asynchronous APIs, meaning that everything must be accomplished in one browser tick."
          , D.li__
              "The event must not trigger any side effects that could fail, like writing to a console or issuing an alert."
          ]
      , D.p_
          [ text_
              "Thankfully, there's a monad for this (there's one for everything!) called the "
          , D.code__ "ST r"
          , text_ " monad, where "
          , D.code__ "r"
          , text_
              " is an arbitrary region where the code executes. The full bredth of the "
          , D.code__ "ST r"
          , text_
              " monad is outside the scope of this documentation, but you can read up on it on "
          , D.a
              [href_ "https://pursuit.purescript.org/packages/purescript-st/"
                  , (D.Target !:= "_blank")
              ]
              [ text_ "Pursuit" ]
          , text_
              ". For our purposes, it'll suffice to "
          , D.a [href_ "#the-st-monad"] [ text_ "go over its main properties" ]
          , text_ " and to "
          , D.a [href_ "#the-lemming-event"] [ text_ "use it to define events" ]
          , text_ "."
          ]
      ]
  }
