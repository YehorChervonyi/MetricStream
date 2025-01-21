from Info import *
import asyncio
import websockets
import json
import sys

port = 36500
ip = get_ip_address()

if (len(sys.argv)> 1):
    port= int(sys.argv[1])


print("==========MetricStream Agent==========")
print("Your IP: " + ip)

# A set to keep track of connected clients
connected_clients = set()

async def handle_client(websocket):
    """Handles an individual client connection."""
    connected_clients.add(websocket)
    print(f"New client connected: {websocket.remote_address}")

    try:
        while True:
            # Get the data and send it to the client
            data = getInfo()
            json_data = json.dumps(data)
            await websocket.send(json_data)
            await asyncio.sleep(1)  # Send data every second
    except websockets.exceptions.ConnectionClosed:
        print(f"Client disconnected: {websocket.remote_address}")
    finally:
        connected_clients.remove(websocket)

async def start_server():
    """Starts the WebSocket server."""
    server = await websockets.serve(handle_client, "0.0.0.0", port)
    print("WebSocket server started on ws://"+ip+":"+str(port))
    await server.wait_closed()  # Keep the server running



asyncio.run(start_server())
