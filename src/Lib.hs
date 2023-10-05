module Lib
    ( handleUpdate,
      Canvas,
      Coord
    ) where

import Data.Array.IO
import Data.Word (Word32)
import Text.Read (readMaybe)

type Coord = (Int, Int)

type Canvas = IOUArray Coord Word32

data Command = Draw Coord Word32 | Help

parseCommand :: String -> Maybe Command
parseCommand [] = Nothing
parseCommand s 
    | cstr == "Help" = Just Help
    | cstr == "Draw" = do
        pos <- readMaybe (w !! 1)
        Draw pos <$> readMaybe (w !! 2)
    where
        w = words s
        cstr = head w
parseCommand _ = Nothing


runCommand :: Command -> Canvas -> IO ()
runCommand Help _ = do
    putStrLn "TODO"
    return ()
runCommand (Draw idx rgba) canvas = do 
    writeArray canvas idx rgba
    return ()


handleUpdate :: Canvas -> String -> IO ()
handleUpdate update_ref s = do
    let mC = parseCommand s
    case mC of
        Nothing -> do 
            putStrLn "Invalid Command!"
            return ()
        Just cmd -> runCommand cmd update_ref


