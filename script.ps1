param(
    [Parameter (Position=1)]
    [Int32]$user_pick
)


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
    Write-Host '_________Начало процесса перезагрузки сервисов_________'
    foreach ($server_name in $server_names){
        $path = ("$path" -split "\\")[-1]
        $service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "*$path*"}
        Write-Host "------------------"
        Write-Host "Подключение к серверу: $server_name"
        Write-Host "Получение статуса сервиса: $path"
        Write-Host "Cтатус сервиса: $($service.State)"
        #Write-Host "Перезапуск сервиса: Успех"
        #Write-Host "------------------"
        #Invoke-Command -ComputerName $server_name -ScriptBlock{
        #    $Service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "$path"}
        #    $Service.Name
            #Stop-Service $Service.Name
            #Start-Service $Service.Name
        #} #scriptblock
    }#foreach
}

function create_bufer_hashtable{
    [CmdletBinding()]
    param(
        [Parameter()]
        $server_groups
    )

    $counter
    
    foreach ($group in $server_groups.GetEnumerator()){
        $counter += 1
        $group_index[$counter] = $group.Name
        
    }
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
        $server_groups,

        [Parameter()]
        $user_pick
    )
    
    if ($user_pick -ne 0){
        create_bufer_hashtable -server_groups $server_groups
        return $server_groups[$group_index[$user_pick]]
    } else {
        print_server_groups -server_groups $server_groups
        $group_number = Read-Host "Введите номер группы"
        return $server_groups[$group_index[[int]$group_number]]
    }
    
    
}


# Получаю список серверов
$servers_list = pick_group -server_groups $server_groups -user_pick $user_pick

# Перезагрузка сервиса на серверах
reload_service -path $path -server_names $servers_list