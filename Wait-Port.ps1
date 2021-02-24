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
    [int]$Timeout = 60,

    [Parameter(Position = 3)]
    [ValidateNotNullOrEmpty()]
    [string]$SuccessCommand,

    [Parameter(Position = 4)]
    [ValidateNotNullOrEmpty()]
    [string]$FailureCommand
)
$callerEA = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
        
$to = New-Timespan -Seconds $Timeout
$sw = [diagnostics.stopwatch]::StartNew()
    
Write-Host "Test ${port} at host ${ComputerName}"            
try {
    do {
        if ($sw.elapsed -gt $to) {
            if (-not ([string]::IsNullOrEmpty($FailureCommand))) {
                Write-Verbose "Execute the failure command"
                $failureScriptBlock = [scriptblock]::Create($FailureCommand)
                Invoke-Command -scriptBlock $failureScriptBlock
            }
            throw "Can't connect to port ${port} at host ${ComputerName}"
        }
        Write-Verbose "Connecting to port ${port} at host ${ComputerName}..."
        Start-Sleep 1
    } until(Test-NetConnection $ComputerName -Port $Port | Where-Object { $_.TcpTestSucceeded })
    Write-Verbose "Connected successfully to port ${port} at host ${ComputerName}"   
    
    if (-not ([string]::IsNullOrEmpty($SuccessCommand))) {
        Write-Verbose "Execute the success command"
        $successScriptBlock = [scriptblock]::Create($SuccessCommand)
        Invoke-Command -scriptBlock $successScriptBlock
    }
}
catch {
    Write-Error -ErrorRecord $_ -EA $callerEA
}
