{-# LANGUAGE CPP #-}

module Main where

import Control.Applicative ((<$>))
import Database.Persist.GenericSql (runMigration)
import System.Environment (getEnv)
import Web.Scotty

import DBUtil
import Model

main = do
    runSql $ runMigration migrate
    port <- read <$> getEnv "PORT"
    scotty port $ do
        get "/" $ do
            html "test"
