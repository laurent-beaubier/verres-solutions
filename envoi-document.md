#  Envoi DOCUMENT

**Déclencheur** : 
Si un enregistrement de type DocumentLink est créé et vérifie les conditions suivantes alors il faut réaliser un appel vers SINAPPS :
- Le champ Type_de_document__c de l'enregistrement ContentDocument associé vaut 'Cerfa TVA réduite', 'Mandat' ou 'PV de réception'
- L'enregistrement WhatId est associé une affaire (Case).

Si un enregistrement de type DocumentLink est modifié et vérifie une ou les deux conditions suivantes alors il faut réaliser un appel vers SINAPPS :
- Le champ Type_de_document__c de l'enregistrement ContentDocument associé a été modifié pour devenir 'Cerfa TVA réduite', 'Mandat' ou 'PV de réception'
- La valeur du WhatId a changé et il est associé à une affaire (Case).

Le déclencheur est donc sur la création d'un ContentDocumentLink. Mais les informations à récupérer sont positionnées dans le ContentVersion actif associé au ContentDocument qui a été lié.

**Objets Salesforce Source** : ContentVersion et Case

**Champs Salesforce Source** : 

- ContentVersion > Type_de_document__c
- ContentVersion > VersionData
- ContentVersion > Title
- ContentVersion > FileType
- ContentVersion > FileExtension
- Case > Sinapps_Mission_Id__c

**Ressources Sinapps à mettre àjour** : Mission

## Endpoint pour récupérer l'URL de l'appel SINNAPPS 
Il s'agit de récupérer la commande 'ajouterPiecesJointes' sur la mission avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/missions/<missionId>/commands/ajouterPiecesJointes

## Calcul du nom et du type de fichier

${filename} = Type_de_document__c + "_" + Title + "." + FileExtension;

${MimeType} = Voir tableau ci-dessous

| FileExtension | MimeType |
|-----------|----------|
| txt | text/plain |
| pdf | application/pdf |
| doc | application/msword |
| docx | application/vnd.openxmlformats-officedocument.wordprocessingml.document |
| xls | application/vnd.ms-excel |
| xlsx | application/vnd.openxmlformats-officedocument.spreadsheetml.sheet |
| odt | application/vnd.oasis.opendocument.text |
| ods | application/vnd.oasis.opendocument.spreadsheet |
| - | application/octet-stream|

## Requête SINAPPS

Faire un appel au format multipart/form-data :
* VERB = PUT
* URL = voir chapitre ci-dessus

* FORM PART 1 TYPE  : Body Parameter
* FORM PART 1 NAME  : 'nomCleFichier'
* FORM PART 1 VALUE  : ${filename}

* FORM PART 2 TYPE  : File
* FORM PART 2 NAME  : 'meta'
* FORM PART 2 VALUE  : ${filename}
* FORM PART 2 MIME TYPE : ${MimeType}
* FORM PART 2 BLOB  : encoder en base 64 le ContentVersion.VersionData

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle dans le l'objet WS_Logs

Si une autre erreur est renvoyée lors du traitement, il faut créer un enregistrement dans l'objet Event_Log