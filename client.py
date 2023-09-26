import socket

host = socket.gethostname()
port = 4242                   # The same port as used by the server
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((host, port))
s.sendall(b'Draw (10,10) 42')
s.close()
