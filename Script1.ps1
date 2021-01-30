# Force le type d'execution
Set-ExecutionPolicy Unrestricted

$FilialeOU = @("Filiale")
$PolesOU = @("Services","Production","Recherche","Ventes")
$ServicesOU = @("Direction","Ressources Humaines","Comptabilité","Paye","Informatique")
$ProductionOU = @("Usine","Logistique","Méthodes","Support")
$RechercheOU = @("Prospective","Développement","Assurance Qualité")
$VentesOU = @("Commercial","Avant-Vente","Consulting")

ForEach( $NomOU in $FilialeOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}

ForEach( $NomOU in $PolesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}

ForEach( $NomOU in $ServicesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "OU=Services,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}

ForEach( $NomOU in $ProductionOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "OU=Production,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}

ForEach( $NomOU in $RechercheOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "OU=Recherche,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}

ForEach( $NomOU in $VentesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') {
            Write-warning "L'OU $NomOU existe déjà"
            Start-Sleep -Seconds 1
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  `
                -Path "OU=Ventes,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU"
            Start-Sleep -Seconds 1
        }
}
