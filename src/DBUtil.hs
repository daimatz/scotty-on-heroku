{-# LANGUAGE CPP #-}

module DBUtil where

import Control.Applicative ((<$>))
import Database.Persist (insert, selectList, entityVal, SelectOpt(..))
import Database.Persist.GenericSql (SqlPersist(..), runSqlConn)

import Model

-- #define DEVELOPMENT

#ifdef DEVELOPMENT

import Database.Persist.Sqlite (withSqliteConn)

runSql :: SqlPersist IO a -> IO a
runSql = withSqliteConn dbfile . runSqlConn
  where
    dbfile = "db.sqlite3"

#else

import Database.Persist.Postgresql (withPostgresqlConn)

runSql :: SqlPersist IO a -> IO a
runSql = withPostgresqlConn connStr . runSqlConn
  where
    connStr = "host=localhost port=5432 user=daimatz dbname=daimatz password=daimatz"

#endif

readPosts :: IO [Post]
readPosts = map entityVal <$> (runSql $ selectList [] [Desc PostId])

addPost :: Post -> IO ()
addPost post = runSql $ insert post >> return ()
