{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Telegram.API.Get (
    TelegramGetAPI,
    getMe
) where

import           Data.Proxy
import           Network.HTTP.Client     (newManager)
import           Network.HTTP.Client.TLS (tlsManagerSettings)
import           Servant.API
import           Servant.Client

import Telegram.API.Core
import Telegram.Responses
import Telegram.Types

type TelegramGetAPI = 
    TelegramToken :> "getMe"
    :> Get '[JSON] GetMeResponse


getApi :: Proxy TelegramGetAPI
getApi = Proxy

search = client getApi 

query :: Token -> ClientM GetMeResponse
query token = do
    t <- search token
    return t


getMe token manager = runClientM 
                      (query token) 
                      (mkClientEnv manager telegramUrl)

