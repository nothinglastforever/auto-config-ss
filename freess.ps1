<#	
	.NOTES
	===========================================================================
	 Created with: 	VSCode
	 Created on:   	2017/12/15 10:40
	 Created by:   	ZTS
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$config = Get-Content -Raw -Path "d:\PortableApps\1 network\shadowsocks\gui-config.json" | ConvertFrom-Json
$svrList = [System.Collections.ArrayList]($config.configs)
$length = $svrList.Count
$svrList.RemoveRange(1, $length-1)

function SSLinksDecodeToConfig
{ 
  param([string] $sslink, [System.Collections.ArrayList] $objList) 
  
  $ssSvrConfig = ""

  $ssSvrConfig = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($sslink)) 

  $svrConfig = $ssSvrConfig -Split {$_ -eq ":" -or $_ -eq "@"}

           

  $Object = New-Object PSObject -Property @{            
	"server"    	= $svrConfig[2]                 
	"server_port"   = $svrConfig[3].replace("`n","")            
	"password"      = $svrConfig[1]    
	"method"        = $svrConfig[0]
	"remarks"       = "ss"
	"timeout"       = "5"	
  }     
  
  $objList.Add($Object)
}

$ssLinks = ""

$ssArray = @()

$regexA = 'ss://'
<#
Import-Module BitsTransfer
Start-BitsTransfer -Source $url -Destination $output
#OR
Start-BitsTransfer -Source $url -Destination $output -Asynchronous

Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"
#>

# test with local image
#$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("C:\us01.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
#$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("C:\us02.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
# test end


$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/us01.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/us02.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/us03.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/jp01.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/jp02.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }
$ssArray += & "C:\Intel\CommandLineDecoder\CommandLineDecoder.exe" @("https://freess.cx/images/servers/jp03.png") | Where-Object {$_ -creplace '(?m)^\s*\r?\n',''} | select -last 1 | ForEach-Object {$_ -replace $regexA, '' }


$ssArray | ForEach-Object { SSLinksDecodeToConfig $_ $svrList}

$config.configs = $svrList
$config | ConvertTo-Json | Out-File "d:\PortableApps\1 network\shadowsocks\gui-config.json"


#$ssLinks = $tempResults | sort  | get-unique |  findstr /v Point | findstr /v https | findstr /v Raw | findstr /v Parsed | ForEach {$_ -replace "ss://", ""}
