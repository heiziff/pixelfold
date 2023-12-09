# pixelfold - Basic Pixelflut server written in Haskell

Requirements
------------
Haskell Tool Stack installed

Installation
------------
    git clone https://github.com/AlbinoBoi/pixelfold.git
    cd pixelfold
    stack build

Usage
-----

    stack exec pixelflut-exe


pixelflut listens for TCP messages on Port 4242.


The server defines Commands:
* __Draw__: draws pixel at position (pos_x, pos_y) with value rgba
Expects messages of form: "Draw (<pos_x>,<pos_y>) 0xrgba\n"
* __Help__: Displays help text (TODO)

