module Main where

import           Control.Applicative         ((<$>))
import           Control.Monad               (join)
import           Control.Monad.IO.Class      (liftIO)
import           Data.Monoid                 ((<>))
import qualified Data.Text.Lazy              as TL
import           Data.Time                   (getCurrentTime)
import           Database.Persist.GenericSql (runMigration)
import           System.Environment          (getEnv)
import           Web.Scotty                  hiding (body)

import           DBUtil
import           HTML
import           Model

main :: IO ()
main = do
    runSql $ runMigration migrate
    port <- read <$> getEnv "PORT"
    scotty port $ do
        get "/" $ do
            form <- formHTML
            posts <- join $ postsHTML <$> liftIO readPosts
            body $ form <> posts

        post "/" $ do
            pn <- param "name"
            pt <- param "text"
            now <- liftIO getCurrentTime
            liftIO $ addPost $ Post (TL.toStrict pn) (TL.toStrict pt) now
            redirect "/"
