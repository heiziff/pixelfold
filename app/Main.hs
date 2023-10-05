module Main (main) where

import Frontend (startGUI, canvasWidth, canvasHeight)
import Net (runServer)
import Lib (Coord)

import Control.Concurrent (forkIO)
import Data.Array.MArray
import Data.Word (Word32)
import Data.Array.IO (IOUArray)


main :: IO ()
main = do 
    canvas <- newArray_ ((0,0), (canvasWidth, canvasHeight))
    _ <- forkIO $ startGUI (canvas :: IOUArray Coord Word32)
    _ <- runServer 4242 canvas
    putStrLn "Exiting"
