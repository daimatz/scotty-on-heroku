{-# LANGUAGE RankNTypes #-}

module HTML
    ( formHTML
    , postsHTML
    , body
    ) where

import           Control.Monad.IO.Class  (liftIO, MonadIO)
import           Data.Monoid             ((<>))
import qualified Data.Text               as T
import           Data.Text.Lazy          (Text)
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           Data.Time               (formatTime)
import           System.Locale           (defaultTimeLocale)
import           Text.Hastache
import           Text.Hastache.Context
import           Web.Scotty              (html, ActionM)

import Model

mustache :: MonadIO m => FilePath -> MuContext m -> m Text
mustache path context = return . decodeUtf8
    =<< hastacheFile defaultConfig path context

nullContext :: MonadIO m => MuContext m
nullContext = mkStrContext $ const $ MuVariable ("" :: T.Text)

errorRef :: forall m . MuType m
errorRef = MuVariable ("error" :: T.Text)

formHTML :: ActionM Text
formHTML = liftIO $ mustache "view/form.mustache" nullContext

postsHTML :: [Post] -> ActionM Text
postsHTML posts = liftIO $ mustache "view/post.mustache" (mkStrContext context)
  where
    context "posts" = MuList $ map (mkStrContext . listContext) posts
    context _       = errorRef
    listContext post "name" = MuVariable $ postName post
    listContext post "text" = MuVariable $ postText post
    listContext post "date" = MuVariable
        $ T.pack $ formatTime defaultTimeLocale "%F %T" $ postCreated post
    listContext _    _      = errorRef

body :: Text -> ActionM ()
body text = do
    h <- liftIO $ mustache "view/head.mustache" nullContext
    f <- liftIO $ mustache "view/foot.mustache" nullContext
    html $ h <> text <> f
