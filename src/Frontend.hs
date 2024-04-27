module Frontend
  ( startGUI,
  )
where

import Control.Monad (unless)
import Data.Functor (void)
import Data.Vector.Storable.Mutable (unsafeCast)
import Lib (Canvas, canvasHeight, canvasWidth)
import SDL

startGUI :: Window -> Canvas -> IO ()
startGUI window canvas = do
  appLoop window canvas
  destroyWindow window

appLoop :: Window -> Canvas -> IO ()
appLoop window canvas = do
  events <- pollEvents
  let isEscapePressed event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed
              && keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeEscape
          _ -> False
      qPressed = any isEscapePressed events
  winSurface <- getWindowSurface window
  newSurface <- createRGBSurfaceFrom (unsafeCast canvas) (V2 (fromIntegral canvasWidth) (fromIntegral canvasHeight)) (fromIntegral canvasWidth * 4) RGBA8888
  void $ surfaceBlit newSurface Nothing winSurface Nothing
  updateWindowSurface window
  unless qPressed (appLoop window canvas)