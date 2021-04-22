{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Telegram.API.Core (
    telegramUrl,
    Token (..),
    TelegramToken
) where

import Servant.API
import Servant.Client

newtype Token = Token String
  deriving (Show, Eq, Ord, ToHttpApiData, FromHttpApiData)

type TelegramToken = Capture ":token" Token

telegramUrl :: BaseUrl
telegramUrl = BaseUrl Https "api.telegram.org" 443 ""
