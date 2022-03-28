param(
    [Parameter (Position=1)]
    [Int32]$user_pick = -1
)

$conf = Get-Content -Path "./conf.json" | ConvertFrom-Json

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
        #$path = ("$path" -split "\\")[-1]
        $service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "*$path*"}
        Write-Host "------------------"
        Write-Host "Подключение к серверу: $server_name"
        Write-Host "Получение статуса сервиса: $path"
        Write-Host "Cтатус сервиса: $($service.State)"
        #try{
            #Invoke-Command -ComputerName $server_name -ScriptBlock{
                #$service = Get-WmiObject win32_service | Where-Object {$_.PathName -like "*$path*"}
                #Write-Host "------------------"
                #Write-Host "Подключение к серверу: $server_name"
                #Write-Host "Получение статуса сервиса: $path"
                #Write-Host "Cтатус сервиса: $($service.State)"
                #if ($service.State -ne "Stopped"){
                #    Stop-Service $Service.Name
                #    Start-Service $Service.Name
                #}
         #   } #scriptblock
        #} catch {
        #    Write-Host "Ошибка: "
        #    Write-Error $error
        #} #tryblock
    }#foreach
}

function print_server_groups{
    [CmdletBinding()]
    param(
        [Parameter()]
        $server_groups
    )   
    foreach ($group in $server_groups){
        Write-Host "Номер группы: $($server_groups.IndexOf($group))`nГруппа: $($group.Name)`nХосты: $($group.Value)`n" 
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
    
    if ($user_pick -ne -1){
        if ($user_pick -lt $server_groups.Count -And $user_pick -ge 0){
            return $server_groups[$user_pick].Value
        } else {
            Write-Host "Ошибка ввода, такой группы не существует"
            Exit
        } 
    } else {
        print_server_groups -server_groups $server_groups
        $group_number = Read-Host "Введите номер группы"
        if ($group_number -lt $server_groups.Count -And $group_number -ge 0){
            return $server_groups[[int]$group_number].Value
        } else {
            Write-Host "Ошибка ввода, такой группы не существует"
            Exit
        }
    }    
}

# Получаю список серверов
$servers_list = pick_group -server_groups $conf.server_groups -user_pick $user_pick
# Перезагрузка сервиса на серверах
reload_service -path $conf.file_path -server_names $servers_list