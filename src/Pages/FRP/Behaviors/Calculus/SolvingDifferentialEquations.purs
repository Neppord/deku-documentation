module Pages.FRP.Behaviors.Calculus.SolvingDifferentialEquations where

import Prelude

import Components.Code (psCode)
import Components.ExampleBlockquote (exampleBlockquote)
import Constants (tripleQ)
import Contracts (Subsection, subsection)
import Data.Foldable (oneOf)
import Data.Time.Duration (Seconds(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (href_, klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (click_)
import FRP.Behavior (sample_, solve2')
import FRP.Behavior.Time (seconds)
import FRP.Event (keepLatest)
import FRP.Event.AnimationFrame (animationFrame)

example :: String
example =
  """module Main where

import Prelude

import Data.Foldable (oneOf)
import Data.Time.Duration (Seconds(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), (:=))
import Deku.Attributes (klass_)
import Deku.Control (text_)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (click_)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP.Behavior (sample_, solve2')
import FRP.Behavior.Time (seconds)
import FRP.Event (keepLatest)
import FRP.Event.AnimationFrame (animationFrame)

buttonClass =
    """ <> tripleQ
    <>
      """inline-flex items-center rounded-md
border border-transparent bg-indigo-600 px-3 py-2
text-sm font-medium leading-4 text-white shadow-sm
hover:bg-indigo-700 focus:outline-none focus:ring-2
focus:ring-indigo-500 focus:ring-offset-2 mr-6"""
    <> tripleQ
    <>
      """

main :: Effect Unit
main = runInBody Deku.do
  setThunk /\ thunk <- useState unit
  let
    motion = keepLatest $ thunk $>
      ( show >>> (D.Value := _) <$>
          ( sample_
              ( solve2' 1.0 0.0
                  ( seconds <#>
                      (\(Seconds s) -> s)
                  )
                  ( \x dx'dt -> pure (-0.5) * x -
                      (pure 0.1) * dx'dt
                  )
              )
              animationFrame
          )
      )
  D.div_
    [ D.div_
        [ D.button
            ( oneOf
                [ klass_ buttonClass, click_ (setThunk unit) ]
            )
            [ text_ "Restart simulation" ]
        ]
    , D.div_
        [ D.input
            ( oneOf
                [ D.Xtype !:= "range"
                , klass_ "w-full"
                , D.Min !:= "-1.0"
                , D.Max !:= "1.0"
                , D.Step !:= "0.01"
                , motion
                ]
            )
            []
        ]
    ]"""

solvingDifferentialEquations :: forall lock payload. Subsection lock payload
solvingDifferentialEquations = subsection
  { title: "Solving differential equations"
  , matter: pure
      [ D.p_
          [ text_
              "Last but not least, we can solve a second order differential equation of the form "
          , D.code__ "d^2a/dt^2 = f a (da/dt)"
          , text_ " using the "
          , D.code__ "solve2'"
          , text_ " function."
          , text_
              " As the left side is the acceleration of the system, we can solve by integrating twice (using the "
          , D.code__ "integrate'"
          , text_
              " function above) after specifying the initial conditions for position and velocity. For example, below we create a damped oscillator using the equation "
          , D.code__ "\\x dx'dt -> -⍺ * x - δ * dx'dt"
          , text_ ". In this case, both "
          , D.code__ "x"
          , text_ " (position) and "
          , D.code__ "dx'dt"
          , text_ " (veclocity) are behaviors."
          ]

      , psCode example
      , exampleBlockquote
          [ Deku.do
              setThunk /\ thunk <- useState unit
              let
                buttonClass =
                  """inline-flex items-center rounded-md
              border border-transparent bg-indigo-600 px-3 py-2
              text-sm font-medium leading-4 text-white shadow-sm
              hover:bg-indigo-700 focus:outline-none focus:ring-2
              focus:ring-indigo-500 focus:ring-offset-2 mr-6"""
                motion = keepLatest $ thunk $>
                  ( show >>> (D.Value := _) <$>
                      ( sample_
                          ( solve2' 1.0 0.0
                              ( seconds <#>
                                  (\(Seconds s) -> s)
                              )
                              ( \x dx'dt -> pure (-0.5) * x -
                                  (pure 0.1) * dx'dt
                              )
                          )
                          animationFrame
                      )
                  )
              D.div_
                [ D.div_
                    [ D.button
                        ( oneOf
                            [ klass_ buttonClass, click_ (setThunk unit) ]
                        )
                        [ text_ "Restart simulation" ]
                    ]
                , D.div_
                    [ D.input
                        ( oneOf
                            [ D.Xtype !:= "range"
                            , klass_ "w-full"
                            , D.Min !:= "-1.0"
                            , D.Max !:= "1.0"
                            , D.Step !:= "0.01"
                            , motion
                            ]
                        )
                        []
                    ]
                ]
          ]
      , D.p__
          "Granted, these methods may not be immediately useful if you're using Deku to build a SaaS dashboard or documentation site. But the day you're hired by the American Calculus Lovers' Association to build their website, you'll have a nice head start!"
      ]
  }
