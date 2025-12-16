{-# LANGUAGE OverloadedStrings #-}

module Lib
  ( handleCommand,
    Canvas,
    canvasHeight,
    canvasWidth,
  )
where

import Control.Applicative (Alternative ((<|>)))
import Control.Monad (void)
import Data.Attoparsec.ByteString.Char8 (Parser, decimal, hexadecimal, space, string)
import Data.Attoparsec.ByteString.Lazy (parseOnly)
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Vector.Storable.Mutable (IOVector, write)
import qualified Data.Vector.Storable.Mutable as DVSM
import Data.Word (Word32)
import GHC.IO.Handle (Handle, hPutStr)
import Text.Printf (printf)

type Coord = (Int, Int)

type Canvas = IOVector Word32

data Command = Draw Coord Word32 | Help | GetColor Coord | Size
  deriving (Show, Eq)

helpStr :: String
helpStr = "HELP: To draw a Pixel, send a String of the Format: 'PX <pos_x> <pos_y> <AARRGGBB>\\n'. The ARGB values should be in hex.\n"

getColorStr :: Coord -> Word32 -> String
getColorStr (x, y) = printf "PX %d %d %x\n" x y

canvasWidth :: Int
canvasWidth = 1800

canvasHeight :: Int
canvasHeight = 1000

runCommand :: Command -> Canvas -> Handle -> IO ()
runCommand Help _ handle = hPutStr handle helpStr
runCommand (Draw (x, y) argb) canvas _
  | x < canvasWidth && y < canvasHeight = write canvas (x + y * canvasWidth) argb
  | otherwise = pure ()
runCommand Size _ handle = hPutStr handle $ printf "SIZE %dx%d\n" canvasWidth canvasHeight
runCommand (GetColor coord@(x, y)) canvas handle
  | x < canvasWidth && y < canvasHeight = DVSM.read canvas (x + y * canvasWidth) >>= hPutStr handle . getColorStr coord
  | otherwise = pure ()

handleCommand :: Canvas -> Handle -> ByteString -> IO ()
handleCommand canvas handle rawCommand =
  case parseOnly commandParser rawCommand of
    Left err -> hPutStr handle $ printf "ERR: Invalid command (%s). Parse Error in: %s\n" (decodeUtf8 rawCommand) err
    Right cmd -> runCommand cmd canvas handle

commandParser :: Parser Command
commandParser = drawParser <|> helpParser <|> getColorParser <|> sizeParser

sizeParser :: Parser Command
sizeParser = string "SIZE" >> pure Size

getColorParser :: Parser Command
getColorParser = do
  void $ string "PX"
  void space
  GetColor <$> coordParser

helpParser :: Parser Command
helpParser = string "HELP" >> pure Help

drawParser :: Parser Command
drawParser = do
  void $ string "PX"
  void space
  coord <- coordParser
  void space
  Draw coord <$> hexParser

coordParser :: Parser Coord
coordParser = do
  x <- decimal
  void space
  y <- decimal
  pure (x, y)

hexParser :: Parser Word32
hexParser = hexadecimal
