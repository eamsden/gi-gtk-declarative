{-# OPTIONS_GHC -fno-warn-unticked-promoted-constructors #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE UndecidableInstances   #-}
{-# LANGUAGE TypeOperators          #-}
{-# LANGUAGE ScopedTypeVariables    #-}
{-# LANGUAGE FlexibleContexts       #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE DataKinds              #-}
{-# LANGUAGE FlexibleInstances      #-}
{-# LANGUAGE GADTs                  #-}
{-# LANGUAGE LambdaCase             #-}
{-# LANGUAGE MultiParamTypeClasses  #-}
{-# LANGUAGE OverloadedLabels       #-}
{-# LANGUAGE RecordWildCards        #-}

-- | Implementation of 'Gtk.Box' as a declarative container.

module GI.Gtk.Declarative.Container.Box
  ( BoxChild(..)
  , boxChild
  )
where

import           Data.Word                                ( Word32 )
import qualified GI.Gtk                        as Gtk

import           GI.Gtk.Declarative.EventSource
import           GI.Gtk.Declarative.Markup
import           GI.Gtk.Declarative.Container.Patch

instance IsContainer Gtk.Box BoxChild event where
  appendChild box BoxChild {..} widget' =
    Gtk.boxPackStart box widget' expand fill padding

  replaceChild box boxChild' i old new = do
    Gtk.containerRemove box old
    appendChild box boxChild' new
    Gtk.boxReorderChild box new i
    Gtk.widgetShowAll box

data BoxChild event = BoxChild { expand :: Bool, fill :: Bool, padding :: Word32, child :: Widget event }

boxChild :: Bool -> Bool -> Word32 -> Widget event -> MarkupOf BoxChild event ()
boxChild expand fill padding child = widget BoxChild {..}

instance Patchable BoxChild where
  create = create . child
  patch b1 b2 = patch (child b1) (child b2)

instance EventSource (BoxChild event) event where
  subscribe BoxChild{..} = subscribe child