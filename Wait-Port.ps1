param (
    [Parameter(Position = 0)]
    [ValidateNotNullOrEmpty()]
    [Alias('CN', '__SERVER', 'Server', 'Computer')]
    [string]$ComputerName = $env:computername,
        
    [Parameter(
        Position = 1,
        Mandatory = $true
    )]
    [ValidateNotNullOrEmpty()]
    [int]$Port,
            
    [Parameter(Position = 2)]
    [ValidateNotNullOrEmpty()]
    [int]$Timeout = 60
)
$callerEA = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
        
$to = New-Timespan -Seconds $Timeout
$sw = [diagnostics.stopwatch]::StartNew()
    
Write-Host "Test ${port} at host ${ComputerName}"            
try {
    do {
        if ($sw.elapsed -gt $to) {
            throw "Can't connect to port ${port} at host ${ComputerName}"
        }
        Write-Verbose "Connecting to port ${port} at host ${ComputerName}..."
        sleep 1
    } until(Test-NetConnection $ComputerName -Port $Port | ? { $_.TcpTestSucceeded })
    Write-Verbose "Connected successfully to port ${port} at host ${ComputerName}"            
}
catch {
    Write-Error -ErrorRecord $_ -EA $callerEA
}    
    

