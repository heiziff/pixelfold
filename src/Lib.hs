module Lib
  ( handleUpdate,
    Canvas,
    Coord,
  )
where

import Data.Array.IO
import Data.Tuple (swap)
import Data.Word (Word32)
import Text.Read (readMaybe)

type Coord = (Int, Int)

type Canvas = IOUArray Coord Word32

data Command = Draw Coord Word32 | Help

parseCommand :: String -> Maybe Command
parseCommand [] = Nothing
parseCommand s
  | head w == "Help" = Just Help
  | head w == "Draw" = do
      pos <- readMaybe (w !! 1)
      let newPos = swap pos
      Draw newPos <$> readMaybe (w !! 2)
  where
    w = words s
parseCommand _ = Nothing

runCommand :: Command -> Canvas -> IO ()
runCommand Help _ = putStrLn "TODO"
runCommand (Draw idx rgba) canvas = writeArray canvas idx rgba

handleUpdate :: Canvas -> String -> IO ()
handleUpdate update_ref s =
  case parseCommand s of
    Nothing -> putStrLn "Invalid Command!"
    Just cmd -> runCommand cmd update_ref
