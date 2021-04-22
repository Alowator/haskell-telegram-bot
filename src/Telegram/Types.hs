{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE OverloadedStrings #-}

module Telegram.Types (
    TelegramUser,
    TelegramMessage,
    TelegramUpdate,
    TelegramCallbackQuery,
    InlineKeyboardMarkup,
    inlineKeyboardMarkup,
    InlineKeyboardButton,
    inlineKeyboardButton,
    getTelegramUpdateId,
    getTelegramUpdate
) where

import           Data.Aeson
import           GHC.Generics 

import Telegram.JsonDrop


data TelegramUser = TelegramUser {
    user_id          :: Integer,
    user_is_bot      :: Bool,
    user_first_name  :: String
} deriving (Eq, Show, Generic)

instance FromJSON TelegramUser where
    parseJSON = parseJsonDrop 5


data TelegramMessage = TelegramMessage {
    message_message_id  :: Integer,
    message_from        :: TelegramUser,
    message_text        :: String
} deriving (Eq, Show, Generic)

instance FromJSON TelegramMessage where
    parseJSON = parseJsonDrop 8


data TelegramUpdate = TelegramUpdate {
    update_update_id                :: Integer,
    update_message                  :: Maybe TelegramMessage,
    update_callback_query           :: Maybe TelegramCallbackQuery
} deriving (Eq, Show, Generic)

instance FromJSON TelegramUpdate where
    parseJSON = parseJsonDrop 7


data TelegramCallbackQuery = TelegramCallbackQuery {
    callback_query_id                   :: String,
    callback_query_from                 :: TelegramUser,
    callback_query_message              :: Maybe TelegramMessage,
    callback_query_inline_message_id    :: Maybe String,
    callback_query_data                 :: String
} deriving (Eq, Show, Generic)

instance FromJSON TelegramCallbackQuery where
    parseJSON = parseJsonDrop 15


data InlineKeyboardMarkup = InlineKeyboardMarkup {
    inline_keyboard               :: [[InlineKeyboardButton]]
} deriving (Eq, Show, Generic, ToJSON, FromJSON)

inlineKeyboardMarkup inline_keyboard = InlineKeyboardMarkup inline_keyboard

data InlineKeyboardButton = InlineKeyboardButton {
    inline_button_text               :: String,
    inline_button_callback_data      :: String
} deriving (Eq, Show, Generic)

instance ToJSON InlineKeyboardButton where
    toJSON = toJsonDrop 14
instance FromJSON InlineKeyboardButton where
    parseJSON = parseJsonDrop 14

inlineKeyboardButton text callback_data = InlineKeyboardButton text callback_data


getTelegramUpdateId (TelegramUpdate update_id _ _) = update_id

getTelegramUpdate (TelegramUpdate update_id message query) = (update_id, message, query)
