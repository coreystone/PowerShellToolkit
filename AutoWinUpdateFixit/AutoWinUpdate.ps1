Write-Host "Setting [company] gateway [..]..."
try {
    netsh winhttp set proxy proxy-server="server;https= server"
    Write-Host "Successfully established connection with gateway proxy; try to Check For Updates"
}

catch {Write-Host "Could not establish connection with the gateway proxy"}

exit