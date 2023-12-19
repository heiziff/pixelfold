# pixelfold - Basic Pixelflut server written in Haskell

Requirements
------------
- Haskell Stack

Installation
------------
    git clone https://github.com/AlbinoBoi/pixelfold.git
    cd pixelfold
    stack build

Usage
-----

    stack exec pixelfold-exe


The server then listens for TCP messages on Port 4242.


The server defines the following Commands:
- __Draw__: draws pixel at position (pos_x, pos_y) with value RRGGBBAA (in hex)
Expects messages with the following format: "Draw (pos_x,pos_y) 0xRRGGBBAA\n"
- __Help__: Displays help text
