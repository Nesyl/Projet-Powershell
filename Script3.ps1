#############################################################################
#SCRIPT CREANT DES GROUPES ET Y AJOUTE DES UTILISATEURS DE MANIERE RECURSIVE#
#############################################################################

# Force le type d'execution
Set-ExecutionPolicy Unrestricted

# On récupère l'ensemble des OU se trouvant dans l'OU principale "Filiale" et on le stock dans une variable
$OUlist = Get-ADOrganizationalUnit -Filter 'Name -like "*"' -SearchBase 'OU=Filiale,DC=srv-9,DC=ads' 

# Boucle qui va récupérer l'ensemble des OU, une par une, pour ainsi créer les groupes correspondants à l'intérieur
foreach ($OUitem in $OUlist) {
    
    $PathAD = $OUitem.DistinguishedName # Variable contenant le chemin de l'OU
    $OUName = $OUitem.Name # Variable contenant le nom de l'OU
    $OUGroup = "G-"+ $OUName # On compose le nom du groupe à créer
    $Userlist = Get-ADUser -Filter * -SearchBase $PathAD | Select-Object -ExpandProperty SamAccountName # On récupère la liste des utilisateurs se trouvant dans l'OU principale de manière récursive
    $CheckGroup = Get-ADGroup -Filter "Name -eq '$OUGroup'" # Variable contenant le résultat de la vérification de l'existence d'un groupe via son nom

    # Si la variable contenant le résultat de l'existence d'un groupe est vide, cela siginifie que le groupe n'existe pas et peut donc être créé
    if ($CheckGroup -eq $None) {
        New-ADGroup -Name $OUGroup -SamAccountName $OUGroup -GroupCategory Security -GroupScope Global -Path $PathAD # Création du groupe
        Write-Host ("Creation du groupe '$OUGroup'.. `n") # On indique la création du groupe 
        Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }
    # Sinon si la variable n'est pas vide, cela signifie que la groupe existe déjà et donc n'as pas à être créé
    else {
        Write-Warning ("Le groupe '$OUGroup' existe deja. `n") # On alerte que le groupe existe déjà
        Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
    }
    
    # Variable contenant les membres du groupe
    $Members = Get-ADGroupMember -identity $OUGroup -Recursive | Select-Object -ExpandProperty SamAccountName

    # Boucle qui va analyser si chaque utilisateur appartiennent au groupe créé, afin de les ajouter ou non
    ForEach($User in $Userlist ){
        If ($Members -contains $User) { # Si le nom de l'utilisateur est contenu dans la liste des membres du groupe
            Write-Warning ("L'utilisateur $User est deja dans le groupe $OUGroup. `n") # Alors on alerte que l'utilisateur renseigné appartient déjà au groupe créé
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
        Else { # Si le nom de l'utilisateur n'est pas dans la liste des membres du groupe, alors celui-ci doit y être ajouté
            Add-ADGroupMember -Identity $OUGroup -Members $User # On ajoute l'utilisateur au groupe créé
            Write-Host ("Ajout de l'utilisateur $User dans le groupe $OUGroup... `n") # On indique que l'utilisateur a été ajouté au groupe créé
            Start-Sleep -Seconds 1 # Temps de pause d'une seconde afin de faciliter la lecture du script durant l'exécution
        }
    }
}