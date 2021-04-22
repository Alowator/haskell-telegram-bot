{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE RankNTypes        #-}


module Telegram.Requests (
    SendMessageRequest  (..),
    GetUpdatesRequest  (..),
    sendMessageRequest,
    getUpdatesRequest
) where

import           Data.Aeson
import           Data.Aeson.Types
import           GHC.Generics 

import Telegram.Types
import Telegram.JsonDrop


data SendMessageRequest = SendMessageRequest {
    message_chat_id         :: Integer,
    message_text            :: String,
    message_reply_markup    :: Maybe InlineKeyboardMarkup
} deriving (Show, Generic)

instance ToJSON SendMessageRequest where
  toJSON = toJsonDrop 8

instance FromJSON SendMessageRequest where
  parseJSON = parseJsonDrop 8

sendMessageRequest chat_id text reply_markup = SendMessageRequest chat_id text reply_markup


data GetUpdatesRequest = GetUpdatesRequest {
    updates_offset          :: Integer
} deriving (Show, Generic)

instance ToJSON GetUpdatesRequest where
  toJSON = toJsonDrop 8

instance FromJSON GetUpdatesRequest where
  parseJSON = parseJsonDrop 8

getUpdatesRequest :: Integer -> GetUpdatesRequest
getUpdatesRequest offset = GetUpdatesRequest offset