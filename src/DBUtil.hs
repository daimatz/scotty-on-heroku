{-# LANGUAGE CPP #-}

module DBUtil where

import qualified Database.Persist as DB
import Database.Persist.GenericSql (SqlPersist(..), runSqlConn)

import Model

import Database.Persist.Sqlite (withSqliteConn)

runSql :: SqlPersist IO a -> IO a
runSql = withSqliteConn dbfile . runSqlConn
  where
      dbfile = "db.sqlite3"
