module Net 
    (runServer)
where

import Lib

import Network.Socket
import GHC.IO.IOMode (IOMode(ReadMode))
import GHC.IO.Handle (hGetContents)
import Text.Printf (printf)
import Data.IORef (IORef)
import Control.Concurrent (forkIO)
import Data.Word (Word32)

runServer :: Integer -> IORef [(Coord, Word32)] -> IO (IORef Canvas)
runServer port update_ref = withSocketsDo $ do
    sock <- socket AF_INET Stream defaultProtocol
    bind sock (SockAddrInet (fromInteger port) 0)
    listen sock 3
    putStrLn $ printf "Listening on Port %d" port
    socketHandler sock update_ref

socketHandler :: Socket -> IORef [(Coord, Word32)] -> IO (IORef Canvas)
socketHandler sock update_ref = do
    (conn, _) <- accept sock
    putStrLn "Got new connection!"
    h <- socketToHandle conn ReadMode
    _ <- forkIO $ connectionHandler h

    putStrLn "Recursing"
    socketHandler sock update_ref

    where
        connectionHandler handle = do
            content <- lines <$> hGetContents handle
            mapM_ (handleUpdate update_ref) content
        










