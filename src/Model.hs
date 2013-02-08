{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE TypeFamilies, GADTs, EmptyDataDecls #-}
{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
{-# LANGUAGE TypeSynonymInstances, FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Model where

import Data.Time (UTCTime)
import Data.Text (Text)
import Database.Persist
import Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrate"] [persist|
Post
    name    Text
    text    Text
    created UTCTime
  deriving Show Read Eq Ord
|]
