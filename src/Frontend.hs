{-# LANGUAGE OverloadedStrings #-}

module Frontend
  ( startGUI,
  )
where

import Control.Monad (unless)
import Data.Array.IO (getElems)
import Data.Array.MArray (getAssocs)
import Data.Serialize (encode)
import Data.Word (Word32)
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Simulate (ViewPort, simulateIO)
import Lib
import Linear (V4 (..))
import SDL
import Text.Printf (printf)

-- Model consists of Reference to canvas and a cached image

startGUI :: Canvas -> IO ()
startGUI canvas = do
  initializeAll
  window <- createWindow "pixelfold" (WindowConfig True False False Windowed NoGraphicsContext Wherever True (V2 (fromIntegral canvasWidth) (fromIntegral canvasHeight)) True)
  renderer <- createRenderer window (-1) defaultRenderer
  rendererDrawColor renderer $= V4 255 255 255 255
  clear renderer
  appLoop renderer canvas
  destroyWindow window

appLoop :: Renderer -> Canvas -> IO ()
appLoop renderer canvas = do
  events <- pollEvents
  let eventIsQPress event =
        case eventPayload event of
          KeyboardEvent keyboardEvent ->
            keyboardEventKeyMotion keyboardEvent == Pressed
              && keysymKeycode (keyboardEventKeysym keyboardEvent) == KeycodeQ
          _ -> False
      qPressed = any eventIsQPress events
  content <- getAssocs canvas
  mapM_ drawPixel content
  present renderer
  unless qPressed (appLoop renderer canvas)
  where
    drawPixel ((x, y), rgba) = do
      let (r, g, b, a) = word32toWord8 rgba
      rendererDrawColor renderer $=! V4 r g b a
      putStrLn $ printf "Drawing at (%d,%d) with 0x%02x%02x%02x%02x" x y r g b a
      drawPoint renderer (P $ V2 (fromIntegral x) (fromIntegral y))
      present renderer