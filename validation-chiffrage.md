#  Validation d'un chiffrage

**Evènement** : EtatPrestationModifie

**Objets Salesforce Modifiés** : Case

**Ressources Sinapps** : Mission

**Date de mise à jour** : 25/02/2022


## Changement du statut de l'affaire

L'enregistrement **Case** (Affaire) à mettre à jour possède l'identifiant de Mission correspondant à la propriété **properties.id** dans la ressource **Event** de Sinapps.
La mise à jour se fait uniquement si la propriété suivante sur l'évènement remplit la condition : **items.propoerties.data.status=DevisValide**

Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|-------------------|--------------|---------|
Status |  |  | 'Devis accepté' |
