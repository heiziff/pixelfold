{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Control.Concurrent (forkIO)
import Control.Monad (void)
import qualified Data.Vector.Storable.Mutable as V
import Frontend (startGUI)
import Lib (Canvas, canvasHeight, canvasWidth)
import Net (runServer)

main :: IO ()
main = do
  canvas :: Canvas <- V.replicate (canvasWidth * canvasHeight) 0xFFFFFFFF
  void . forkIO $ runServer 4242 canvas
  void $ startGUI canvas
  putStrLn "Exiting"
