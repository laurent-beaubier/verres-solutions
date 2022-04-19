#  Annulation d'une prestation

**Evènement** : PrestationAnnulée

**Objets Salesforce Créés** : Case, MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 19/04/2022


## Changement du statut de l'affaire

L'enregistrement **Case** (Affaire) à mettre à jour possède l'identifiant de prestation correspondant à la propriété **properties.id** dans la ressource **Event** de Sinapps.

Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|-------------------|--------------|---------|
AnnulationExtranet__c |  |  |  |
Anomalie_detectee__c |  |  | true |

## Création d'un commentaire

Il faut créer un nouvel enregistrement **MessageClient__c** (Commentaire d'annulation) associé à l'affaire annulée.

| Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|--------------|---------|
| Contenu__c | Prestation | properties.finPrestation.motif.label |  |
| Type__c |  | | 'Mission Annulée' |
| Affaire__c |  |  | Identifiant de l'affaire annulée |