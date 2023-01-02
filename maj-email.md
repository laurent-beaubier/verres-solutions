#  Mise à jour de l'email de l'assuré (activation du suivi assuré ou SIC)

**Date de mise à jour** : 01/09/2022

**Déclencheur** : Le changement d'email sur un compte personnel ou un contact doit modifier toutes les missions SINAPPS de cet individu.

**Ressources Sinapps à mettre à jour** : Dossier Sinistre

**Objets Salesforce Source** : Contact et Case

**Champs Salesforce Source** : 
- Contact > email
- Contact > Sinapps_ActeurId (champ à créer)
- Case > Sinapps_DossierId__c (champ à créer ?)

## Scénario des appels SINAPPS 
L'action de mise à jour de l'adresse email de l'assuré ne peut être réalisée sans préciser les infos coordonnées, nom et adresse de l'assuré (cas d'erreur fonctionnel SINAPPS).
Cependant Salesforce n'a pas vocation à synchroniser ces données avec SINAPPS. 

On va donc réaliser 2 appels :
- 1 appel pour récupérer les infos actuelles de l'assuré dans Sinapps
- 1 appel pour ajouter l'email (si un email n'existe pas encore pour cet assuré) en passant les données obligatoires coordonnées, nom et adresse en complément.

## Premier appel Sinapps
Il s'agit d'un appel HTTP GET à l'adresse du dossier sinistre :

Dans la réponse il faut récupérer les valeurs des propriétés suivantes :
- ${adresse1} = properties.acteurs[0].personne.adresse.adresse1
- ${adresse2} = properties.acteurs[0].personne.adresse.adresse2
- ${adresse3} = properties.acteurs[0].personne.adresse.adresse3
- ${adresse4} = properties.acteurs[0].personne.adresse.adresse4
- ${codePostal} = properties.acteurs[0].personne.adresse.codePostal
- ${localite} = properties.acteurs[0].personne.adresse.localite
- ${codePays} = properties.acteurs[0].personne.adresse.codePays
- ${nomPays} = properties.acteurs[0].personne.adresse.nomPays
- ${telPersonnel} = properties.acteurs[0].personne.coordonnees.telPersonnel
- ${telPortable} = properties.acteurs[0].personne.coordonnees.telPortable
- ${telProfessionnel} = properties.acteurs[0].personne.coordonnees.telProfessionnel

## Endpoint pour récupérer l'URL du second l'appel Sinapps

Il s'agit de récupérer la commande 'modifierActeur' sur le Dossier Sinistre avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : ${baseUrl}+/core/api/covea/dossierSinistre/${Sinapps_DossierId__c}/commands/modifierActeur

## Json du second appel Sinapps

```
{
  "id": "${Sinapps_ActeurId}",
  "personne": {
     "adresse": {
      "adresse1": "${adresse1}",
      "adresse2": "${adresse2}",
      "adresse3": "${adresse3}",
      "adresse4": "${adresse4}",
      "codePostal": "${codePostal}",
      "localite": "${localite}",
      "codePays": "${codePays}",
      "nomPays": "${nomPays}"
    },
    "coordonnees": {
      "telPersonnel": "${telPersonnel}",
      "telProfessionnel": "${telProfessionnel}",
      "telPortable": "${telPortable}",
      "email": "${personEmail ou email}",
    }
  }
}
```


## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
