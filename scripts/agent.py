from Info import *
import asyncio
import websockets
import json
print("==========MetricStream Agent==========")

print("Your UID: "+ get_mac_address())
# for key, value in getInfo().items():
#     print(key, value)

async def send(websocket):
    data = getInfo()
    json_data = json.dumps(data)
    await websocket.send(json_data)
    await asyncio.sleep(1)

async def start_server():
    server = await websockets.serve(send, "localhost", 36500)
    await server.wait_closed()

asyncio.run(start_server())