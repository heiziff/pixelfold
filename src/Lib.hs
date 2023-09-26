module Lib
    ( handleUpdate,
      someFunc,
      Canvas
    ) where

import Data.Array.Unboxed
import Control.Monad.State (State)
import Text.Printf (printf)
import Data.Word (Word32)
import Text.Read (readMaybe)
import Data.IORef (IORef, readIORef, modifyIORef')

type Canvas = UArray (Int, Int) Word32

data Command = Draw (Int, Int) Word32 | Help

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


someFunc :: IO ()
someFunc = putStrLn "someFunc"

runCommand :: Command -> IORef Canvas -> IO (IORef Canvas)
runCommand Help canvas = do
    putStrLn "TODO"
    return canvas
runCommand (Draw idx rgba) canvas_ref = do 
    modifyIORef' canvas_ref (\c -> c // [(idx, rgba)])
    return canvas_ref


handleUpdate :: String -> IORef Canvas -> IO (IORef Canvas)
handleUpdate s canvas_ref = do
    putStrLn $ printf "Got String %s" s
    let mC = parseCommand s
    case mC of
        Nothing -> do 
            putStrLn "Invalid Command"
            return canvas_ref
        Just cmd -> runCommand cmd canvas_ref


