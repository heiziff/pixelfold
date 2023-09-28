module Frontend
    (
        canvasWidth,
        canvasHeight,
        startGUI
    )

where

import Lib

import Data.IORef
import Graphics.Gloss
import Data.Array.Unboxed (elems)
import Data.Serialize
import Graphics.Gloss.Interface.IO.Display (displayIO, Controller (Controller))

canvasWidth :: Int
canvasWidth = 20

canvasHeight :: Int
canvasHeight = 20


window :: Display
window = InWindow "Pixelfold" (900, 900) (0,0)

background :: Color
background = white

startGUI :: IORef Canvas -> IO ()
startGUI canvas_ref = do 
    displayIO window background imgUpdate (\(Controller s _) -> s)
    where
        imgUpdate :: IO Picture
        imgUpdate = do
            canvas <- readIORef canvas_ref
            print canvas
            let new_bytestr = encode $ elems canvas
            return $ bitmapOfByteString canvasWidth canvasHeight (BitmapFormat TopToBottom PxRGBA) new_bytestr False

