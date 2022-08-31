#  Envoi PHOTO

**Déclencheur** :
Le flux se déclenche si un champ de l'objet Case dont le nom contient 'Photo' change de valeur. Il existe plusieurs champs qui contiennent Photo dans leur nom. La récupération des champs doit donc être dynamique en fonction du nom de champ.

**Objets Salesforce Source** : Case

**Champs Salesforce Source** : 

- Case > CleMission__c
- Case > TechCoveaExecution__c
- Case > Nom du champ Photo modifié
- Case > Nouvelle valeur du champ modifié (il s'agit d'une URL)

**Ressources Sinapps à mettre àjour** : Mission

## Endpoint pour récupérer l'URL de l'appel SINAPPS** 
Il s'agit de récupérer la commande 'ajouterPiecesJointes' sur la mission avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/missions/<missionId>/commands/ajouterPiecesJointes

## Requête SINAPPS

Faire un appel au format multipart/form-data :
* VERB = PUT
* URL = voir chapitre ci-dessus

* FORM PART 1 TYPE  : Body Parameter
* FORM PART 1 NAME  : 'nomCleFichier'
* FORM PART 1 VALUE  : nom du fichier

* FORM PART 2 TYPE  : File
* FORM PART 2 NAME  : meta 
* FORM PART 2 MIME TYPE : image/jpeg
* FORM PART 2 VALUE  : avec la valeur du champ modifié (nouvelle URL) il faut récupérer le contenu de la photo et l'encoder en base 64

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle dans le l'objet WS_Logs
