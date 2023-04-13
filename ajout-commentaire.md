#  Ajout d'un commentaire

**Evènement** : CommentaireAjoute
Attention! cet évènement contient plusieurs micro évènement (items.items). Il faut sélectionner le micro évènement qui vérifie "resourceType": "sollicitations" parmi tous les micro évènements pour récupérer les id de sollictations.

**Objets Salesforce Créés** : MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 02/01/2023

## Création d'un commentaire

Il faut créer un nouvel enregistrement **MessageClient__c** (Commentaire).
Ce commentaire est associée à l'Affaire qui possède un identifiant de prestation correspondant à celui de la ressource **properties.id**.

| Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|--------------|---------|
| Contenu__c | Prestation | properties.nouveauxCommentaires.message | Concatenation des différents messages |
| Type__c |  | | 'Commentaire ajouté' |
| Affaire__c | |  | Identifiant de l'affaire concernée |

