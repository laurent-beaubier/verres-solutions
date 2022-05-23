#  Validation d'un chiffrage

**Evènement** : MissionEtatChange

**Objets Salesforce Modifiés** : Case

**Ressources Sinapps** : Mission

**Date de mise à jour** : 25/02/2022


## Changement du statut de l'affaire

L'enregistrement **Case** (Affaire) à mettre à jour possède l'identifiant de Mission correspondant à la propriété **properties.id** dans la ressource **Event** de Sinapps.
La mise à jour se fait uniquement si la ressource Sinapps vérifie properties.etatMission.name = "ChiffrageValide"

Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|-------------------|--------------|---------|
Status |  |  | 'Devis accepté' |
