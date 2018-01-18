module Main where

import Lib
import Servant
import Network.Wai
import Network.Wai.Handler.Warp (run)
import Control.Monad.IO.Class (liftIO)
import System.Random (randomIO)
import Data.UUID (toString)
import Control.Concurrent.STM (TVar, atomically, readTVar, writeTVar, newTVarIO,readTVarIO)
import qualified Data.Map.Strict as Map

-- https://github.com/mattjbray/servant-elm-example-app/blob/master/api/Api/Server.hs

server :: TVar Lib.FlashCardDB -> Server Lib.Api
server flashCardDB = listFlashCards :<|> createFlashCard
  where listFlashCards =
          liftIO . atomically $ do
            flashCarddb <- readTVar flashCardDB
            return (Map.elems flashCarddb)
        createFlashCard flashCard = do
          liftIO . atomically  $ do --perform STM atomic actions
            flashCarddb <- readTVar flashCardDB
            let idStr = show $ Map.size flashCarddb   -- get size (next index)
                flashCardWithId = flashCard { flashCardID = Just idStr }
            writeTVar flashCardDB (Map.insert idStr flashCardWithId flashCarddb) -- insert new flashcard
            return flashCardWithId

flashCards :: IO (TVar Lib.FlashCardDB)
flashCards = let
  flashcards = [Lib.FlashCard (Just "0") "Pusty" "Empty",
                Lib.FlashCard (Just "1") "Klucz" "Key"]
  in newTVarIO (Map.fromList (zip ["0", "1"] flashcards))

userAPI :: Proxy Lib.Api
userAPI = Proxy

app :: TVar Lib.FlashCardDB -> Application
app fc =   serve userAPI (server fc)

main :: IO ()
main = do
  fc <- flashCards
  run 8000 (app fc)
