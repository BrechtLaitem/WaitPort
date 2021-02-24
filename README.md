# WaitPort
Powershell script to wait for a port to become available.

Initial source code taken from https://www.powershellgallery.com/packages/server-startup-order/1.8

## Usage
```
Wait-Port.ps1 -Server <server> -Port <port> -Timeout <port> -SuccessCommand <command> -FailureCommand <command>
```

| Parameter | Mandatory | Remarks |
| -- | -- | -- |
| Server | No | Default value: The servername of the machine |
| Port | Yes | The port to keep waiting for |
| Timeout | No | Default value: 60 |
| SuccessCommand | No | Command to execute when the connection has been made |
| FailureCommand | No | Command to execute when the connection failed after the timeout period |
