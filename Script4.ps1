$PathAD = "OU=Filiale,DC=srv-9,DC=ads"
$GroupList = @("G-Filiale-Mailing","G-Managers-Mailing","G-Dirigeants-Mailing")
$Userlist = Get-ADUser -Filter * -SearchBase $PathAD -properties title

foreach ($Group in $GroupList) {

    try {
        New-ADGroup -Name $Group -SamAccountName $Group -GroupCategory Distribution -GroupScope Universal -Path $PathAD
        Write-Host ("Creation du groupe '$Group'.. `n")
        Start-Sleep -Seconds 1
    }
    Catch {
        Write-Warning ("Le groupe '$Group' existe deja. `n")
        Start-Sleep -Seconds 1
    }   

}

Add-ADGroupMember -Identity $GroupList[0] -Members $Userlist
Write-Host ("Tous les utilisateurs ajoutes au groupe "+$GroupList[0]+"`n")
Start-Sleep -Seconds 1

foreach ($User in $Userlist) {

    $Fonction = $User.title

    if ($Fonction -eq "CADRES") {

        Add-ADGroupMember -Identity $GroupList[1] -Members $User
        Write-Host ($User.Name+" ajoute au groupe "+$GroupList[1]+"`n")
        Start-Sleep -Seconds 1

    }

    if ($Fonction -eq "CADRES-SUP") {

        Add-ADGroupMember -Identity $GroupList[1] -Members $User
        Write-Host ($User.Name+" ajoute au groupe "+$GroupList[1]+"`n")
        Start-Sleep -Seconds 1
        Add-ADGroupMember -Identity $GroupList[2] -Members $User
        Write-Host ($User.Name+" ajoute au groupe "+$GroupList[2]+"`n")
        Start-Sleep -Seconds 1
    }
    
}
