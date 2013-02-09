module Main where

import Control.Applicative ((<$>))
import Control.Monad (join)
import Control.Monad.IO.Class (liftIO)
import Data.Monoid ((<>))
import Data.Time (getCurrentTime)
import qualified Data.Text.Lazy as TL
import Database.Persist.GenericSql (runMigration)
import System.Environment (getEnv)
import Web.Scotty hiding (body)

import HTML
import DBUtil
import Model

main = do
    runSql $ runMigration migrate
    port <- read <$> getEnv "PORT"
    scotty port $ do
        get "/" $ do
            form <- formHTML
            posts <- join $ postsHTML <$> liftIO readPosts
            body $ form <> posts

        post "/" $ do
            name <- param "name"
            text <- param "text"
            now <- liftIO getCurrentTime
            liftIO $ addPost $ Post (TL.toStrict name) (TL.toStrict text) now
            redirect "/"
