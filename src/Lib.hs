module Lib
    ( someFunc
    ) where

import Graphics.Image as I
import Control.Monad.State.Lazy

someFunc :: IO ()
someFunc = putStrLn "someFunc"

debugImg :: Image RPU Y Double
debugImg = makeImageR RPU (200, 200) (\(i, j) -> PixelY $ fromIntegral (i*j)) / (200*200)

gradColor :: Image RSU RGB Double
gradColor = makeImageR RSU (200, 200) (\(i, j) -> PixelRGB (fromIntegral i) (fromIntegral j) (fromIntegral (i + j))) / 400

type Img = MImage VU RGB Double


