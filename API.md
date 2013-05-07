# Client Sync and Copas

Besides its creation, the Sync and Copas interfaces are identical. The Copas Client performs all socket operations with the copas non-blocking calls though.

## Create a new Sync Client instance

Takes an optional table as parameter, which allows to specify the socket timeout.

```lua
local websocket = require'websocket'
local client = websocket.client.sync({timeout=2})
-- websocket.client.new is alias to websocket.client.sync
```

## Create a new Copas Client instance

Takes an optional table as parameter, which allows to specify the socket timeout.

```lua
local websocket = require'websocket'
local client = websocket.client.copas({timeout=2})
```

## Connect to a websocket server

The first argument must be a websocket URL and the second is an optional string, which specifies the
protocol.
On success, the connect method returns true. On error it returns `nil` followed by an error
description.

```
local ok,err = client:connect('ws://localhost:12345','echo')
if not ok then
   print('could not connect',err)
end
```

## Receive a message

On success, the first return value is the message received as string and the second is
the message's opcode, which can be `websocket.TEXT` or `websocket.BINARY`. In case the server closed the connection or an error happened, the additional return values `close_was_clean`,`close_code` and `close_reason` are returned. If the connection was closed for some reason during receive, it is not neccessary to call `client:close()`.

```lua
local message,opcode,close_was_clean,close_code,close_reason = client:receive()
```

If the details about the close are not of interest, looking at `message` and `opcode` suffices.

```lua
local message,opcode = client:receive()
if message then
   print('msg',message,opcode)
else
   print('connection closed')
end
```

## Send a message

Takes a string containing the message content and an optional second param, specifying the type of message which can be either `websocket.TEXT` or `websocket.BINARY`. The default type is `websocket.TEXT`.
On success, true is returned. On error, nil is returned followed by `close_was_clean`,`close_code` and `close_reason`.

```lua
local ok,close_was_clean,close_code,close_reason = client:send('hello',websocket.TEXT)
```

If the details about the close are not of interest, looking at `ok` suffices.

```lua
local ok = client:send('hello')
if ok then
   print('msg sent')
else
   print('connection closed')
end
```

## Closing the connection

The client con initiate the closing handshake by calling `client:close()`. The function takes two optional parameters `code` (Number) and `reason` (String) to provide additional information about the closing motivation to the server. The `code` defaults to 1000 (normal closure) and `reason` is empty string. The `close_was_clean`,`close_code` and `close_reason` are returned according to the protocol.

```lua
local close_was_clean,close_code,close_reason = client:close(4001,'lost interest')
```

If the details about the close are not of interest, just ignore them and leave default arguments.

```lua
client:close()
```