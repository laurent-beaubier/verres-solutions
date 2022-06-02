#  EMise à jour du rendez-vous de métrage
**Date de mise à jour** : 23/05/2022

**Déclencheur** : Si le champ Date_RDV_METRAGE_prevue__c change sur une affaire créée depuis SINAPS alors on envoie une nouvelle date de rendez-vous à Sinapps.

**Objets Salesforce Source** : Case

**Champs Salesforce Source** : 
- Case > Sinapps_Prestation_Id__c

**Ressources Sinapps à mettre àjour** : Prestation

## Endpoint pour récupérer l'URL de l'appel SINNAPPS 
Il s'agit de récupérer la commande 'prendreRendezVous' sur la prestation avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/prestation/<prestationId>/commands/prendreRendezVous
## json en paramètre de la requête

```
{   
    "horaire" : "YYYY-MM-DDT00:00:00Z"    
}
```

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle