{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Control.Concurrent (forkIO)
import Control.Monad (void)
import qualified Data.Vector.Storable.Mutable as V
import Data.Word (Word32)
import Frontend (startGUI)
import Lib (Coord, canvasHeight, canvasWidth)
import Net (runServer)
import SDL

main :: IO ()
main = do
  initializeAll
  window <- createWindow "pixelfold" (WindowConfig True False False Windowed NoGraphicsContext Wherever True (V2 (fromIntegral canvasWidth + 20) (fromIntegral canvasHeight + 20)) True)
  canvas :: V.IOVector Word32 <- V.replicate (canvasWidth * canvasHeight) 0xFF0000FF
  void . forkIO $ runServer 4242 canvas
  void $ startGUI window canvas
  putStrLn "Exiting"
