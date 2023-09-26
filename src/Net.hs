module Net where

import Network.Socket
import GHC.IO.IOMode (IOMode(ReadMode))
import GHC.IO.Handle (hGetLine)
import Text.Printf (printf)


runServer :: Integer -> IO ()
runServer port = withSocketsDo $ do
    sock <- socket AF_INET Stream defaultProtocol
    bind sock (SockAddrInet (fromInteger port) 0)
    listen sock 3
    putStrLn $ printf "Listening on Port %d" port
    socketHandler sock

socketHandler :: Socket -> IO ()
socketHandler sock = do
    (conn, _) <- accept sock
    putStrLn "got new connection!"
    h <- socketToHandle conn ReadMode
    content <- hGetLine h
    putStrLn "Recursing"
    socketHandler sock





