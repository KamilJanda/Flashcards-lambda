{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( FlashCard(..)
    , Api
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
--https://stackoverflow.com/questions/39090784/write-json-to-a-file-in-haskell-with-text-rather-than-char
import Data.Aeson.Text (encodeToLazyText)
import Data.Text.Lazy (Text)
import Data.Text.Lazy.IO as I

import qualified Data.ByteString.Lazy as B

data FlashCard = FlashCard
                { polishWord :: String
                , englishWord :: String
                } deriving (Show, Generic, ElmType,FromJSON, ToJSON)

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

type Api = "flashcard" :> Get '[JSON] FlashCard
