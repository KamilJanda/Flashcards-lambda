module Main where

import qualified Lib
import Servant
import Network.Wai
import Network.Wai.Handler.Warp (run)


flashCard ::Lib.FlashCard
flashCard = Lib.FlashCard "Pusty" "Empty"

server :: Server Lib.Api
server = return flashCard


userAPI :: Proxy Lib.Api
userAPI = Proxy

app :: Application
app =   serve userAPI server

main :: IO ()
main = run 8000 app
