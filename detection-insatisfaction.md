#  Détection d'une insatisfaction

**Evènement** : InsatisfactionDetectee

**Objets Salesforce Créés** : Case, MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 19/04/2022

## Mise à jour de l'affaire

L'enregistrement **Case** (Affaire) à mettre à jour possède l'identifiant de prestation correspondant à la propriété **properties.id** dans la ressource **Event** de Sinapps.

Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|-------------------|--------------|---------|
InsatisfactionExtranet__c |  |  | true |

## Création d'un commentaire

Il faut créer un nouvel enregistrement **MessageClient__c** (Commentaire).
Ce commentaire est associée à l'Affaire qui possède un identifiant de prestation correspondant à celui de la ressource **properties.id**.

| Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|--------------|---------|
| Contenu__c | Prestation | properties.notation.notesRecueillies.commentaire | Concatenation des différents messages |
| Type__c |  | | 'Insatisfaction détectée sur l'extranet' |
| Affaire__c | |  | Identifiant de l'affaire concernée |
