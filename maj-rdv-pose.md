#  Mise à jour du rendez-vous de pose

**Date de mise à jour** : 01/09/2022

**Déclencheur** : A la création d'un Work Order de type POSE alors on envoie une nouvelle date de rendez-vous à Sinapps.

**Ressources Sinapps à mettre à jour** : Prestation

**Objets Salesforce Source** : WorkOrder

**Champs Salesforce Source** : 
- WorkOrder > Date_RDV__c
- WorkOrder > CaseId > Sinapps_Id_Prestation__c

## Endpoint pour récupérer l'URL de l'appel SINNAPPS
Il s'agit de récupérer la commande 'planifierIntervention' sur la prestation avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/prestation/<prestationId>/commands/planifierIntervention
## json en paramètre de la requête

```
{
  "planification": {
    "name": "PlanificationPlage",
    "label": "PlanificationPlage",
    "value": {
      "horizon": "${Date_RDV__c}"
    }
  }
}
```

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
