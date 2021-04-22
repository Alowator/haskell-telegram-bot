{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Telegram.API.Updates (
    TelegramUpdatesAPI,
    getUpdates
) where

import           Data.Proxy
import           Network.HTTP.Client     (newManager)
import           Network.HTTP.Client.TLS (tlsManagerSettings)
import           Servant.API
import           Servant.Client

import Telegram.API.Core
import Telegram.Requests
import Telegram.Responses
import Telegram.Types

type TelegramUpdatesAPI = 
    TelegramToken :> "getUpdates"
    :> ReqBody '[JSON] GetUpdatesRequest
    :> Get '[JSON] GetUpdatesResponse


updatesApi :: Proxy TelegramUpdatesAPI
updatesApi = Proxy

search = client updatesApi 

query :: Token -> GetUpdatesRequest -> ClientM GetUpdatesResponse
query token request = do
    t <- search token request
    return t


getUpdates token manager offset = runClientM 
                                  (query token (getUpdatesRequest offset)) 
                                  (mkClientEnv manager telegramUrl)

