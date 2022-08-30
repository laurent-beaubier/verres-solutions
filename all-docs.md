# Flux SINAPPS
## Liste des flux

Les interfaces correspondent à des actions réalisées dans l'extranet Sinapps.
Certaines interfaces correspondent à des récupérations des évènements qui ont eu lieu dans l'extranet SINAPPS:
- [Création de Prestation](creation-prestation.md)
- [Annulation de Prestation](annulation-prestation.md)
- [Ajout de commentaire](ajout-commentaire.md)
- [Détection d'une insatisfaction](detection-insatisfaction.md)
- [Validation d'un chiffrage](validation-chiffrage.md)

D'autres interfaces correspondent à des actions réalisées depuis Salesforce qui impactent SINAPPS:
- [Ajout de Pieces Jointes ](envoi-document.md). Ce endpoint remplace les anciens endpoints **ajouter Photo** et **ajouter Document**
- [Prendre un rendez-vous de métrage](maj-rdv-chiffrage.md). Ce endpoint permet de communiquer la date et l'heure du rendez-vous de metrage dans SINAPPS.
- [Planifier les travaux](maj-rdv-pose.md). Ce endpoint permet de communiquer la date et l'heure du rendez-vous de pose dans SINAPPS.
- [Mettre à jour l'email Assure](maj-email.md). Ce point d'accès permet d'activer le suivi de l'assuré (SIC).

## Paramètres globaux de l'interface

Url de Base des flux SINAPPS
- baseUrl = "https://sinapps-ird.vabf.darva.com"; //Recette
- baseUrl = "https://sinapps-ird.darva.com"; // Prod

Voir le contexte pour les autres paramètres
- [Paramètres](context.txt)# Création d'une prestation

**Evènement** : PrestationCree

**Objets Salesforce Créés** : Case, MessageClient__c, Account

**Ressources Sinapps** : Prestation, Mission, DossierSinistre, SuiviInforation

**Date de mise à jour** : 19/04/2022


## Creation d'un compte

Chaque nouvelle prestation Sinappes génère un nouveau Account (Compte) avec le numéro d'évènement Sinapps correspondant à la création de la prestation associée.

Si un compte avec ce numéro d'évènement est déjà présente en base de données le compte ne doit pas être créé ni aucun autre objet. Ceci permet d'éviter des erreurs de rejeux intempestif (idempotence).

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource DossierSinistre

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments** |
|-------------------|-------------------|--------------|--------------|
| RecordType |  |  | valeur selon particulier / entreprise |
| D_eduction_de_TVA__c |  |  | vrai/faux selon entreprise/particulier  |
| Salutation | DossierSinistre | properties.acteurs[0].personne.civilite.label | pour un particulier uniquement (voir Tranco des civilités)|
| LastName | DossierSinistre | properties.acteurs[0].personne.nom | pour un particulier uniquement |
| FirstName | DossierSinistre | properties.acteurs[0].personne.prenom | pour un particulier uniquement |
| Name | DossierSinistre | properties.acteurs[0].personne.nom | pour une entreprise uniquement |
| Type |  |  | valeur en dur 'Prospect'|
| BillingStreet | DossierSinistre | properties.acteurs[0].personne.adresse.adresse1  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse2  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse3  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse4  | |
| BillingPostalCode | DossierSinistre | properties.acteurs[0].personne.adresse.codePostal | |
| BillingCity | DossierSinistre | properties.acteurs[0].personne.adresse.localite | |
| Fax | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel | |
| PersonMobilePhone | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable | pour les particuliers uniquement |
| Phone | DossierSinistre | properties.acteurs[0].personne.coordonnees.telProfessionnel | |
| PersonEmail | DossierSinistre | properties.acteurs[0].personne.coordonnees.email | pour les particuliers uniquement  |
| Industry |  | | "autre secteur d'activité" pour les entreprises uniquement  |
| ShippingStreet | DossierSinistre | properties.sinistre.adresse.adresse1 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse2 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse3 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse4 ||
| ShippingPostalCode | DossierSinistre | properties.sinistre.adresse.codePostal ||
| ShippingCity | DossierSinistre | properties.sinistre.adresse.localite ||
| PersonTitle | DossierSinistre | properties.acteurs[0].informationAssure.profession | pour les particuliers uniquement |
| Email_Pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.email | pour les professionnels uniquement |
| Telephone_mobile_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable | pour les professionnels uniquement |
| Autre_telephone_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel | pour les professionnels uniquement |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de mission |

### Tranco des civilités

|**Sinapps** |**Noé** |
|------------|--------|
| Professeur | M. |
| Maître | M. |
| Monsieur | M. |
| Madame| Mme |
| Autres valeurs | ne pas mettre à jour le champ |

## Creation d'une affaire

Chaque nouvelle prestation génère un nouveau **Case** (Affaire). 

Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource DossierSinistre

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments**|
|----------------------|----------------------|-----------------|------------|
| Type |  |  | 'Vitrage de menuiserie' |
| Status |  |  | 'Nouvelle' |
| Description | DossierSinistre | properties.sinistre.dommagesDeclares | "Dommages déclarés : " sur une première ligne |
| ^ | DossierSinistre | properties.sinistre.circonstancesDeclarees | "Circonstances déclarées : "  sur une seconde ligne |
| ^ | DossierSinistre | properties.sinistre.caracteristiques.detail.name |  "Détail du sinistre : " sur une 3eme ligne  |
| ^ | DossierSinistre | properties.sinistre.caracteristiques.cause.label  | "Cause du sinistre : " sur une 4eme ligne |
| Client_final__c |  |  | Le compte nouvellement créé  |
| Reference_dossier__c | DossierSinistre | properties.sinistre.reference | |
| TECH_RefSinistre__c | DossierSinistre | properties.sinistre.reference | |
| Nature_du_sinistre | DossierSinistre | properties.sinistre.caracteristiques.nature.label | voir Tranco des natures de mission |
| TechAffaireInterface__c | |  | true |
| Site_d_intervention__c |  |  | Le site d'intervention créé par automatisme à la création du compte (lookup vers le compte) | 
| Franchise_a_collecter__c | DossierSinistre | properties.contrats[0].franchise.value.montant | le premier qui est renseigné |
| ^ | DossierSinistre | properties.franchiseApplicable.value.montant | ^ |
| Franchise_collectee__c |  | | false  |
| TVA_a_collecter__c |  |  | vrai pour une entreprise faux sinon  |
| Type_de_Local__c | DossierSinistre | properties.risques[0].typeRisque.label  |  |
| Usage_Local__c | DossierSinistre | properties.risques[0].usageAssure.label  |  |
| Suivi_assure_activite_donneur_ordre__c | SuiviInformation | properties.statutSuiviInformation.name | faux si suiviAssureStatus.equals = "Desactive"   |
| Num_Contrat__c | DossierSinistre | properties.contrat.numero.label  |  |
| Qualite_Assure__c | DossierSinistre | properties.acteurs[0].relationAuRisque.label  |  |
| Date_du_sinistre__c | DossierSinistre | properties.sinistre.date  |  |
| TypeDeMission__c | Mission | mission.typeMission.name | voir Tranco des types de mission |
| AssureurId | DossierSinistre | properties.assureurId  | Pour un compte Perso remplir le lookup vers le compte avec le TECH_IDAssureur__c correspondant |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de mission |
| Sinapps_Id_Prestation__c | Prestation | properties.id |  |
| Sinapps_Id_Mission__c | Mission |  properties.id |  |
| TechCoveaExecution__c | Mission |  properties.id |  |

### Tranco des types de mission

|**Sinapps** |**Noé** |
|---------|-----|
| RenDirecte | REN directe |
| RenSuiteExpertise | REN suite expertise |
| RenMobiliereDirecte | REN mobilière directe |
| RenMobiliereSuiteExpertise | REN mobilière suite à expertise |
| RechercheFuite | Recherche de fuite |

### Tranco des natures de mission

|**Sinapps** |**Noé** |
|---------|-----|
| Bris de glace | BDG |
| Vol | VOL |
| Catastrophe naturelle | CATNAT |
| Incendie | INCENDIE |
| Dégât des eaux | DDE |
| Autres valeurs | Autre |

## Creation du premier commentaire

Chaque nouvelle prestation entraine la création d'un enregistrement MessageClient__c (commentaire) contenant les commentaires de la mission. 
Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.
Il ne faut pas créer 2 commentaire de type **Commentaires initiaux** avec le même numéro d'évènement.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** | **Comments**|
|-------------------|-------------------|--------------|--------------|
| Contenu__c | Mission | properties.mission.commentaires.messages | fusionnés et séparés par des ----------------- |
| Auteur__c |  |  | 'API' |
| Type__c |  |  | 'Commentaires initiaux de mission' |
| Affaire__c |  | |  Id du Case |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de mission |

## Creation du second commentaire

Chaque nouvelle prestation entraine la création d'un enregistrement MessageClient__c (commentaire) contenant les informations initiales de la mission. 
Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.
Il ne faut pas créer 2 commentaire de type **Informations initiales de la mission** avec le même numéro d'évènement.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** | **Comments**|
|-------------------|-------------------|--------------|--------------|
| Contenu__c |  | |  voir tableau ci-dessous |
| Auteur__c |  | |  'API' |
| Type__c |  | |  'Informations initiales de la mission' |
| Affaire__c | |  |  Id du Case |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de mission |

### Contenu du commentaire

|**Préfixe** |**Sinapps Ressource** |**Sinapps path**
|---------|-------------------|--------------|
| Cause du sinistre  | DossierSinistre | properties.sinistre.caracteristiques.cause.label |
| Détail du sinistre | DossierSinistre | properties.sinistre.caracteristiques.detail.name |
| Dommages déclarés | DossierSinistre | properties.sinistre.dommagesDeclares |
| Circonstances | DossierSinistre | properties.sinistre.circonstancesDeclarees |
| Nature du sinistre | DossierSinistre | properties.sinistre.caracteristiques.nature.label |
| Date du sinistre  | DossierSinistre | properties.sinistre.date |
| Adresse du sinistre | Mission | properties.sinistre.adresse.adresse1 |
| ^ | DossierSinistre | properties.sinistre.adresse.adresse2 |
| ^ | DossierSinistre | properties.sinistre.adresse.adresse3 |
| ^ | DossierSinistre | properties.sinistre.adresse.adresse4 |
| ^ | DossierSinistre | properties.sinistre.adresse.codePostal |
| ^ | DossierSinistre | properties.sinistre.adresse.localite |
| ^ | DossierSinistre | properties.sinistre.adresse.codePays |
| Référence sinistre | DossierSinistre | properties.sinistre.reference
| Type de mission  | Mission | mission.typeMission.name | 
| Référence mission  | Mission | properties.mission.numero |
| Assureur émetteur  | Mission | properties.missioncontactAssureur.value.personne.nom |
| Entreprise mandatée | Prestation | properties.prestataireId |
| Date de missionnement | Mission | properties.mission.dateDeMissionnement |
| Type de risque | DossierSinistre | properties.risques[0].typeRisque.label |
| Usage du risque | DossierSinistre | properties.risques[0].usageAssure.label |
| Qualité de l'assuré | DossierSinistre | properties.acteurs[0].relationAuRisque.label |
| Mesure 1  | DossierSinistre | properties.risques[0].mesures[0].typeMesure.label |
| ^ | DossierSinistre | properties.risques[0].mesures[0].valeur |
| Mesure 2 | DossierSinistre | properties.risques[0].mesures[1].typeMesure.label |
| ^  | DossierSinistre | properties.risques[0].mesures[1].valeur |
| Mesure 3 | DossierSinistre | properties.risques[0].mesures[2].typeMesure.label |
| ^ | DossierSinistre | properties.risques[0].mesures[1].valeur |
| Nom de l'assuré  | DossierSinistre | properties.acteurs[0].personne.nom |
| Adresse de l'assuré  | DossierSinistre | properties.acteurs[0].personne.adresse.adresse1  |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse2  |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse3  |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse4  |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.codePostal |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.localite |
| Téléphone personnel | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel |
| Téléphone portable | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable |
| Téléphone professionnel| DossierSinistre | properties.acteurs[0].personne.coordonnees.telProfessionnel |
| Email de l'assuré | DossierSinistre | properties.acteurs[0].personne.coordonnees.email |
| Profession de l'assuré| DossierSinistre | properties.acteurs[0].personne.informationAssure.profession |
| Numéro de contrat | DossierSinistre | properties.contrat.numero.label 
| Type de contrat | DossierSinistre | properties.contrat.typeContrat |
| Activités professionnelles 1 | DossierSinistre | properties.informationAssure.contrat.activiteSouscrite[0] |
| Activités professionnelles 2 | DossierSinistre | properties.informationsAssure.contrat.activitesSouscrites[1] |
| Activités professionnelles 3 | DossierSinistre | properties.informationsAssure.contrat.activitesSouscrites[2] |
| Franchise | DossierSinistre | properties.franchiseApplicable.value.montant |
| Code Gestionnaire | Mission | properties.mission.contactAssureur.value.code |
| Nom Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.nom |
| Adresse Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.adresse.adresse1  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse.adresse2  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse.adresse3  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse.codePostal  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse.localite  |
| Téléphone personnel Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees.telPersonnel |
| DossierGestionnaireCoordTelPortable | Mission | properties.mission.contactAssureur.value.personne.coordonnees.telPortable |
| Téléphone Professionnel Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees.telProfessionnel |
| Email Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees.email |
| Fax Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees.fax |
| Convention IRSI applicable | DossierSinistre | properties.sinistre.ConventionIRSIAApplicable |
| Nbre de pièces | DossierSinistre | properties.risques[0].mesures[?(@.typeMesure.name=='NombreDePieces')].valeur |
| Superficie | DossierSinistre | .risques[0].mesures[?(@.typeMesure.name=='Superficie')].valeur |
| Clauses particulières | DossierSinistre | properties.contrat.clausesParticulieres |
| Informations spécifiques | DossierSinistre | properties.contrat.informationsSpecifiques |
| Apporteur d’affaires | DossierSinistre | properties.contrats[0].apporteur.nom |
| Contrat professionnel | DossierSinistre | properties.contrat.professionnel |
| Numéro de contrat d’assistance | DossierSinistre | properties.contrat.numero.label |
#  Annulation d'une prestation

**Evènement** : PrestationAnnulée

**Objets Salesforce Créés** : Case, MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 19/04/2022


## Changement du statut de l'affaire

L'enregistrement **Case** (Affaire) à mettre à jour possède l'identifiant de prestation correspondant à la propriété **properties.id** dans la ressource **Event** de Sinapps.

Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|-------------------|--------------|---------|
AnnulationExtranet__c |  |  | true |
Anomalie_detectee__c |  |  | true |

## Création d'un commentaire

Il faut créer un nouvel enregistrement **MessageClient__c** (Commentaire d'annulation) associé à l'affaire annulée.

| Salesforce Fields | Sinapps Ressource | Sinapps path | Comments|
|-------------------|-------------------|--------------|---------|
| Contenu__c | Prestation | properties.finPrestation.motif.label |  |
| Type__c |  | | 'Mission Annulée' |
| Affaire__c |  |  | Identifiant de l'affaire annulée |#  Ajout d'un commentaire

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
*******************************
MAJ_EMail
*******************************
- cleMission

"SELECT Contact.Email,TechCoveaExecution__c FROM Case WHERE CleMission__c='"+context.darva_ref_dossier+"'"

context.darva_ref_mission_id=(String)row20.TechCoveaExecution__c;
context.new_email=(String)row20.Contact_Email;
context.URI_Maj_Email +context.darva_ref_mission_id+ context.URI_Maj_Email2

String baseUrl = context.URL ;
String hrefUrl1 = context.URI_Maj_Email;
String hrefUrl2 = context.darva_ref_mission_id;
String hrefUrl3 = context.URI_Maj_Email2;
String putUrl = baseUrl + context.darva_email_dynamic_link_uri;

// emailAModifier
JSONObject valueEmail = new JSONObject();
valueEmail.put("name", "ReplaceWith");
valueEmail.put("value", context.new_email);

// JSON Global
JSONObject globalRequestJson = new JSONObject();
globalRequestJson.put("email" , valueEmail);
okhttp3.RequestBody requestBodyMetaData = okhttp3.RequestBody.create(okhttp3.MediaType.parse("application/json"), globalRequestJson.toString());
okhttp3.RequestBody body = new okhttp3.MultipartBody.Builder()
 .setType(okhttp3.MultipartBody.FORM)
 .addFormDataPart("horaire", null,requestBodyMetaData)
 .build();
okhttp3.Request request = new okhttp3.Request.Builder()
 .url(putUrl)
 .put(requestBodyMetaData)
 .addHeader("Cookie", fullCookies)
 .build();
okhttp3.Response response = client.newCall(request).execute();
String responseJson = response.body().string();#  Mise à jour du rendez-vous de métrage
**Date de mise à jour** : 12/08/2022

**Déclencheur** : A la creation d'un Work Order de type METRAGE alors on envoie une nouvelle date de rendez-vous à Sinapps.

**Ressources Sinapps à mettre à jour** : Prestation

**Objets Salesforce Source** : WorkOrder

**Champs Salesforce Source** : 
- WorkOrder > StartDate
- WorkOrder > EndDate
- WorkOrder > CaseId > Sinapps_Id_Prestation__c

## Endpoint pour récupérer l'URL de l'appel SINNAPPS 
Il s'agit de récupérer la commande 'prendreRendezVous' sur la prestation avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/prestation/<prestationId>/commands/prendreRendezVous
## json en paramètre de la requête

```
{
  "horaire": {
    "name": "HoraireFixe",
    "label": "HoraireFixe",
    "value": {
      "date": "2022-08-11",
      "heure": "string"
    }
  },
  "dureeRendezVous": "string",
  "notes": "string",
  "typeRendezVous": {
    "name": "Site",
    "label": "En visio"
  },
  "nomIntervenant": "string",
  "prenomIntervenant": "string",
  "telephoneIntervenant": "string",
  "referenceIntervenant": "string",
  "lieuRendezVous": {
    "adresse1": "string",
    "adresse2": "string",
    "adresse3": "string",
    "adresse4": "string",
    "codePostal": "string",
    "localite": "string",
    "codePays": "string",
    "nomPays": "string"
  },
  "acteursConvoques": [
    {
      "acteurId": "string",
      "acteurConvoque": true
    }
  ],
  "identifiantExpert": "string",
  "montantFranchise": 0,
  "motifNonIntervention": {
    "name": "Autre",
    "label": "Autre"
  },
  "commentaire": "string"
}
```

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
#  Mise à jour du rendez-vous de pose
**Date de mise à jour** : 12/08/2022

TOD : Fix Article

**Déclencheur** : A la creation d'un Work Order de type POSE alors on envoie une nouvelle date de rendez-vous à Sinapps.

**Ressources Sinapps à mettre à jour** : Prestation

**Objets Salesforce Source** : WorkOrder

**Champs Salesforce Source** : 
- WorkOrder > Date_RDV__c
- WorkOrder > CaseId > Sinapps_Id_Prestation__c

## Endpoint pour récupérer l'URL de l'appel SINNAPPS
Il s'agit de récupérer la commande 'planifierIntervention' sur la prestation avec la mécanique de découvrabilité de l'API.

Ce qui devrait revoyer une URL proche de : <baseUrl>+/core/api/covea/prestation/<prestationId>/commands/prendreRendezVous
## json en paramètre de la requête

```
{
  "planification": {
    "name": "PlanificationPlage",
    "label": "PlanificationPlage",
    "value": {
      "horizon": "string"
    }
  },
  "commentaire": "string"
}
```

## Réponse SINAPPS
Vérifier le code HTTP de la réponse s'il est différent de 200 renvoyer une Exception fonctionnelle
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