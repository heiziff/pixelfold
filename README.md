# pixelfold - Pixelflut server written in Haskell with SDL

Requirements
------------
- Haskell Stack

Installation
------------
    git clone https://github.com/heiziff/pixelfold.git
    cd pixelfold
    stack build

Usage
-----

    stack exec pixelfold-exe <portnumber>


The server then listens for TCP messages on Port \<portnumber\> or Port 4242, if none was specified.


The server accepts the following Commands:
- __Draw__: draws pixel at position (pos_x, pos_y) with the 32-bit value RRGGBBAA (in hex)
Expects messages with the following format: "Draw (pos_x,pos_y) 0xRRGGBBAA\n"
- __Help__: Displays help text
