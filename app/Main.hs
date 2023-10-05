module Main (main) where

import Frontend (startGUI, canvasWidth, canvasHeight)
import Net (runServer)
import Lib (Coord)

import Control.Concurrent (forkIO)
import Data.Array.Unboxed
import Data.Word (Word32)
import Data.IORef (newIORef)



main :: IO ()
main = do 
    let canvas = array ((0,0), (canvasWidth, canvasHeight)) [] :: UArray (Int, Int) Word32
    canvas_ref <- newIORef canvas
    update_ref <- newIORef ([] :: [(Coord, Word32)])
    _ <- forkIO $ startGUI canvas_ref update_ref
    _ <- runServer 4242 update_ref
    putStrLn "Exiting"
