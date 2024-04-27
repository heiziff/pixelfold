module Lib
  ( handleCommand,
    Canvas,
    canvasHeight,
    canvasWidth,
  )
where

import Data.Tuple (swap)
import Data.Vector.Storable.Mutable (IOVector, write)
import Data.Word (Word32)
import GHC.IO.Handle (Handle, hPutStr)
import Text.Printf (printf)
import Text.Read (readMaybe)

type Coord = (Int, Int)

type Canvas = IOVector Word32

data Command = Draw Coord Word32 | Help

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
  case parseCommand s of
    Nothing -> putStrLn $ printf "Invalid Command! '%s'" s
    Just cmd -> runCommand cmd canvas handle
