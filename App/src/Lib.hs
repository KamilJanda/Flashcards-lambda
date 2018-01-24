{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

-- note that this module contain code inspirated by below authors:
--https://stackoverflow.com/questions/39090784/write-json-to-a-file-in-haskell-with-text-rather-than-char
--https://github.com/mattjbray/servant-elm-example-app/blob/master/api/Api/Types.hs

module Lib
    ( FlashCard(..)
    , Api
    , FlashCardDB
    , FlashCardID
    , getJSON
    , getFlashCard
    , writeFlashCard
    , writeFlashCards
    , getFlashCards
    ) where

import Data.Aeson   (FromJSON(..), ToJSON, withObject, eitherDecode )
import Elm (ElmType)
import GHC.Generics (Generic)
import Servant ((:<|>), (:>), ReqBody, Post, Get, JSON)
import qualified Data.Map.Strict as Map

import Data.Aeson.Text (encodeToLazyText)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.IO as I

import qualified Data.ByteString.Lazy as B

type FlashCardID = String


data FlashCard = FlashCard
                { flashCardID :: Maybe FlashCardID -- ^ Unique flashcard ID
                , polishWord :: String -- ^ Polish word
                , englishWord :: String -- ^ English translation
                } deriving (Show, Generic, ElmType,FromJSON, ToJSON)

type FlashCardDB = Map.Map FlashCardID FlashCard

type Api = "flashcard" :> ( Get '[JSON] [FlashCard]
                       :<|> ReqBody '[JSON] FlashCard :> Post '[JSON] FlashCard
                       )

-- some unusefull func

-- | function 'getJSON' gets JSON from file
-- It take file name as argument
getJSON :: String -> IO B.ByteString
getJSON = B.readFile


getFlashCard :: IO (Either String FlashCard)
getFlashCard = (eitherDecode <$> (getJSON "flashcard.json")) :: IO (Either String FlashCard)

getFlashCards :: IO (Either String [FlashCard])
getFlashCards = (eitherDecode <$> (getJSON "flashcards.json")) :: IO (Either String [FlashCard])

writeFlashCard :: Lib.FlashCard -> IO ()
writeFlashCard fc = I.writeFile "flashcard.json" (encodeToLazyText fc)

writeFlashCards :: [Lib.FlashCard] -> IO ()
writeFlashCards fcxs = I.writeFile "flashcards.json" (encodeToLazyText fcxs)
