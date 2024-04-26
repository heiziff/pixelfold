module Frontend
  ( startGUI,
  )
where

import Control.Monad (unless)
import Data.Array.IO (getElems)
import Data.Serialize (encode)
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Simulate (ViewPort, simulateIO)
import Lib
import Linear (V4 (..))
import SDL

-- Model consists of Reference to canvas and a cached image

window :: Display
window = InWindow "Pixelfold" (canvasWidth, canvasHeight) (0, 0)

background :: Color
background = white

startGUI :: Canvas -> IO ()
startGUI canvas = simulateIO window background 2 (canvas, circle 80) getImage updateImage
  where
    getImage :: (Canvas, Picture) -> IO Picture
    getImage (_, img) = return img

    updateImage :: ViewPort -> Float -> (Canvas, Picture) -> IO (Canvas, Picture)
    updateImage _ _ (ca, _) = do
      content <- getElems ca
      let new_bytestr = encode content
      return (ca, bitmapOfByteString canvasWidth canvasHeight (BitmapFormat TopToBottom PxRGBA) new_bytestr False)
