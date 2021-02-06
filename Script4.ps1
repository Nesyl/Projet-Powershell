#########################################################################
#SCRIPT CREANT DES GROUPES ET Y AJOUTE DES UTILISATEURS SELON UN CRITERE#
#########################################################################

# Force le type d'execution
Set-ExecutionPolicy Unrestricted

$PathAD = "OU=Filiale,DC=srv-9,DC=ads" # Variable contenant le chemin de l'OU principale, où seront créés les 3 groupes
$GroupList = @("G-Filiale-Mailing","G-Managers-Mailing","G-Dirigeants-Mailing") # Variable contenant le nom des 3 groupes à créer
$UserSAMlist = Get-ADUser -Filter * -SearchBase $PathAD  | Select-Object -ExpandProperty SamAccountName # Variable contenant les SamAccountName de tous les utilisateurs dans l'OU principal

# Boucle qui va, pour chaque groupe, vérifier si ceux-ci existent ou non
foreach ($Group in $GroupList) {

    $CheckGroup = Get-ADGroup -Filter "Name -eq '$Group'" # Variable contenant le résultat de la vérification de l'existence du groupe

    if ($CheckGroup -eq $None) { # Si la variable contenant le résultat de la vérification de l'existence du groupe est vide alors le groupe peut être créé
        New-ADGroup -Name $Group -SamAccountName $Group -GroupCategory Distribution -GroupScope Universal -Path $PathAD # Création du groupe
        Write-Host ("Creation du groupe '$Group'.. `n") # On indique la création du groupe
        Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }
    else { # Sinon, si la variable contenant le résultat de la vérification de l'existence du groupe n'est pas vide, cela signifie que celui-ci existe déjà et ne peut donc pas être créé
        Write-Warning ("Le groupe '$Group' existe deja. `n") # On alerte de l'existence du groupe
        Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }   
}

# Variable contenant la liste des membres (triée par SamAccountName) du premier groupe
$MembersFiliale = Get-ADGroupMember -identity $GroupList[0]  | Select-Object -ExpandProperty SamAccountName

# Variable contenant la liste des membres (triée par SamAccountName) du deuxième groupe
$MembersManagers = Get-ADGroupMember -identity $GroupList[1] | Select-Object -ExpandProperty SamAccountName

# Variable contenant la liste des membres (triée par SamAccountName) du troisième groupe
$MembersDirigeants = Get-ADGroupMember -identity $GroupList[2] | Select-Object -ExpandProperty SamAccountName

# Boucle qui va définir, pour chaque utilisateurs de l'OU principale, si ceux-ci doivent être ajoutés à un groupe ou non
foreach ($UserSAM in $UserSAMlist) {

    If ($MembersFiliale -contains $UserSAM) { # Si la liste des membres du premier groupe contient le nom de l'utilisateur, alors celui-ci en fait déjà parti et ne dois pas y être ajouté de nouveau
        Write-Warning ("L'utilisateur $UserSAM est deja dans le groupe "+$GroupList[0]+". `n") # On alerte de la présence de l'utilisateur dans le premier groupe
        Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }
    Else { # Sinon si la liste des membres du premier groupe ne contient pas le nom de l'utilisateur, alors celui-ci doit y être ajouté
        Add-ADGroupMember -Identity $GroupList[0] -Members $UserSAM # Ajout de l'utilisateur dans le groupe
        Write-Host ("Ajout de l'utilisateur $UserSAM dans le groupe "+$GroupList[0]+"... `n") # On indique l'ajout de l'utilisateur dans le groupe
        Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }

    $User = Get-ADUser -Filter "SamAccountName -eq '$UserSAM'" -SearchBase "OU=Filiale,DC=srv-9,DC=ads" -properties title # Variable contenant les informations de l'utilisateur, dont sa fonction
    $Fonction = $User.title # Variable contenant la fonction de l'utilisateur

    If ($Fonction -eq "CADRES") { # Si la fonction de l'utilisateur est "CADRES" on vérifie si oui ou non il appartient déjà au deuxième groupe

        If ($MembersManagers -contains $UserSAM) { # Si la liste des membres du deuxième groupe contient le nom de l'utilisateur, alors celui-ci en fait déjà parti et ne dois pas y être ajouté de nouveau
            Write-Warning ("L'utilisateur $UserSAM est deja dans le groupe "+$GroupList[1]+". `n") # On alerte de la présence de l'utilisateur dans le deuxième groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
        Else { # Sinon si la liste des membres du deuxième groupe ne contient pas le nom de l'utilisateur, alors celui-ci doit y être ajouté
            Add-ADGroupMember -Identity $GroupList[1] -Members $UserSAM # Ajout de l'utilisateur dans le groupe
            Write-Host ("Ajout de l'utilisateur $UserSAM dans le groupe "+$GroupList[1]+"... `n") # On indique l'ajout de l'utilisateur dans le groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }

    }

    If ($Fonction -eq "CADRES-SUP") { # Si la fonction de l'utilisateur est "CADRES-SUP" on vérifie si oui ou non il appartient déjà au deuxième et au troisième groupe
        If ($MembersManagers -contains $UserSAM) { # Si la liste des membres du deuxième groupe contient le nom de l'utilisateur, alors celui-ci en fait déjà parti et ne dois pas y être ajouté de nouveau
            Write-Warning ("L'utilisateur $UserSAM est deja dans le groupe "+$GroupList[1]+". `n") # On alerte de la présence de l'utilisateur dans le deuxième groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
        Else { # Sinon si la liste des membres du deuxième groupe ne contient pas le nom de l'utilisateur, alors celui-ci doit y être ajouté
            Add-ADGroupMember -Identity $GroupList[1] -Members $UserSAM # Ajout de l'utilisateur dans le groupe
            Write-Host ("Ajout de l'utilisateur $UserSAM dans le groupe "+$GroupList[1]+"... `n") # On indique l'ajout de l'utilisateur dans le groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }

        If ($MembersDirigeants -contains $UserSAM) { # Si la liste des membres du troisième groupe contient le nom de l'utilisateur, alors celui-ci en fait déjà parti et ne dois pas y être ajouté de nouveau
            Write-Warning ("L'utilisateur $UserSAM est deja dans le groupe "+$GroupList[2]+". `n") # On alerte de la présence de l'utilisateur dans le troisième groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
        Else { # Sinon si la liste des membres du troisième groupe ne contient pas le nom de l'utilisateur, alors celui-ci doit y être ajouté
            Add-ADGroupMember -Identity $GroupList[2] -Members $UserSAM # Ajout de l'utilisateur dans le groupe
            Write-Host ("Ajout de l'utilisateur $UserSAM dans le groupe "+$GroupList[2]+"... `n") # On indique l'ajout de l'utilisateur dans le groupe
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
    }  
}