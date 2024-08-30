import http.server
import ssl

# Server address
server_address = ('', 4443)

# Create an HTTP server handler
httpd = http.server.HTTPServer(server_address, http.server.SimpleHTTPRequestHandler)

# Wrap the server with SSL using the generated certificates
httpd.socket = ssl.wrap_socket(httpd.socket, 
                               keyfile="key.pem", 
                               certfile="cert.pem", 
                               server_side=True)

# Run the server
print("Serving on https://localhost:4443")
httpd.serve_forever()
