module Frontend
  ( startGUI,
  )
where

import Control.Monad (unless)
import Data.Functor (void)
import Data.Vector.Storable.Mutable (IOVector, unsafeCast)
import Data.Word (Word32)
import Lib
import SDL

-- Model consists of Reference to canvas and a cached image

startGUI :: Window -> IOVector Word32 -> IO ()
startGUI window canvas = do
  appLoop window canvas
  destroyWindow window

appLoop :: Window -> IOVector Word32 -> IO ()
appLoop window canvas = do
  events <- pollEvents
  let eventIsQPress event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed
              && keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeEscape
          _ -> False
      qPressed = any eventIsQPress events
  winSurface <- getWindowSurface window
  newSurface <- createRGBSurfaceFrom (unsafeCast canvas) (V2 (fromIntegral canvasWidth) (fromIntegral canvasHeight)) (fromIntegral canvasWidth * 4) RGBA8888
  void $ surfaceBlit newSurface Nothing winSurface Nothing
  updateWindowSurface window
  unless qPressed (appLoop window canvas)