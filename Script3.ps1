
$OUlist = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchBase 'OU=Filiale,DC=srv-9,DC=ads' #| Format-Table Name, DistinguishedName -A

foreach ($OUitem in $OUlist) {
    
    $PathAD = $OUitem.DistinguishedName
    $OUName = $OUitem.Name
    $OUGroup = "G-"+ $OUName
    $Userlist = Get-ADUser -Filter * -SearchBase $PathAD

    try {
    New-ADGroup -Name $OUGroup -SamAccountName $OUGroup -GroupCategory Security -GroupScope Global -Path $PathAD
    Write-Host ("Creation du groupe '$OUGroup'.. `n")
    Start-Sleep -Seconds 1
    }
    Catch {
        Write-Warning ("Le groupe '$OUGroup' existe deja. `n")
        Start-Sleep -Seconds 1
    }
    
    try {
    Add-ADGroupMember -Identity $OUGroup -Members $Userlist
    }
    Catch {
        Write-Warning ("Il n'y a pas d'utilisateurs dans l'OU '$OUName' `n")
        Start-Sleep -Seconds 1
    }

   
   
    
    
    
    
    
}
