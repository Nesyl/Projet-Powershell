#CREATION UTILISATEURS

New-ADUser -Name "toto" -SamAccountName "t_toto" #SAMaccountname sert à se connecter


Set-ADAccountPassword -Identity "t_toto" `
    -NewPassword(ConvertTo-SecureString -AsPlainText "Azerty77"-Force)

Set-ADUser -Identity "CN=toto,CN=Users,DC=esgi,DC=lab" -Enabled $true #SOIT 4
Set-ADUser -Identity "t_toto" -Enabled $true -ChangePasswordAtLogon $true #SOIT 5 

$Name = "Melusine"
$Surname = "Alaret"
$SamAccountName = "m_alaret"
$DisplayName = "$Name $Surname"
$Mail = "melusinea@esgi.fr"
$PathAD = "OU=Administratif,OU=infra,DC=esgi,DC=lab"
$Description "UTILISATEUR"
$OfficePhone = "0160292929"
$Title = "Directrice RH"
$Office = "Bureau du chef"

New-ADUser -GivenName "$Name" -Surname "$Surname"   `
    -Name "$Name" -DisplayName "$DisplayName"         `
    -SamAccountName "$SamAccountName" -UserPrincipalName "$Mail"  `
    -Path "$PathAD"
    -Description "$Description" `
    -EmailAddress "$Mail" ` -OfficePhone "$OfficePhone"  `
    -Office "$Office" ` -Title "$Title"    `   #Numéro du bureau #Fonction
    -AccountPassword(ConvertTo-SecureString -AsPlainText "Azerty77"-Force) `
    -ChangePasswordAtLogon $true -Enabled $true
