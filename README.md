# pixelfold - Pixelflut server written in Haskell with SDL

Requirements
------------
- Haskell Stack, easiest installed via [GHCup](https://www.haskell.org/ghcup/)
- SDL2 and SDL2 development Headers (Example for Fedora)
    ```
    dnf install SDL2 SDL2-devel
    ```

Installation
------------
    git clone https://github.com/heiziff/pixelfold.git
    cd pixelfold
    stack build

- Binaries compiled via `stack build` are only runnable from the project directory. If you want to be able to run pixelfold from anywhere, consider using `stack install`

Usage
-----

    stack exec pixelfold-exe <portnumber>


The server then listens for TCP messages on Port `<portnumber>` or Port 4242, if none was specified.


The server accepts the following Commands:
- __Draw__: colors the pixel at position (pos_x, pos_y) with the 32-bit color value RRGGBBAA (in hex)

    - Expects messages with the following format: "Draw (pos_x,pos_y) 0xRRGGBBAA\n"

- __Help__: Sends back the help text
