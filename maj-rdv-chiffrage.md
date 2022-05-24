#  EMise à jour du rendez-vous de métrage
**Date de mise à jour** : 23/05/2022

**Déclencheur** : 

**Objets Salesforce Source** : ContentDocument

**Champs Salesforce Source** : 
- Case > Sinapps_Mission_Id__c

**Ressources Sinapps à mettre àjour** : Mission, Planification

## Endpoint pour récupérer l'URL du 1er appel SINNAPPS 
Il s'agit de faire un appel pour touver l'id de planification 

Ce qui devrait revoyer une URL proche de : 
- <baseUrl>+/core/api/covea/missions/<missionId>/commands/planifierTravaux en création
- <baseUrl>+/core/api/covea/missions/<missionId>/commands/prendreRendezVousAvecModifications en modification 

filtrer la réponse sur name="PlanificationPlage" et récupérer properties.id"

## Endpoint pour récupérer l'URL du second appel SINNAPPS
Il s'agit de récupérer la commande 'planifierTravaux' en création ou la commande 'prendreRendezVousAvecModifications' en modification sur la ressource Planification avec la mécanique de découvrabilité de l'API

Ce qui devrait donner quelque chose comme <baseUrl>+ /core/api/covea/travaux/+ planificationId + /commands/modifierPlanificationTravaux

## json en paramètre de la requête de la seconde requete

```
{   
    planification : {
        "name" : "PlanificationPlage",
        "value" : {
            "dateDebut" :  <date travaux>,
            "heureDebut" :  <heure travaux>

        }
    }
}
```

 ### Seconde Requête

Faire un appel au format multipart/form-data :
VERB = PUT

URL = voir chapitre ci-dessus

FORM PART 1 NAME  : 'horaire'

FORM PART 1 CONTENT  : json ci-dessus

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle