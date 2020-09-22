#
#  List all NAV Docker Image Tags on Docker Hub
#


$ResultingObject = @()

$result = Invoke-WebRequest -Uri "https://registry.hub.docker.com/v2/repositories/microsoft/dynamics-nav/tags/?page_size=250" 
$JsonObject = ConvertFrom-Json -InputObject $result.Content
$ResultingObject = $JsonObject.results
$ParentId = 1

while ($JsonObject.next) {
    $result = Invoke-WebRequest -Uri $JsonObject.next 
    $JsonObject = ConvertFrom-Json -InputObject $result.Content
    $ResultingObject += $JsonObject.results    
    
    $percCompleted = [Math]::Round($ResultingObject.Count / $JsonObject.count, 4) * 100
    Write-Progress -Activity "Processing tags" -PercentComplete $percCompleted -ParentId $ParentId 
}

#Display the number of tags:
$ResultingObject.Count

#Display all tags:
$ResultingObject.name

#All Belgian tags:
$ResultingObject | where name -like ‘*be’ | select name

#Search for a certain version:
$ResultingObject | where name -like ‘*11.0.21063*’ | select name