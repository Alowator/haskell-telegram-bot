{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators     #-}

import Network.HTTP.Client     (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Servant.API
import Servant.Client

import Telegram.API

get_test_keyboard = inlineKeyboardMarkup [[inlineKeyboardButton "kek1" "lul1", inlineKeyboardButton "kek3" "lul3"], [inlineKeyboardButton "kek2" "lul2"]]


updatesHandler :: (Integer, Maybe TelegramMessage, Maybe TelegramCallbackQuery) -> IO ()
updatesHandler (update_id, message, query) = do
    if message == Nothing then
        print query
    else
        print message


main :: IO ()
main = do
    let token = Token "bot1232822347:AAG2jUe63OcoIo0dzGy14xl9OneKrDrPgNs"
    manager <- newManager tlsManagerSettings

    getMeRes <- getMe token manager
    print getMeRes

    sendMessageRes <- sendMessage token manager 366785436 "s;fldslf;" Nothing
    print sendMessageRes  

    sendMessageRes <- sendMessage token manager 366785436 "test_keyboard" (Just get_test_keyboard)
    print sendMessageRes  

    getUpdatesRes <- getUpdates token manager 0
    print getUpdatesRes

    startPooling token manager updatesHandler
    idle
