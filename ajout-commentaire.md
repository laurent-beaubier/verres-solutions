#  Ajout d'un commentaire

**Evènement** : CommentaireAjoute,CommentaireCree

**Objets Salesforce Créés** : MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 19/04/2022

## Création d'un commentaire

Il faut créer un nouvel enregistrement **MessageClient__c** (Commentaire).
Ce commentaire est associée à l'Affaire qui possède un identifiant de prestation correspondant à celui de la ressource **properties.id**.

| Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|--------------|---------|
| Contenu__c | Prestation | properties.nouveauxCommentaires.message | Concatenation des différents messages |
| DateCommentaireMission__c | Prestation | properties.nouveauxCommentaires.date | |
| Type__c |  | | 'Commentaire ajouté' |
| Affaire__c | |  | Identifiant de l'affaire concernée |

