#  Mise à jour du rendez-vous de métrage
**Date de mise à jour** : 01/09/2022

**Déclencheur** : A la creation d'un Work Order de type METRAGE il faut envoyer une nouvelle date de rendez-vous à Sinapps.

**Ressources Sinapps à mettre à jour** : Prestation

**Objets Salesforce Source** : WorkOrder

**Champs Salesforce Source** : 
- WorkOrder > StartDate
- WorkOrder > EndDate
- WorkOrder > CaseId > Sinapps_Id_Prestation__c

## Endpoint pour récupérer l'URL de l'appel SINNAPPS 
Il s'agit de récupérer la commande 'prendreRendezVous' sur la prestation avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : ${baseUrl}+/core/api/covea/prestation/<prestationId>/commands/prendreRendezVous

## json en paramètre de la requête

```
{
  "horaire": {
    "name": "HoraireFixe",
    "label": "HoraireFixe",
    "value": {
      "date": "Date(${StartDate})",
      "heure": "Heure(${StartDate})"
    }
  },
  "dureeRendezVous": "${EndDate}-${StartDate}",
}
```

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
