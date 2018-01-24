{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Lib
import Servant ((:<|>) ((:<|>)), (:>), Get, Proxy (Proxy), Raw, Server, serve,
                serveDirectory, serveDirectoryFileServer)
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Control.Monad.IO.Class (liftIO)
import System.Random (randomIO)
import Control.Concurrent.STM (TVar, atomically, readTVar, writeTVar, newTVarIO,readTVarIO)
import qualified Data.Map.Strict as Map
import Lucid
import Servant.HTML.Lucid (HTML)

-- https://github.com/mattjbray/servant-elm-example-app/blob/master/api/Api/Server.hs

type SApi = "api" :> Lib.Api
              :<|> Get '[HTML] (Html ())
              :<|> "assets" :> Raw

homePage :: Html ()
homePage =
  doctypehtml_ $ do
    head_ $ do
      title_ "FlashCards"
      meta_ [ name_ "viewport"
            , content_ "width=device-width, initial-scale=1" ]
      script_ [src_ "assets/app.js"] ""
    body_ (script_ "var elmApp = Elm.Main.fullscreen()")


server :: TVar Lib.FlashCardDB -> Server SApi
server flashCardDB = apiServer :<|> home :<|> assets
    where home = return homePage
          apiServer = serverBase flashCardDB
          assets = serveDirectoryFileServer "frontend/dist"

serverBase :: TVar Lib.FlashCardDB -> Server Lib.Api
serverBase flashCardDB = listFlashCards :<|> createFlashCard
  where listFlashCards =
          liftIO . atomically $ do
            flashCarddb <- readTVar flashCardDB
            return (Map.elems flashCarddb)
        createFlashCard flashCard = do
          liftIO . atomically  $ do -- ^ perform STM atomic actions
            flashCarddb <- readTVar flashCardDB
            let idStr = show $ Map.size flashCarddb   -- ^ get size (next index)
                flashCardWithId = flashCard { flashCardID = Just idStr }
            writeTVar flashCardDB (Map.insert idStr flashCardWithId flashCarddb) -- ^ insert new flashcard
            return flashCardWithId

flashCards :: IO (TVar Lib.FlashCardDB)
flashCards = let
  flashcards = [Lib.FlashCard (Just "0") "Pusty" "Empty",
                Lib.FlashCard (Just "1") "Klucz" "Key"]
  in newTVarIO (Map.fromList (zip ["0", "1"] flashcards))

userAPI :: Proxy SApi
userAPI = Proxy

app :: TVar Lib.FlashCardDB -> Application
app fc =   serve userAPI (server fc)

main :: IO ()
main = do
  fc <- flashCards
  run 8000 (app fc)
