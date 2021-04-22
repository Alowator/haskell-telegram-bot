{-# LANGUAGE TypeOperators    #-}
{-# LANGUAGE DataKinds        #-}

module Telegram.API (
    module TYPES,
    Token (..),
    startPooling,
    idle,
    getMe,
    getUpdates,
    sendMessage,
) where

import Data.Proxy
import Servant.API
import Control.Concurrent
import Control.Monad
import Control.Monad.IO.Class
import Servant.Client.Core.ClientError
import Network.HTTP.Client (Manager)

import Telegram.API.Core
import Telegram.API.Get
import Telegram.API.Messages
import Telegram.API.Updates

import Telegram.Requests
import Telegram.Responses
import Telegram.Types       as TYPES

updatesHandler [] _ = do
    return 0
updatesHandler (update:updates) userUpdatesHandler = do
    userUpdatesHandler (getTelegramUpdate update)
    let id = getTelegramUpdateId update
    case updates of
        [] -> return (id + 1)
        otherwise -> updatesHandler updates userUpdatesHandler

poolingLoop :: Integer -> Token -> Manager -> ((Integer, Maybe TelegramMessage, Maybe TelegramCallbackQuery) -> IO ()) -> IO ()
poolingLoop last_id token manager userUpdatesHandler = do

    getUpdatesRes <- getUpdates token manager last_id
    let Right (Response {result = updates}) = getUpdatesRes

    new_last_id <- updatesHandler updates userUpdatesHandler

    threadDelay 10000
    poolingLoop new_last_id token manager userUpdatesHandler


startPooling :: Token -> Manager -> ((Integer, Maybe TelegramMessage, Maybe TelegramCallbackQuery) -> IO ()) -> IO ()
startPooling token manager userUpdatesHandler = do
  forkIO (poolingLoop 0 token manager userUpdatesHandler)
  putStrLn "Pooler started"


idleLoop :: IO ()
idleLoop = do
    threadDelay 1000000
    idleLoop


idle :: IO ()
idle = do
    putStrLn "Idle start (Press Ctrl+C to exit)"
    idleLoop
    putStrLn "Idle finish"
