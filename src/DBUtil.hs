{-# LANGUAGE CPP #-}

module DBUtil where

import Control.Applicative ((<$>))
import Database.Persist (insert, selectList, entityVal, SelectOpt(..))
import Database.Persist.GenericSql (SqlPersist(..), runSqlConn)

import Model

import Database.Persist.Sqlite (withSqliteConn)

runSql :: SqlPersist IO a -> IO a
runSql = withSqliteConn dbfile . runSqlConn
  where
      dbfile = "db.sqlite3"

readPosts :: IO [Post]
readPosts = map entityVal <$> (runSql $ selectList [] [Desc PostId])

addPost :: Post -> IO ()
addPost post = runSql $ insert post >> return ()
