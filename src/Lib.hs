module Lib
    ( handleUpdate,
      Canvas,
      Coord
    ) where

import Data.Array.Unboxed
import Data.Word (Word32)
import Text.Read (readMaybe)
import Data.IORef (IORef, modifyIORef')

type Coord = (Int, Int)

type Canvas = UArray Coord Word32

data Command = Draw Coord Word32 | Help

parseCommand :: String -> Maybe Command
parseCommand [] = Nothing
parseCommand s 
    | cstr == "Help" = Just Help
    | cstr == "DrawBackup" = case maypos of
        Nothing -> Nothing
        Just pos -> case mayrgba of 
            Just rgba -> Just $ Draw pos rgba
            Nothing -> Nothing
    | cstr == "Draw" = do
        pos <- readMaybe (w !! 1)
        Draw pos <$> readMaybe (w !! 2)
    where
        w = words s
        cstr = head w
        maypos = readMaybe (w !! 1)
        mayrgba  = readMaybe $ last w
parseCommand _ = Nothing


runCommand :: Command -> IORef [(Coord, Word32)] -> IO ()
runCommand Help _ = do
    putStrLn "TODO"
    return ()
runCommand (Draw idx rgba) update_ref = do 
    modifyIORef' update_ref (\updates -> (idx, rgba) : updates)
    return ()


handleUpdate :: IORef [(Coord, Word32)] -> String -> IO ()
handleUpdate update_ref s = do
    let mC = parseCommand s
    case mC of
        Nothing -> do 
            putStrLn "Invalid Command!"
            return ()
        Just cmd -> runCommand cmd update_ref


