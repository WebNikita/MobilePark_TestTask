$conf = Get-Content -Path "./conf.json" | ConvertFrom-Json
$path = $conf.file_path
$server_groups = @{}
$conf.server_groups[0].psobject.properties | Foreach { $server_groups[$_.Name] = $_.Value }
$global:group_index = @{}

function reload_service{
    [CmdletBinding()]
    param(
        [Parameter()]
        [string] $path,
        
        [Parameter()]
        [System.Array] $server_names
    )
    
    Write-Host "Имя сервера | Статус до выполнения | Результат выполнения"
    foreach ($server_name in $server_names){
    Write-Host "$server_name |  Запущен | Выполнено"   
    }
    #foreach ($ServerName in $ServerNames){
    #    Invoke-Command -ComputerName $ServerName -ScriptBlock{
    #        $Service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "*$ServerName*"} 
    #        Stop-Service $Service.Name
    #        Start-Service $Service.Name
    #    } #scriptblock
    #}#foreach
}


function print_server_groups{
    [CmdletBinding()]
    param(
        [Parameter()]
        $server_groups
    )
    
    $counter
    foreach ($group in $server_groups.GetEnumerator()){
        $counter += 1
        Write-Host "Номер группы: $counter`nГруппа: $($group.Name)`nХосты: $($group.Value)`n"
        $group_index[$counter] = $group.Name
        
    }
}

function pick_group{
    [CmdletBinding()]
    param(
        [Parameter()]
        $server_groups
    )
    
    $group_number = Read-Host "Введите номер группы"
    $server_groups[$group_index[[int]$group_number]]
    
}


print_server_groups($server_groups)
pick_group($server_groups)