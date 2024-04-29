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
import Data.Attoparsec.ByteString.Char8 (Parser, char, decimal, hexadecimal, parseOnly, skipSpace, string)
import Data.ByteString.Char8 (pack)
import Data.Tuple (swap)
import Data.Vector.Storable.Mutable (IOVector, write)
import Data.Word (Word32)
import GHC.IO.Handle (Handle, hPutStr)
import Text.Printf (printf)
import Text.Read (readMaybe)

type Coord = (Int, Int)

type Canvas = IOVector Word32

data Command = Draw Coord Word32 | Help
  deriving (Show, Eq)

helpStr :: String
helpStr = "To draw a Pixel, send a String of the Format: 'Draw (pos_x,pos_y) 0xRRGGBBAA\\n'\n"

canvasWidth :: Int
canvasWidth = 1900

canvasHeight :: Int
canvasHeight = 1300

parseCommand :: String -> Maybe Command
parseCommand [] = Nothing
parseCommand s
  | head w == "Help" = Just Help
  | head w == "Draw" = do
      pos <- getValidPos (w !! 1)
      Draw pos <$> readMaybe (w !! 2)
  where
    w = words s
parseCommand _ = Nothing

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
  if isInBounds (x, y) then return (y, x) else fail "Coordinates are out of bounds"
  where
    isInBounds (x, y) = x < canvasWidth && x >= 0 && y < canvasHeight && y >= 0

hexParser :: Parser Word32
hexParser = do
  void $ string "0x"
  hexadecimal

getValidPos :: String -> Maybe Coord
getValidPos s = do
  coord <- (readMaybe s :: Maybe Coord)
  swap <$> isInBounds coord
  where
    isInBounds c@(x, y) = if x < canvasWidth && x >= 0 && y < canvasHeight && y >= 0 then Just c else Nothing

runCommand :: Command -> Canvas -> Handle -> IO ()
runCommand Help _ handle = hPutStr handle helpStr
runCommand (Draw (x, y) rgba) canvas _ = do
  write canvas (x + y * canvasWidth) rgba

handleCommand :: Canvas -> Handle -> String -> IO ()
handleCommand canvas handle s =
  case parseOnly commandParser $ pack s of
    Left err -> putStrLn $ printf "Invalid command (%s): %s" s err
    Right cmd -> runCommand cmd canvas handle
