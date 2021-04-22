{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Telegram.API.Messages (
    TelegramMessagesAPI,
    sendMessage
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


type TelegramMessagesAPI = 
    TelegramToken :> "sendMessage"
    :> ReqBody '[JSON] SendMessageRequest
    :> Get '[JSON] SendMessageResponse

messagesApi :: Proxy TelegramMessagesAPI
messagesApi = Proxy

search = client messagesApi 

query :: Token -> SendMessageRequest -> ClientM SendMessageResponse
query token request = do
    t <- search token request
    return t

sendMessage token manager chat_id text reply_markup = runClientM 
                                                      (query token (sendMessageRequest chat_id text reply_markup)) 
                                                      (mkClientEnv manager telegramUrl)



