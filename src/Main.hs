module Main where

import Control.Applicative ((<$>))
import Control.Monad.IO.Class (liftIO)
import Data.Monoid ((<>), mconcat)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Time (getCurrentTime, UTCTime)
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import Database.Persist.GenericSql (runMigration)
import System.Environment (getEnv)
import Web.Scotty

import DBUtil
import HTML
import Model

main = do
    runSql $ runMigration migrate
    port <- read <$> getEnv "PORT"
    scotty port $ do
        get "/" $ do
            posts <- liftIO readPosts
            html $ formHTML <> postsHTML posts

        post "/" $ do
            name <- param "name"
            text <- param "text"
            now <- liftIO getCurrentTime
            liftIO $ addPost $ Post (TL.toStrict name) (TL.toStrict text) now
            redirect "/"
