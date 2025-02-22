import asyncio
import websockets

SOCKET_URI = "ws://localhost:8765"

async def send_socket_message(message: str):
    async with websockets.connect(SOCKET_URI) as websocket:
        await websocket.send(message)
        response = await websocket.recv()
        print(f"Received response: {response}")

def send_socket_message_sync(message: str):
    asyncio.get_event_loop().run_until_complete(send_socket_message(message))
