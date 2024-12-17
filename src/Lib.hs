{-# LANGUAGE OverloadedStrings #-}

module Lib (
    handleCommand,
    Canvas,
    canvasHeight,
    canvasWidth,
)
where

import Control.Applicative (Alternative ((<|>)))
import Control.Monad (void)
import Data.Attoparsec.ByteString.Char8 (Parser, char, decimal, hexadecimal, skipSpace, string)
import Data.Attoparsec.ByteString.Lazy (parseOnly)
import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Text.Lazy.Encoding (decodeUtf8)
import Data.Vector.Storable.Mutable (IOVector, write)
import Data.Word (Word32)
import GHC.IO.Handle (Handle, hPutStr)
import Text.Printf (printf)

type Coord = (Int, Int)

type Canvas = IOVector Word32

data Command = Draw Coord Word32 | Help
    deriving (Show, Eq)

helpStr :: String
helpStr = "To draw a Pixel, send a String of the Format: 'Draw (pos_x,pos_y) 0xRRGGBBAA\\n'\n"

canvasWidth :: Int
canvasWidth = 1800

canvasHeight :: Int
canvasHeight = 1000

runCommand :: Command -> Canvas -> Handle -> IO ()
runCommand Help _ handle = hPutStr handle helpStr
runCommand (Draw (x, y) rgba) canvas _ = write canvas (x + y * canvasWidth) rgba

handleCommand :: Canvas -> Handle -> ByteString -> IO ()
handleCommand canvas handle rawCommand =
    case parseOnly commandParser rawCommand of
        Left err -> putStrLn $ printf "Invalid command (%s): %s" (decodeUtf8 rawCommand) err
        Right cmd -> runCommand cmd canvas handle

commandParser :: Parser Command
commandParser = helpParser <|> drawParser

helpParser :: Parser Command
helpParser = string "Help" >> pure Help

drawParser :: Parser Command
drawParser = do
    void $ string "Draw"
    skipSpace
    coord <- coordParser
    skipSpace
    color <- hexParser
    return $ Draw coord color

coordParser :: Parser Coord
coordParser = do
    void $ char '('
    skipSpace
    x <- decimal
    skipSpace
    void $ char ','
    skipSpace
    y <- decimal
    skipSpace
    void $ char ')'
    if isInBounds (x, y) then return (x, y) else fail $ printf "Coordinates are out of bounds for (%d,%d)" canvasWidth canvasHeight
  where
    isInBounds (x, y) = y < canvasHeight && y >= 0 && x < canvasWidth && x >= 0

hexParser :: Parser Word32
hexParser = do
    void $ string "0x"
    hexadecimal
