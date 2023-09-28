module Main (main) where


import Control.Concurrent (forkIO)
import Data.Array.Unboxed
import Data.Word (Word32)
import Data.IORef (newIORef)

import Frontend (startGUI, canvasWidth, canvasHeight)
import Net (runServer)


main :: IO ()
main = do 
    let canvas = array ((0,0), (canvasWidth, canvasHeight)) [] :: UArray (Int, Int) Word32
    canvas_ref <- newIORef canvas
    gui_id <- forkIO $ startGUI canvas_ref
    runServer 4242 canvas_ref
    putStrLn "Exiting"
