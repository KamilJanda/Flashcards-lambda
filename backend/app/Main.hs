module Main where

import Lib
import Servant
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Control.Monad.IO.Class (liftIO)
import System.Random (randomIO)
import Data.UUID (toString)
import Control.Concurrent.STM (TVar, atomically, readTVar, writeTVar, newTVarIO)
import qualified Data.Map.Strict as Map

-- https://github.com/mattjbray/servant-elm-example-app/blob/master/api/Api/Server.hs

server :: TVar Lib.FlashCardDB -> Server Lib.Api
server flashCardDB = listFlashCards :<|> createFlashCard
  where listFlashCards =
          liftIO . atomically $ do
            flashCarddb <- readTVar flashCardDB
            return (Map.elems flashCarddb)
        createFlashCard flashCard = do
          idf <- liftIO randomIO
          liftIO . atomically $ do
            let idStr = toString idf
                flashCardWithId = flashCard { flashCardID = Just (toString idf) }
            flashCarddb <- readTVar flashCardDB
            writeTVar flashCardDB (Map.insert idStr flashCardWithId flashCarddb)
            return flashCardWithId

flashCards :: IO (TVar Lib.FlashCardDB)
flashCards = let
  flashcards = [Lib.FlashCard (Just "1") "Pusty" "Empty"]
  in newTVarIO (Map.fromList (zip ["1"] flashcards))

userAPI :: Proxy Lib.Api
userAPI = Proxy

app :: TVar Lib.FlashCardDB -> Application
app fc =   serve userAPI (server fc)

main :: IO ()
main = do
  fc <- flashCards
  run 8000 (app fc)
