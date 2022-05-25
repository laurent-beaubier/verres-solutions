#  Envoi Photo


# ATTENTION API REMPLACEE PAR ENVOI DOCUMENT 

**Date de mise à jour** : 20/05/2022

**Déclencheur** : Le flux se déclenche si un champ dont le nom contient 'Photo' change de valeur. 
Il existe plusieurs champs qui contiennent Photo dans leur nom. La récupération des champs doit donc être dynamique

**Objets Salesforce Source** : Case

**Champs Salesforce Source** : 
- Case > CleMission__c
- Case > TechCoveaExecution__c
- Case > Nom du champ Photo modifié
- Case > Nouvelle valeur du champ modifié (il s'agit d'une URL)

**Ressources Sinapps à mettre àjour** : Mission
## Endpoint pour récupérer l'URL de l'appel SINNAPPS** 
Il s'agit de récupérer la commande 'ajouterPhoto' sur la mission avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/missions/<missionId>/commands/ajouterPhoto
## Requête SINAPPS

Faire un appel au format multipart/form-data :
VERB = PUT

URL = voir chapitre ci-dessus

FORM PART 1 NAME  : 'file'

FORM PART 1 FILENAME  : Nom du champ modifié

FORM PART 1 MIME TYPE : image/jpeg

FORM PART 1 CONTENT  : avec la valeur du champ modifié (nouvelle URL) il faut récupérer le contenu de la photo et l'encoder en base 64

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle