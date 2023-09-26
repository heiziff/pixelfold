module Frontend where

import Graphics.Gloss

window :: Display
window = InWindow "Pixelfold" (800, 800) (0,0)

background :: Color
background = white

drawing :: Picture
drawing = circle 80

startGUI :: IO ()
startGUI = display window background drawing