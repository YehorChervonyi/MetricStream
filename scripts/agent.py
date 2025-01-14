from Info import *
import asyncio
import websockets
import json

print("==========MetricStream Agent==========")
print("Your UID: " + get_ip_address())

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
    server = await websockets.serve(handle_client, "0.0.0.0", 36500)
    print("WebSocket server started on ws://0.0.0.0:36500")
    await server.wait_closed()  # Keep the server running

asyncio.run(start_server())
