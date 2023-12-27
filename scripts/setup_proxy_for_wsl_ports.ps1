# Note: Make sure you've enable the IP Helper (iphlpsvc) in Windows

# This script does the following:
# 1. Get Ip Address of WSL 2 machine
# 2. Remove previous port forwarding rules
# 3. Add port Forwarding rules
# 4. Remove previously added firewall rules
# 5. Add new Firewall Rules
# See: https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723

# How to steup this script running on system startup (Windows 11)
# 1. Go to search, search for "Task Scheduler"
# 2. In the "Actions" menu on the top, click on "Create task"
# 3. Enter Name, then go to "Triggers" tab. Create a new trigger, setup "Begin the task" to "At startup", set delay to "10 seconds".
# Go to the "Actions" tab and add the script. If you are using Laptop, go to settings and enable run on power.

$remoteport = bash.exe -c "ifconfig eth0 | grep 'inet '"
$found = $remoteport -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';

if( $found ){
  $remoteport = $matches[0];
} else{
  Write-Output "The Script Exited, the ip address of WSL 2 cannot be found";
  exit;
}

Write-Output $remoteport;

# #[Ports]

# #All the ports you want to forward separated by coma
$ports=@(80,443,10000,3000,5000);


#[Static ip]
#You can change the addr to your ip config to listen to a specific address
$addr='0.0.0.0';
$ports_a = $ports -join ",";


#Remove Firewall Exception Rules
Invoke-Expression "Remove-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' ";

#adding Exception Rules for inbound and outbound Rules
Invoke-Expression "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Outbound -LocalPort $ports_a -Action Allow -Protocol TCP";
Invoke-Expression "New-NetFireWallRule -DisplayName 'WSL 2 Firewall Unlock' -Direction Inbound -LocalPort $ports_a -Action Allow -Protocol TCP";

for( $i = 0; $i -lt $ports.length; $i++ ){
  $port = $ports[$i];
  Invoke-Expression "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  Invoke-Expression "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
}
