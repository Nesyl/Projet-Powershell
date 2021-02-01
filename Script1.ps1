###########################################
#SCRIPT CREANT DES OU DE MANIERE RECURSIVE#
###########################################

# Force le type d'execution
Set-ExecutionPolicy Unrestricted

#Déclaration des variables

$FilialeOU = @("Filiale") #Variable contenant l'OU "principale"
$PolesOU = @("Services","Production","Recherche","Ventes") #Variable contenant la liste des OU qui seront contenues dans l'OU "principale"
$ServicesOU = @("Direction","Ressources Humaines","Comptabilité","Paye","Informatique") #Variable contenant la liste des OU qui seront crées dans l'OU "Services"
$ProductionOU = @("Usine","Logistique","Méthodes","Support") #Variable contenant la liste des OU qui seront crées dans l'OU "Production"
$RechercheOU = @("Prospective","Développement","Assurance Qualité") #Variable contenant la liste des OU qui seront crées dans l'OU "Recherche"
$VentesOU = @("Commercial","Avant-Vente","Consulting") #Variable contenant la liste des OU qui seront crées dans l'OU "Ventes"

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable
ForEach( $NomOU in $FilialeOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable, créeant ainsi l'OU principale
ForEach( $NomOU in $PolesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable, créant ainsi les OU contenu dans l'OU principale "Filiale"
ForEach( $NomOU in $ServicesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "OU=Services,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable, créant ainsi les OU contenu dans l'OU "Production"
ForEach( $NomOU in $ProductionOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "OU=Production,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable, créant ainsi les OU contenu dans l'OU "Production"
ForEach( $NomOU in $RechercheOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "OU=Recherche,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}

#Boucle qui va récupérer chaque élément d'une liste contenue dans une variable, créant ainsi les OU contenu dans l'OU "Production"
ForEach( $NomOU in $VentesOU ){
        If (Get-ADOrganizationalUnit -Filter 'Name -eq $NomOU') { #On vérifie si l'OU que l'on souhaite créer existe déjà
            Write-warning "L'OU $NomOU existe déjà" #Si l'OU existe déjà on alerte l'utilisateur 
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
            }
        Else {
            New-ADOrganizationalUnit -Name $NomOU  ` #Dans le cas où l'OU n'existe pas, on la créée en indiquant son emplacement et en la protégeant d'une suppression accidentelle
                -Path "OU=Ventes,OU=Filiale,DC=srv-9,DC=ads" `
                -ProtectedFromAccidentalDeletion $true
            Write-Host "Création de l'OU $NomOU" #On prévient l'utilisateur de la création de l'OU
            Start-Sleep -Seconds 1 #Temps de pause d'une seconde afin de faciliter la lecture du script
        }
}
