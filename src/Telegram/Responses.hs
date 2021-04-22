{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}

module Telegram.Responses (
    Response (..),
    GetMeResponse,
    SendMessageResponse,
    GetUpdatesResponse
) where

import           Data.Aeson
import           GHC.Generics 

import Telegram.Types

data Response a = Response { result :: a } deriving (Show, Generic, FromJSON, ToJSON)


type GetMeResponse = Response TelegramUser

type SendMessageResponse = Response TelegramMessage

type GetUpdatesResponse = Response [TelegramUpdate]
