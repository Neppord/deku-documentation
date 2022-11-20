module Components.Page where

import Prelude

import Components.Banner (banner)
import Components.BottomNav (bottomNav)
import Components.Header (header)
import Components.LeftMatter (leftMatter)
import Contracts (Page(..), FullPage, Section(..), Subsection(..))
import Control.Monad.State (evalState, get, put, runState)
import Data.Foldable (oneOf)
import Data.Monoid (guard)
import Data.Traversable (traverse)
import Data.Tuple (fst, snd)
import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Record (union)

page
  :: forall lock payload
   . String
  -> Page lock payload
  -> Domable lock payload
page chapter (Page i) = page' chapter (i `union` { showBanner: false })

titlePage
  :: forall lock payload
   . String
  -> Page lock payload
  -> Domable lock payload
titlePage chapter (Page i) = page' chapter (i `union` { showBanner: true })

page'
  :: forall lock payload
   . String
  -> FullPage lock payload
  -> Domable lock payload
page' chapter opts = D.div_
  ( [ header ]
      <> [ guard opts.showBanner banner ]
      <>
        [ D.div
            ( oneOf
                [ D.Class !:=
                    "relative mx-auto flex max-w-8xl justify-center sm:px-2 lg:px-8 xl:px-12"
                ]
            )
            [ leftMatter
            , D.div
                ( D.Class !:=
                    "min-w-0 max-w-2xl flex-auto px-4 py-16 lg:max-w-none lg:pr-0 lg:pl-8 xl:px-16"
                )
                [ D.article_
                    [ D.header
                        ( oneOf
                            [ D.Class !:= "mb-9 space-y-1"
                            ]
                        )
                        [ D.p
                            ( oneOf
                                [ D.Class !:=
                                    "font-display text-sm font-medium text-sky-500"
                                ]
                            )
                            [ text_ chapter ]
                        , D.h1
                            ( oneOf
                                [ D.Id !:= "getting-started"
                                , D.Class !:=
                                    "font-display text-3xl tracking-tight text-slate-900 dark:text-white"
                                ]
                            )
                            [ text_ opts.title ]
                        ]
                    , D.div
                        ( oneOf
                            [ D.Class !:=
                                "prose prose-slate max-w-none dark:prose-invert dark:text-slate-400 prose-headings:scroll-mt-28 prose-headings:font-display prose-headings:font-normal lg:prose-headings:scroll-mt-[8.5rem] prose-lead:text-slate-500 dark:prose-lead:text-slate-400 prose-a:font-semibold dark:prose-a:text-sky-400 prose-a:no-underline prose-a:shadow-[inset_0_-2px_0_0_var(--tw-prose-background,#fff),inset_0_calc(-1*(var(--tw-prose-underline-size,4px)+2px))_0_0_var(--tw-prose-underline,theme(colors.sky.300))] hover:prose-a:[--tw-prose-underline-size:6px] dark:[--tw-prose-background:theme(colors.slate.900)] dark:prose-a:shadow-[inset_0_calc(-1*var(--tw-prose-underline-size,2px))_0_0_var(--tw-prose-underline,theme(colors.sky.800))] dark:hover:prose-a:[--tw-prose-underline-size:6px] prose-pre:rounded-xl prose-pre:bg-slate-900 prose-pre:shadow-lg dark:prose-pre:bg-slate-800/60 dark:prose-pre:shadow-none dark:prose-pre:ring-1 dark:prose-pre:ring-slate-300/10 dark:prose-hr:border-slate-800"
                            ]
                        )
                        ( opts.topmatter <> join
                            ( flip evalState 0
                                ( traverse
                                    ( \(Section section) -> do
                                        i <- get
                                        let
                                          inner = flip runState (i + 1)
                                            ( traverse
                                                ( \(Subsection subsection) -> do
                                                    j <- get
                                                    put (j + 1)
                                                    pure
                                                      ( [ D.h3
                                                            ( D.Id !:=
                                                                subsection.id
                                                            )
                                                            [ text_
                                                                subsection.title
                                                            ]
                                                        ] <> subsection.matter
                                                      )
                                                )
                                                section.subsections
                                            )
                                        put (snd inner)
                                        pure
                                          ( [ D.hr_ []
                                            , D.h2
                                                (D.Id !:= section.id)
                                                [ text_ section.title ]

                                            ] <> section.topmatter <> join
                                              (fst inner)
                                          )
                                    )
                                    opts.sections
                                )
                            )
                        )
                    ]
                , bottomNav
                    { link: "/docs/installation", title: "Installation" }
                ]
            , D.div
                ( D.Class !:=
                    "hidden xl:sticky xl:top-[4.5rem] xl:-mr-6 xl:block xl:h-[calc(100vh-4.5rem)] xl:flex-none xl:overflow-y-auto xl:py-16 xl:pr-6"
                )
                [ D.nav
                    ( oneOf [ D.Class !:= "w-56" ]
                    )
                    [ D.h2
                        ( oneOf
                            [ D.Id !:= "on-this-page-title"
                            , D.Class !:=
                                "font-display text-sm font-medium text-slate-900 dark:text-white"
                            ]
                        )
                        [ text_ "On this page" ]
                    , D.ol
                        ( oneOf
                            [ D.Role !:= "list"
                            , D.Class !:= "mt-4 space-y-3 text-sm"
                            ]
                        )
                        ( map
                            ( \(Section section) ->
                                D.li_
                                  ( [ D.h3_
                                        [ D.a
                                            ( oneOf
                                                [ D.Class !:= "text-sky-500"
                                                , D.Href !:=
                                                    ("/#" <> section.id)
                                                ]
                                            )
                                            [ text_ section.title ]
                                        ]
                                    ] <> case section.subsections of
                                      [] -> []
                                      subsections ->
                                        [ D.ol
                                            ( oneOf
                                                [ D.Role !:= "list"
                                                , D.Class !:=
                                                    "mt-2 space-y-3 pl-5 text-slate-500 dark:text-slate-400"
                                                ]
                                            )
                                            ( map
                                                ( \(Subsection subsection) ->
                                                    D.li_
                                                      [ D.a
                                                          ( oneOf
                                                              [ D.Class !:=
                                                                  "hover:text-slate-600 dark:hover:text-slate-300"
                                                              , D.Href !:=
                                                                  ( "/#" <>
                                                                      subsection.id
                                                                  )
                                                              ]
                                                          )
                                                          [ text_
                                                              subsection.title
                                                          ]
                                                      ]
                                                )
                                                subsections
                                            )
                                        ]
                                  )
                            )
                            opts.sections
                        )
                    ]
                ]
            ]
        ]
  )