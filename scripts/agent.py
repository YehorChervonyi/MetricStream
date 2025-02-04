import pystray
from pystray import MenuItem as item, Icon
from PIL import Image
import asyncio
import websockets
import json
import sys
from Info import get_ip_address, getInfo
import threading
import os

port = 36500
ip = get_ip_address()

if (len(sys.argv)> 1):
    port= int(sys.argv[1])


print("==========MetricStream Agent==========")
print("Your IP: " + ip)

# A set to keep track of connected clients
connected_clients = set()

async def handle_client(websocket):
    connected_clients.add(websocket)
    print(f"New client connected: {websocket.remote_address}")

    try:
        while True:
            data = getInfo()
            json_data = json.dumps(data)
            await websocket.send(json_data)
            await asyncio.sleep(1)
    except websockets.exceptions.ConnectionClosed:
        print(f"Client disconnected: {websocket.remote_address}")
    finally:
        connected_clients.remove(websocket)

async def start_server():
    server = await websockets.serve(handle_client, "0.0.0.0", port)
    print("WebSocket server started on ws://"+ip+":"+str(port))
    await server.wait_closed()

def create_image_from_path(image_path):
    try:
        image = Image.open(image_path)
        image = image.convert("RGBA")
        return image
    except Exception as e:
        print(f"Error loading image: {e}")
        return None

def quit_application(icon, item):
    icon.stop()
    sys.exit()

menu = (
        item("MetricStream Agent", lambda icon, item: None, enabled=False), 
        item(f"IP: {ip}:{port}", lambda icon, item: None, enabled=False),
        item("Quit", quit_application)
    )

icon_path = os.path.join(os.path.dirname(__file__),'..','assets', 'Icon.png')
icon = Icon("MetricStream Agent", create_image_from_path(icon_path), menu=menu)

icon.title = f"MetricStream Agent\nIP: {ip}:{port}"

def run_server_in_thread():
    asyncio.run(start_server())

server_thread = threading.Thread(target=run_server_in_thread, daemon=True)
server_thread.start()

icon.run()
