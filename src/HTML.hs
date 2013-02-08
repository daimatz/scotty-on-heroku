module HTML where

import Data.Monoid ((<>), mconcat)
import Data.Text.Lazy (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy as TL
import Data.Time (formatTime)
import System.Locale (defaultTimeLocale)

import Model

formHTML :: Text
formHTML =  "<form action=\"/\" method=\"post\">\n"
         <> "name: <input type=\"text\" name=\"name\" />\n"
         <> "text: <input type=\"text\" name=\"text\" />\n"
         <> "<input type=\"submit\" value=\"submit\" />\n"
         <> "</form>\n"

postsHTML :: [Post] -> Text
postsHTML posts
    = let lists = TL.fromStrict $ mconcat $ flip map posts $ \post ->
                       "<li>"
                    <> postName post
                    <> " | "
                    <> postText post
                    <> " | "
                    <> T.pack (formatTime defaultTimeLocale "%F %T" $ postCreated post)
                    <> "</li>"
      in "<ul class=\"posts\">" <> lists <> "</ul>"
