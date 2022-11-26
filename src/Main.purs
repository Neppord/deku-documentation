module Main
  ( ScrolledSection(..)
  , getScrolledSection
  , main
  )
  where

import Prelude

import Components.App (app)
import Data.Compactable (compact)
import Data.Foldable (traverse_)
import Data.Generic.Rep (class Generic)
import Data.Map as Map
import Data.Maybe (Maybe(..), maybe)
import Data.Show.Generic (genericShow)
import Data.Tuple (Tuple(..), curry, fst, snd, uncurry)
import Deku.Core (envy)
import Deku.Do as Deku
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Ref as Ref
import FRP.Dedup (dedup)
import FRP.Event (create, fold, mailboxed, memoize, subscribe)
import FRP.Lag (lag)
import Router.ADT (Route(..))
import Router.Page (routeToPage)
import Router.Route (route)
import Routing.Duplex (parse)
import Routing.PushState (makeInterface, matchesWith)
import Web.DOM.Element (getBoundingClientRect)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (addEventListener, eventListener, removeEventListener)
import Web.HTML (window)
import Web.HTML.Window (toEventTarget)

pixelBufferForScroll = 100.0 :: Number

data ScrolledSection
  = ScrolledCandidate Int
  | ScrolledDefinite Int
  | NotScrolled

derive instance Generic ScrolledSection _
instance Show ScrolledSection where
  show = genericShow

getScrolledSection :: (Int -> Effect ScrolledSection) -> Effect Int
getScrolledSection f = go 0 0
  where
  go n head = do
    scrolledSection <- f head
    case scrolledSection of
      ScrolledCandidate i -> go i (head + 1)
      ScrolledDefinite i -> pure i
      NotScrolled -> pure n

main :: Effect Unit
main = do
  currentRouteMailbox <- create
  previousRouteMailbox <- create
  currentRoute <- create
  headerElement <- create
  rightSideNav <- create
  psi <- makeInterface
  rightSideNavSelectE <- create
  navRendered <- create
  initialListener <- eventListener (\_ -> pure unit)
  scrollListenerRef <- Ref.new initialListener
  let scrollType = EventType "scroll"
  let
    removeScroll oldListener = toEventTarget <$> window >>= removeEventListener
      scrollType
      oldListener
      true
  let
    setScroll newListener = toEventTarget <$> window >>= addEventListener
      scrollType
      newListener
      true
  setScroll initialListener
  let
    changeListener newListener = do
      oldListener <- Ref.read scrollListenerRef
      removeScroll oldListener
      setScroll newListener
      Ref.write newListener scrollListenerRef

  let
    makeMap inMap = case _ of
      Nothing -> Map.empty
      Just (Tuple key val) -> Map.insert key val inMap
  void $ subscribe
    ( { isNavRendered: _, header: _, mapOfElts: _ }
        <$> navRendered.event
        <*> headerElement.event
        <*> fold makeMap
          Map.empty
          rightSideNav.event
    )
    \{ header, mapOfElts } -> do
      newListener <- eventListener \_ -> do
        let
          toVerify ce =
            Map.lookup ce mapOfElts # maybe (pure NotScrolled) \myElt -> do
              boundingRectHeader <- getBoundingClientRect header
              boundingRectElt <- getBoundingClientRect myElt
              let
                minAy = boundingRectHeader.top
                maxAy = boundingRectHeader.bottom
                minBy = boundingRectElt.top - pixelBufferForScroll
                maxBy = boundingRectElt.bottom - pixelBufferForScroll
                aAboveB = minAy > maxBy
                aBelowB = maxAy < minBy

                intersects = not (aAboveB || aBelowB)
              pure case intersects of
                true -> ScrolledDefinite ce
                false ->
                  if maxBy < minAy then ScrolledCandidate ce else NotScrolled

        goHere <- getScrolledSection toVerify
        rightSideNavSelectE.push goHere
      changeListener newListener
  runInBody
    ( Deku.do
        rightSideLagged <- envy <<< memoize
          (lag (dedup rightSideNavSelectE.event))
        pageWas <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> previousRouteMailbox.event)
        pageIs <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> currentRouteMailbox.event)
        rightSideNavSelect <- envy <<< mailboxed
          (({ address: _, payload: unit }) <$> (snd <$> rightSideLagged))
        rightSideNavDeselect <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> compact (fst <$> rightSideLagged))
        app
          { pageIs
          , pageWas
          , rightSideNavSelect
          , rightSideNavDeselect
          , setNavRendered: navRendered.push
          , pushState: psi.pushState
          , curPage: routeToPage <$> currentRoute.event
          , showBanner: dedup (eq GettingStarted <$> currentRoute.event)
          , setHeaderElement: headerElement.push
          , setRightSideNav: Just >>> rightSideNav.push
          }
    )
  dedupRoute <- create
  void $ subscribe (dedup dedupRoute.event) $ uncurry \old new -> do
    rightSideNav.push Nothing
    traverse_ previousRouteMailbox.push old
    currentRouteMailbox.push new
    currentRoute.push new
  void $ matchesWith (parse route)
    (curry dedupRoute.push)
    psi

