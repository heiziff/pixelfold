module Frontend
    (
        canvasWidth,
        canvasHeight,
        startSimGUI
    )

where

import Lib

import Data.IORef
import Graphics.Gloss
import Data.Array.Unboxed (elems)
import Data.Serialize
import Graphics.Gloss.Interface.IO.Display (Controller (Controller))
import Graphics.Gloss.Interface.IO.Animate (animateIO)
import Graphics.Gloss.Interface.IO.Simulate (simulateIO)


-- Model consists of Reference to canvas and a cached image

canvasWidth :: Int
canvasWidth = 900

canvasHeight :: Int
canvasHeight = 900


window :: Display
window = InWindow "Pixelfold" (900, 900) (0,0)

background :: Color
background = white

startGUI :: IORef Canvas -> IO ()
startGUI canvas_ref = do 
    animateIO window background (const imgUpdate) (\(Controller s _) -> s)
    where
        imgUpdate :: IO Picture
        imgUpdate = do
            canvas <- readIORef canvas_ref
            let new_bytestr = encode $ elems canvas
            return $ bitmapOfByteString canvasWidth canvasHeight (BitmapFormat TopToBottom PxRGBA) new_bytestr False

startSimGUI :: IORef Canvas -> IO ()
startSimGUI canvas_ref = do
    simulateIO window background 5 (canvas_ref, circle 80) getImage updateImage
    where
        getImage :: (IORef Canvas, Picture) -> IO Picture
        getImage (_, img) = return img

        updateImage _ _ (ca_ref, _)= do
            canvas <- readIORef ca_ref
            let new_bytestr = encode $ elems canvas
            return (ca_ref, bitmapOfByteString canvasWidth canvasHeight (BitmapFormat TopToBottom PxRGBA) new_bytestr False)