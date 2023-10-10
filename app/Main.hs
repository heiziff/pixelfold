module Main (main) where

import Control.Concurrent (forkIO)
import Data.Array.IO (IOUArray)
import Data.Array.MArray
import Data.Word (Word32)
import Frontend (canvasHeight, canvasWidth, startGUI)
import Lib (Coord)
import Net (runServer)

main :: IO ()
main = do
  -- Ix type uses inclusive bounds *sigh*
  canvas <- newArray ((0, 0), (canvasWidth - 1, canvasHeight - 1)) 0
  _ <- forkIO $ startGUI (canvas :: IOUArray Coord Word32)
  _ <- runServer 4242 canvas
  putStrLn "Exiting"
