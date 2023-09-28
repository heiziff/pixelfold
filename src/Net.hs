module Net 
    (runServer)
where

import Lib

import Network.Socket
import GHC.IO.IOMode (IOMode(ReadMode))
import GHC.IO.Handle (hGetContents)
import Text.Printf (printf)
import Data.IORef (IORef)
import Control.Monad (foldM_)
import Control.Concurrent (forkIO)

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
    --content <- hGetLine h
    _ <- forkIO $ connectionHandler h
    --newCanvas <- handleUpdate content canvas
    putStrLn "Recursing"
    socketHandler sock canvas

    where
        connectionHandler handle = do
            content <- hGetContents handle
            foldM_ (flip handleUpdate) canvas (lines content)










