Set-ExecutionPolicy Unrestricted

$csv = import-csv C:\Users\Administrateur\Desktop\users.csv


foreach($user in $csv){
    if ($user.fonction -eq "EMPLOYE") {
        $RandomEmployeeID = Get-Random -minimum 1 -maximum 99
    }
    elseif ($user.fonction -eq "CADRE") {
        $RandomEmployeeID = Get-Random -minimum 100 -maximum 199
    }
    elseif ($user.fonction -eq "CADRE-SUP") {
        $RandomEmployeeID = Get-Random -minimum 200 -maximum 299
    }

    $PathAD = "OU=Filiale,DC=srv-9,DC=ads"
    $Name = $user.prenom
    $Surname = $user.nom
    $Service = $user.service
    $Fonction = $user.fonction
    $Phone = $user.telephone
    $DisplayName = "$Name $Surname"
    $UserDistinguished = Get-ADOrganizationalUnit -Filter 'Name -eq $Service'
    $PathAD = $UserDistinguished.DistinguishedName
    $NameMail = $Name.substring(0,2).ToLower()+"."+$Surname.ToLower()
    $Login = $Name.ToLower()+$Surname.Substring(0,1).ToUpper()
    $Mail = $NameMail+"@filiale.com" 
    $NewLogin = $Login
    $NewNameMail = $NameMail
    $NewMail = $Mail


    
    $Check_Login = Get-ADUser -Filter "SamAccountName -eq '$Login'"
    $Check_Mail = Get-ADUser -Filter "EmailAddress -eq '$Mail'"
    
    
    
    While ($Check_Login -ne $None) {
        $num = $num + 1
        $NewLogin = $Login + $num
        $Check_Login = Get-ADUser -Filter "SamAccountName -eq '$NewLogin'"
    }
  
    $num = 0

    while ($Check_Mail -ne $None) {
        $num = $num + 1
        $NewNameMail = $NameMail + $num
        $NewMail = $NewNameMail+"@filiale.com" 
        $Check_Mail = Get-ADUser -Filter "EmailAddress -eq '$NewMail'"
    }    

    New-ADUser -GivenName $Name -Surname $Surname `
    -Name $NewLogin -DisplayName $DisplayName `
    -SamAccountName $NewLogin -UserPrincipalName $NewMail `
    -Path $PathAD `
    -EmailAddress $NewMail -OfficePhone $Phone -Title $Fonction `
    -AccountPassword(ConvertTo-SecureString -AsPlainText "Pa55w0rd" -Force) `
    -ChangePasswordAtLogon $true -Enabled $true `
    -EmployeeID $RandomEmployeeID 

}
    #email = $Na
    # prenomN
    # pr.nom@filiale.com
    # martin barjot + maxime barjot ma.barjot@filiale.com
    #maxime barjot + maxime babou maximeB
