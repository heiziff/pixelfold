# pixelfold - Pixelflut server written in Haskell with SDL

## Requirements
- SDL2 and SDL2 development Headers (Example for Fedora)
    ```
    dnf install SDL2 SDL2-devel
    ```

## Build
    git clone https://github.com/heiziff/pixelfold.git
    cd pixelfold
    stack build

- Binaries compiled via `stack build` are only runnable from the project directory. If you want to be able to run pixelfold from anywhere, consider using `stack install` or simply download the latest release from github.
- To build, the Haskell Stack build system is required. Can be installed via [GHCup](https://www.haskell.org/ghcup/)

## Usage
### Self-built

    stack exec pixelfold-exe <portnumber>

### Binary Release

    ./pixelfold-exe <portnumber>

The server then listens for TCP messages on Port `<portnumber>` or Port 4242, if none was specified.


The server accepts the following Commands:
- __Draw__: colors the pixel at position (pos_x, pos_y) with the 32-bit color value 0xRRGGBBAA

    - Expects messages with the following format: "Draw (pos_x,pos_y) 0xRRGGBBAA\n"

- __Help__: Sends back the help text
