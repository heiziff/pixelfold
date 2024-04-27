module Frontend
  ( startGUI,
  )
where

import Control.Concurrent (threadDelay)
import Control.Monad (unless)
import Data.Vector.Storable.Mutable (unsafeCast)
import Lib (Canvas, canvasHeight, canvasWidth)
import SDL

startGUI :: Window -> Canvas -> IO ()
startGUI window canvas = do
  renderer <- createRenderer window (-1) (RendererConfig AcceleratedVSyncRenderer True)
  appLoop window canvas renderer
  destroyWindow window

appLoop :: Window -> Canvas -> Renderer -> IO ()
appLoop window canvas renderer = do
  events <- pollEvents
  let isEscapePressed event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed
              && keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeEscape
          _ -> False
      qPressed = any isEscapePressed events
  newSurface <- createRGBSurfaceFrom (unsafeCast canvas) (V2 (fromIntegral canvasWidth) (fromIntegral canvasHeight)) (fromIntegral canvasWidth * 4) RGBA8888
  texture <- createTextureFromSurface renderer newSurface
  copy renderer texture Nothing Nothing
  present renderer
  destroyTexture texture
  threadDelay 100000 -- short delay to prevent CPU from exploding
  unless qPressed (appLoop window canvas renderer)