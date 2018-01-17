{-# LANGUAGE DataKinds     #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeOperators #-}

module Lib
    ( FlashCard(..)
    , Api
    ) where

import Data.Aeson   (FromJSON, ToJSON)
import Elm (ElmType)
import GHC.Generics (Generic)
import Servant ((:<|>), (:>), ReqBody, Post, Get, JSON)

data FlashCard = FlashCard
                { polishWord :: String
                , englishWord :: String
                } deriving (Show, Generic, ElmType, ToJSON, FromJSON)


type Api = "flashcard" :> Get '[JSON] FlashCard
