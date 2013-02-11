{-# LANGUAGE EmptyDataDecls       #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE QuasiQuotes          #-}
{-# LANGUAGE TemplateHaskell      #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Model where

import           Data.Text           (Text)
import           Data.Time           (UTCTime)
import           Database.Persist
import           Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrate"] [persist|
Post json
    name    Text
    text    Text
    created UTCTime
  deriving Show Read Eq Ord
|]
