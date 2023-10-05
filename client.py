import socket
import sys
from PIL import Image
import numpy as np

# read image
img = Image.open(sys.argv[1])
img = img.convert("RGBA")
img_arr = np.array(img)

# connect to server
host = socket.gethostname()
port = 4242                   # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))


def send_pixel(x,y):
    r = img_arr[x][y][0]
    g = img_arr[x][y][1]
    b = img_arr[x][y][2]

    message = b'Draw (%d,%d) 0x%02x%02x%02x%02x\n' % (x,y,r,g,b,255)
    #print(f"Sending: {message}")
    s.send(message)

if __name__ == '__main__':
    while True:
        width, height = np.size(img_arr, 0), np.size(img_arr, 1)
        for x in range(width):
            for y in range(height):
                send_pixel(x,y)
s.close()
