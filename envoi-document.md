#  Envoi Photo
**Date de mise à jour** : 20/05/2022

**Déclencheur** : Le flux se déclenche si un ContentDocument de type 'Cerfa TVA réduite', 'Mandat' ou 'PV de réception' est associé une affaire (Case).
Le déclencheur est donc sur la création d'un ContentDocumentLink. Mais les informations à récupérer sont positionnées dans le ContentVersion actif associé au ContentDocument qui a été lié.

**Objets Salesforce Source** : ContentDocument

**Champs Salesforce Source** : 
- ContentVersion > Type_de_document__c
- ContentVersion > VersionData
- ContentDocument > Title
- ContentDocument > FileExtension
- Case > Sinapps_Mission_Id__c

**Ressources Sinapps à mettre àjour** : Mission

## Endpoint pour récupérer l'URL de l'appel SINNAPPS** 
Il s'agit de récupérer la commande 'ajouterDocument' sur la mission avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/missions/<missionId>/commands/ajouterDocument

## Calcul du nom et du type de fichier

filename = Type_de_document__c + "_" + Title + "." + FileExtension;

| Extension | MimeType |
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



 ### Json des metadata

| Type de Fichier | Json spécifique|
|-----------|----------|
| PV de réception | {"name" : "ProcesVerbalFinDeTravaux", "value" : "Procès verbal de fin de travaux"} |
| Cerfa TVA réduite | {"name" : "AttestationTVA", "value" : "Attestation de TVA"} |
| Mandat | {"name" : "DelegationDePaiement", "value" : "Délégation de paiement"} |



```
{   "file" : {
        "descriptif" :  "Descriptif de ma PJ",
        "signature" :  true,
        "label" : voir le json spécifique ci-dessus

    }
}
```

 ### Requête

Faire un appel au format multipart/form-data :
VERB = PUT

URL = voir chapitre ci-dessus

FORM PART 1 NAME  : 'file'

FORM PART 1 FILENAME  : filename

FORM PART 1 MIME TYPE : MimeType

FORM PART 1 CONTENT  : encoder en base 64 le ContentVersion.VersionData

FORM PART 2 NAME  : meta

FORM PART 2 CONTENT  : metaData


## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
