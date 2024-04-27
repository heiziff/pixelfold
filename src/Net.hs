module Net (runServer) where

import Control.Concurrent (forkFinally)
import Control.Exception (finally)
import Control.Monad (void)
import GHC.IO.Handle (hGetContents)
import GHC.IO.IOMode (IOMode (ReadWriteMode))
import Lib (Canvas, handleCommand)
import Network.Socket
import Text.Printf (printf)

runServer :: Int -> Canvas -> IO ()
runServer port canvas = withSocketsDo $ do
  sock <- socket AF_INET Stream defaultProtocol
  bind sock (SockAddrInet (fromIntegral port) 0)
  listen sock 3
  putStrLn $ printf "Listening on Port %d" port
  finally (handleSocket sock canvas) (close sock)

handleSocket :: Socket -> Canvas -> IO ()
handleSocket sock canvas = do
  (conn, addr) <- accept sock
  printf "Got new connection from %s\n" (show addr)
  handle <- socketToHandle conn ReadWriteMode
  void $ forkFinally (handleConnection handle) (const $ putStrLn "Peer killed connection")

  handleSocket sock canvas
  where
    handleConnection handle = do
      content <- lines <$> hGetContents handle
      mapM_ (handleCommand canvas handle) content
