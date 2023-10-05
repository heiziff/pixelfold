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
import Data.Array.Unboxed (elems, (//))
import Data.Serialize
import Graphics.Gloss.Interface.IO.Simulate (simulateIO)
import Data.Word (Word32)


-- Model consists of Reference to canvas and a cached image

canvasWidth :: Int
canvasWidth = 900

canvasHeight :: Int
canvasHeight = 900


window :: Display
window = InWindow "Pixelfold" (900, 900) (0,0)

background :: Color
background = white

startGUI :: IORef Canvas -> IORef [(Coord, Word32)] -> IO ()
startGUI canvas_ref update_ref = do
    simulateIO window background 5 (canvas_ref, update_ref, circle 80) getImage updateImage
    where
        getImage :: (IORef Canvas, IORef [(Coord, Word32)], Picture) -> IO Picture
        getImage (_, _, img) = return img

        updateImage _ _ (ca_ref, up_ref, _)= do
            canvas <- readIORef ca_ref
            updates <- readIORef up_ref
            let new_bytestr = encode . elems $ canvas // updates
            return (ca_ref, up_ref, bitmapOfByteString canvasWidth canvasHeight (BitmapFormat TopToBottom PxRGBA) new_bytestr False)