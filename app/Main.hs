{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Control.Concurrent (forkIO)
import Control.Monad (void)
import qualified Data.Vector.Storable.Mutable as V
import Frontend (startGUI)
import Lib (Canvas, canvasHeight, canvasWidth)
import Net (runServer)
import System.Environment (getArgs)
import Text.Read (readMaybe)

type Args = Int

defaultPort :: Int
defaultPort = 4242

main :: IO ()
main = do
  result <- parseArgs <$> getArgs
  case result of
    Left err -> do
      putStrLn err
    Right portnum -> do
      canvas :: Canvas <- V.replicate (canvasWidth * canvasHeight) 0xFFFFFFFF
      void . forkIO $ runServer portnum canvas
      void $ startGUI canvas
      putStrLn "Exiting"

parseArgs :: [String] -> Either String Args
parseArgs [] = Right defaultPort
parseArgs [s] = case readMaybe s of
  Nothing -> Left "Invalid Port Number"
  Just num -> Right num
parseArgs _ = Left "Too many Arguments"