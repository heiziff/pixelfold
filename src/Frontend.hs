module Frontend where

import Lib

import Data.IORef
import Graphics.Gloss
import Data.Array.Unboxed (elems)
import Data.Serialize


window :: Display
window = InWindow "Pixelfold" (800, 800) (0,0)

background :: Color
background = white

drawing :: Picture
drawing = circle 80

startGUI :: IORef Canvas -> IO ()
startGUI canvas_ref = do 
    canvas <- readIORef canvas_ref
    let bytestr = encode $ elems canvas
    let pic = bitmapOfByteString 800 800 (BitmapFormat TopToBottom PxRGBA) bytestr False
    display window background pic