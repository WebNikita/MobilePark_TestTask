$conf = Get-Content -Path "./conf.json" | ConvertFrom-Json
#$server_group = Read-Host -Prompt ""


function reload_service{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $Path,
        
        [Parameter()]
        [System.Array] $ServerNames
    )
    
    Write-Host "Имя сервера | Статус до выполнения | Результат выполнения"
    foreach ($ServerName in $ServerNames){
    Write-Host "$ServerName |  Запущен | Выполнено"   
    }
    #foreach ($ServerName in $ServerNames){
    #    Invoke-Command -ComputerName $ServerName -ScriptBlock{
    #        $Service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "*service_update.exe*"} 
    #        Stop-Service $Service.Name
    #        Start-Service $Service.Name
    #    } #scriptblock
    #}#foreach
}


function print_server_groups{
    [CmdletBinding()]
    param(
        [Parameter()]
        $Server_groups_hashtable
    )
    foreach ($group in $Server_groups_hashtable){
        Write-Host $group.keys
    }
}

#reload_service -Path "test" -ServerNames @(1,2,3)
#Write-Host $conf.server_groups.Count
print_server_groups -Server_groups_hashtable $conf.server_groups