{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module Client where

import qualified Control.Exception as E
import qualified Data.ByteString.Char8 as BS
import Data.Word (Word8)
import Graphics.Image (VU (..), dims, index, readImageRGBA)
import Graphics.Image.Interface (ColorSpace (toComponents), toWord8)
import Network.Socket
  ( AddrInfo (addrAddress, addrSocketType),
    HostName,
    ServiceName,
    Socket,
    SocketType (Stream),
    close,
    connect,
    defaultHints,
    getAddrInfo,
    openSocket,
    withSocketsDo,
  )
import Network.Socket.ByteString (sendAll)
import Text.Printf (printf)

portNumber :: String
portNumber = "4242"

ipAddr :: String
ipAddr = "127.0.01"

type Position = (Int, Int)

main :: IO ()
main = runTCPClient ipAddr portNumber imageLoop

imageLoop :: Socket -> IO ()
imageLoop sock = do
  img <- readImageRGBA VU "die.png"
  let (xBound, yBound) = dims img
  let idx = [(x, y) | x <- [0 .. xBound - 1], y <- [0 .. yBound - 1]]
  let messages = map (generateMessage img) idx
  mapM_ (sendAll sock) messages

runTCPClient :: HostName -> ServiceName -> (Socket -> IO ()) -> IO ()
runTCPClient host port client = withSocketsDo $ do
  addr <- resolve
  E.bracket (open addr) close client
  where
    resolve = do
      let hints = defaultHints {addrSocketType = Stream}
      head <$> getAddrInfo (Just hints) (Just host) (Just port)
    open addr = E.bracketOnError (openSocket addr) close $ \sock -> do
      connect sock $ addrAddress addr
      return sock

generateMessage img pos = BS.pack $ printf "Draw %s 0x%02x%02x%02x%02x\n" (show $ swap pos) r g b a
  where
    comps :: (Word8, Word8, Word8, Word8)
    comps@(r, g, b, a) = toComponents $ toWord8 <$> index img pos

    swap (x, y) = (y, x)
