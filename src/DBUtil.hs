{-# LANGUAGE CPP #-}

module DBUtil where

import Control.Applicative ((<$>))
import Database.Persist (insert, selectList, entityVal, SelectOpt(..))
import Database.Persist.GenericSql (SqlPersist(..), runSqlConn)

import Model

-- #define SQLite

#ifdef SQLite

import Database.Persist.Sqlite (withSqliteConn)

runSql :: SqlPersist IO a -> IO a
runSql = withSqliteConn dbfile . runSqlConn
  where
    dbfile = "db.sqlite3"

#else

import Data.Monoid ((<>))
import Data.Text.Encoding (encodeUtf8)
import Database.Persist.Postgresql (withPostgresqlConn)
import Database.Persist.Store (loadConfig, applyEnv)
import Web.Heroku (dbConnParams)

runSql :: SqlPersist IO a -> IO a
runSql query = do
    params <- dbConnParams
    let connStr = foldr (\(k,v) t -> t <> (encodeUtf8 $ k <> "=" <> v <> " ")) "" params
    withPostgresqlConn connStr $ runSqlConn query

#endif

readPosts :: IO [Post]
readPosts = map entityVal <$> (runSql $ selectList [] [Desc PostId])

addPost :: Post -> IO ()
addPost post = runSql $ insert post >> return ()
