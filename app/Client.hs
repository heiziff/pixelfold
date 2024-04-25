{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}
module Client where
import Graphics.Image (index, dims, readImageRGBA, VU (..))
import Network.Socket
    ( connect,
      openSocket,
      getAddrInfo,
      defaultHints,
      close,
      withSocketsDo,
      ServiceName,
      HostName,
      SocketType(Stream),
      AddrInfo(addrAddress, addrSocketType),
      Socket )
import qualified Control.Exception as E
import Network.Socket.ByteString (sendAll)
import Graphics.Image.Interface (toWord8, ColorSpace (toComponents))
import qualified Data.ByteString.Char8 as BS
import Data.Word (Word8)
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
  let idx = [(x,y) | x <- [0..xBound - 1], y <- [0..yBound - 1]]
  let messages = map (generateMessage img) idx
  mapM_ (sendAll sock) messages
  
runTCPClient :: HostName -> ServiceName -> (Socket -> IO a) -> IO a
runTCPClient host port client = withSocketsDo $ do
    addr <- resolve
    E.bracket (open addr) close client
  where
    resolve = do
        let hints = defaultHints { addrSocketType = Stream }
        head <$> getAddrInfo (Just hints) (Just host) (Just port)
    open addr = E.bracketOnError (openSocket addr) close $ \sock -> do
        connect sock $ addrAddress addr
        return sock


generateMessage img pos = BS.pack $ printf "Draw %s 0x%02x%02x%02x%02x\n" (show $ swap pos) r g b a
  where 
    comps :: (Word8, Word8, Word8, Word8)
    comps@(r, g, b, a) = toComponents $ toWord8 <$> index img pos

    swap (x, y) = (y, x)

