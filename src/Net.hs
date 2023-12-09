module Net (runServer) where

import Control.Concurrent (forkIO)
import GHC.IO.Handle (hGetContents)
import GHC.IO.IOMode (IOMode (ReadMode))
import Lib
import Network.Socket
import Text.Printf (printf)

runServer :: Integer -> Canvas -> IO ()
runServer port canvas = withSocketsDo $ do
  sock <- socket AF_INET Stream defaultProtocol
  bind sock (SockAddrInet (fromInteger port) 0)
  listen sock 3
  putStrLn $ printf "Listening on Port %d" port
  socketHandler sock canvas

socketHandler :: Socket -> Canvas -> IO ()
socketHandler sock canvas = do
  (conn, _) <- accept sock
  putStrLn "Got new connection!"
  h <- socketToHandle conn ReadMode
  _ <- forkIO $ connectionHandler h

  socketHandler sock canvas
  where
    connectionHandler handle = do
      content <- lines <$> hGetContents handle
      mapM_ (handleUpdate canvas) content
