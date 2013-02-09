module HTML
    ( formHTML
    , postsHTML
    , body
    ) where

import           Control.Monad           (forM)
import           Control.Monad.IO.Class  (liftIO, MonadIO)
import           Data.Monoid             ((<>), mconcat)
import qualified Data.Text               as T
import           Data.Text.Lazy          (Text)
import           Data.Text.Lazy.Encoding (decodeUtf8)
import           Data.Time               (formatTime)
import           System.Locale           (defaultTimeLocale)
import           Text.Hastache
import           Text.Hastache.Context
import           Web.Scotty              (html, ActionM)

import Model

mustache :: MonadIO m => FilePath -> (String -> MuType m) -> m Text
mustache path context = return . decodeUtf8
    =<< hastacheFile defaultConfig path (mkStrContext context)

nullContext :: MonadIO m => String -> MuType m
nullContext = const $ MuVariable ("" :: String)

formHTML :: ActionM Text
formHTML = liftIO $ mustache "view/form.mustache" nullContext

postsHTML :: [Post] -> ActionM Text
postsHTML posts = do
    htmls <- forM posts $ \post ->
        liftIO $ mustache "view/post.mustache" (context post)
    return $ "<ul>" <> mconcat htmls <> "</ul>"
  where
    context post "name" = MuVariable $ postName post
    context post "text" = MuVariable $ postText post
    context post "date" = MuVariable
        $ T.pack $ formatTime defaultTimeLocale "%F %T" $ postCreated post
    context _    _      = MuVariable $ ("error" :: T.Text)

body :: Text -> ActionM ()
body text = do
    h <- liftIO $ mustache "view/head.mustache" nullContext
    f <- liftIO $ mustache "view/foot.mustache" nullContext
    html $ h <> text <> f
