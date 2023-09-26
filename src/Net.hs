module Net where

import Lib

import Network.Socket
import GHC.IO.IOMode (IOMode(ReadMode))
import GHC.IO.Handle (hGetLine)
import Text.Printf (printf)
import Data.IORef (IORef)

runServer :: Integer -> IORef Canvas -> IO (IORef Canvas)
runServer port canvas = withSocketsDo $ do
    sock <- socket AF_INET Stream defaultProtocol
    bind sock (SockAddrInet (fromInteger port) 0)
    listen sock 3
    putStrLn $ printf "Listening on Port %d" port
    socketHandler sock canvas

socketHandler :: Socket -> IORef Canvas -> IO (IORef Canvas)
socketHandler sock canvas = do
    (conn, _) <- accept sock
    putStrLn "Got new connection!"
    h <- socketToHandle conn ReadMode
    content <- hGetLine h
    newCanvas <- handleUpdate content canvas
    putStrLn "Recursing"
    socketHandler sock newCanvas





