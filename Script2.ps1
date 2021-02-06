############################################################
#CREATION D'UTILISATEURS DEPUIS UN CSV DE MANIERE RECURSIVE#
############################################################

# Force le type d'execution
Set-ExecutionPolicy Unrestricted

# On importe le CSV contenant les informations relatives aux utilisteurs à créer
$csv = import-csv C:\Users\Administrateur\Desktop\users.csv

# Boucle qui va effectuer des actions pour chaque utilisateurs renseignés dans le CSV
foreach($user in $csv){
    if ($user.fonction -eq "EMPLOYE") { # Si la fonction de l'utilisateur renseigné dans le CSV est "EMPLOYE"
        $RandomEmployeeID = Get-Random -minimum 1 -maximum 99 # Alors on lui attribue un EmployeeID de manière aléatoire entre 1 et 99
    }
    elseif ($user.fonction -eq "CADRE") { # Si la fonction de l'utilisateur renseigné dans le CSV est "CADRE"
        $RandomEmployeeID = Get-Random -minimum 100 -maximum 199 # Alors on lui attribue un EmployeeID de manière aléatoire entre 100 et 199
    }
    elseif ($user.fonction -eq "CADRE-SUP") { # Si la fonction de l'utilisateur renseigné dans le CSV est "CADRE-SUP"
        $RandomEmployeeID = Get-Random -minimum 200 -maximum 299 # Alors on lui attribue un EmployeeID de manière aléatoire entre 200 et 299
    }

    # Declaration des variables 

    $Name = $user.prenom # Variable récupérant le prénom de l'utilisateur
    $Surname = $user.nom # Variable récupérant le nom de l'utilisateur
    $Service = $user.service # Variable récupérant le service de l'utilisateur
    $Fonction = $user.fonction # Variable récupérant la fonction de l'utilisateur
    $Phone = $user.telephone # Variable récupérant le téléphone de l'utilisateur
    $DisplayName = "$Name $Surname" # Variable composant le nom complet de l'utilisateur à l'aide de son prénom et de son nom
    $UserDistinguished = Get-ADOrganizationalUnit -Filter 'Name -eq $Service' # Variable récupérant les informations de l'OU portant le nom du service de l'utilisateur
    $PathAD = $UserDistinguished.DistinguishedName # Variable récupérant uniquement le chemin de l'OU où doit être créer l'utilisateur
    $NameMail = $Name.substring(0,2).ToLower()+"."+$Surname.ToLower() # Variable composant la première partie de l'adresse mail de l'utilisateur
    $Login = $Name.ToLower()+$Surname.Substring(0,1).ToUpper() # Variable composant le login de l'utilisateur
    $Mail = $NameMail+"@filiale.com" # Variable composant le mail complet de l'utilisateur grâce à la première partie créée précedemment
    $NewLogin = $Login # Variable qui récupère la valeur du login
    $NewNameMail = $NameMail # Variable qui récupère la première partie du mail
    $NewMail = $Mail # Variable qui récupère la valeur du mail complet
    $Check_Login = Get-ADUser -Filter "SamAccountName -eq '$Login'" # Variable contenant le résultat de la vérification de l'existence d'un utilisateur via son login
    $Check_Mail = Get-ADUser -Filter "EmailAddress -eq '$Mail'" # Variable contenant le résultat de la vérification de l'existence d'un utilisateur via son mail complet
    $num = 0 # Variable contenant le chiffre qui sera placé après le login/mail dans le cas de la création d'un utilisateur dont le login/mail serait déjà pris

    # Boucle qui s'exécutera tant que le résultat de la vérification de l'existence d'un utilisateur via son login ne sera pas vide, signifiant ainsi que le login est déjà pris
    # et qu'il faut donc en créer un nouveau
    While ($Check_Login -ne $None) {
        $num = $num + 1 # On incrémente la variable contentant le chiffre qui sera placé après le login
        $NewLogin = $Login + $num # Le nouveau login de l'utilisateur sera ainsi composé de l'ancien suivi d'un chiffre
        $Check_Login = Get-ADUser -Filter "SamAccountName -eq '$NewLogin'" # On effectue à nouveau la vérification de l'existence d'un utilisateur via ce nouveau login
    }
  
    # Si il existe un utilisateur portant le même login que le nouveau venant d'être créé, la boucle se répète en augmentant un à un le chiffre se plaçant derrière le login
    # permettant ainsi à l'utilisateur de posséder un login unique

    # Si la vérification de l'existence de l'utilisateur via son login n'a sorti aucun résultat, alors aucune modification n'est à faire

    $num = 0 # Réinitialisation de la variable contenant le chiffre qui sera placé après le login/mail

    # Boucle qui s'exécutera tant que le résultat de la vérification de l'existence d'un utilisateur via son mail ne sera pas vide, signifiant ainsi que le mail est déjà pris
    # et qu'il faut donc en créer un nouveau
    while ($Check_Mail -ne $None) {
        $num = $num + 1 # On incrémente la variable contentant le chiffre qui sera placé après le login
        $NewNameMail = $NameMail + $num # La première partie du nouveau mail de l'utilisateur sera ainsi composé de l'ancienne suivi d'un chiffre
        $NewMail = $NewNameMail+"@filiale.com" # On forme la nouvelle adresse mail complète
        $Check_Mail = Get-ADUser -Filter "EmailAddress -eq '$NewMail'" # On effectue à nouveau la vérification de l'existence d'un utilisateur via ce nouveau mail
    }    

    # Si il existe un utilisateur portant le même mail que le nouveau venant d'être créé, la boucle se répète en augmentant un à un le chiffre se plaçant derrière le mail
    # permettant ainsi à l'utilisateur de posséder un mail unique

    Write-Host ("Creation de l'utilisateur $DisplayName... `n") # On avertit de la création de l'utilisateur
    Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution

    # Création de l'utilisateur
    
    # On renseigne le prénom et le nom de l'utilisateur
    # On renseigne le nom (dans l'AD) et le nom complet de l'utilisateur
    # On renseigne le login et l'UPN de l'utilisateur
    # On renseigne l'emplacement où sera créé l'utilisateur
    # On renseigne l'adresse mail, le numéro de téléphone, et le titre de l'utilisateur
    # On définit le mot de passe de l'utilisateur
    # On permet à l'utilisateur de modifier le mot de passe à la prochaine ouverture de session et on active son compte
    # On renseigne l'EmployeeID de l'utilisateur

    New-ADUser -GivenName $Name -Surname $Surname `
    -Name $NewLogin -DisplayName $DisplayName `
    -SamAccountName $NewLogin -UserPrincipalName $NewMail `
    -Path $PathAD `
    -EmailAddress $NewMail -OfficePhone $Phone -Title $Fonction `
    -AccountPassword(ConvertTo-SecureString -AsPlainText "Pas55w0rd" -Force) `
    -ChangePasswordAtLogon $true -Enabled $true `
    -EmployeeID $RandomEmployeeID

}
