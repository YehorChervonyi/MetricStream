import asyncio
import websockets
import json

async def get_data_from_server():
    uri = "ws://localhost:36500"  # Server URI
    async with websockets.connect(uri) as websocket:
        # Receive JSON data from the server
        json_data = await websocket.recv()

        # Convert JSON data back into a Python dictionary
        data = json.loads(json_data)

        print("Received data:", data)

# Run the client
asyncio.run(get_data_from_server())
