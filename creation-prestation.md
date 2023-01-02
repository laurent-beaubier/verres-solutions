# Création d'une prestation

**Evènement** : PrestationCree

**Objets Salesforce Créés** : Case, MessageClient__c, Account, Contact

**Ressources Sinapps** : Prestation, Mission, DossierSinistre, SuiviInformation

**Date de mise à jour** : 02/01/2023


## Creation d'un compte

Chaque nouvelle prestation Sinapps génère un nouveau Account (Compte Professionnel) avec le numéro d'évènement Sinapps correspondant à la création de la prestation associée.

Si un compte avec ce numéro d'évènement est déjà présent en base de données le compte ne doit pas être créé ni aucun autre objet (l'import s'arrête). Ceci permet d'éviter des erreurs de rejeux intempestif (idempotence).

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

La ressource DossierSinistre est accessible dans les liens (links["rel"="dossierSinistre"]) de la ressource prestation.

Pour déterminer si un assuré (acteur) dans Sinapps est un particulier ou une société, il faut se baser sur le dossier sinistre : properties.contrat.professionnel

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments** |
|-------------------|-------------------|--------------|--------------|
| RecordType |  |  | Professionnel |
| D_eduction_de_TVA__c | DossierSinistre | properties.contrat.professionnel | vrai/faux selon la valeur du champ professionnel |
| Name | DossierSinistre | properties.acteurs[0].personne.nom | |
| Type |  |  | valeur en dur 'Prospect'|
| BillingStreet | DossierSinistre | properties.acteurs[0].personne.adresse.adresse1  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse2  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse3  | |
| ^ | DossierSinistre | properties.acteurs[0].personne.adresse.adresse4  | |
| BillingPostalCode | DossierSinistre | properties.acteurs[0].personne.adresse.codePostal | |
| BillingCity | DossierSinistre | properties.acteurs[0].personne.adresse.localite | |
| Fax | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel | |
| Phone | DossierSinistre | properties.acteurs[0].personne.coordonnees.telProfessionnel | |
| Industry | DossierSinistre | properties.contrat.professionnel | 'autre secteur d'activité' pour un profesionnel 'Particulier' sinon |
| ShippingStreet | DossierSinistre | properties.sinistre.adresse.adresse1 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse2 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse3 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse4 ||
| ShippingPostalCode | DossierSinistre | properties.sinistre.adresse.codePostal ||
| ShippingCity | DossierSinistre | properties.sinistre.adresse.localite ||
| Email_Pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.email | |
| Telephone_mobile_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable |  |
| Autre_telephone_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel |  |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de prestation |
| AccountSource |  |  | valeur en dur 'Assurances' |
| Num_Client_SAP__c | DossierSinistre | properties.contrat.professionnel | '115787' pour un profesionnel '115777' sinon |
| Acompte_collecter__c |  |  | valeur en dur '50%' |


## Creation d'un contact

Chaque nouvelle prestation Sinapps génère un nouveau Contact associé au compte nouvellement créé (voir chapitre ci-dessus)

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

La ressource DossierSinistre est accessible dans les liens (links["rel"="dossierSinistre"]) de la ressource prestation.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments** |
|-------------------|-------------------|--------------|--------------|
| Salutation | DossierSinistre | properties.acteurs[0].personne.civilite.label | voir Tranco des civilités|
| LastName | DossierSinistre | properties.acteurs[0].personne.nom | |
| FirstName | DossierSinistre | properties.acteurs[0].personne.prenom | |
| Title | DossierSinistre | properties.acteurs[0].informationAssure.profession | |
| Phone | DossierSinistre | properties.acteurs[0].personne.coordonnees.telProfessionnel | Si Phone et MobilePone sont vides mettre le numéro fictif 0000000000 |
| MobilePhone | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable | |
| Fax | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel | |
| Email | DossierSinistre | properties.acteurs[0].personne.coordonnees.email | |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de prestation |
| Sinapps_DossierId__c | DossierSinistre |  properties.id | id du dossierSinistre |


### Tranco des civilités

|**Sinapps** |**Salesforce** |
|------------|--------|
| Professeur | M. |
| Maître | M. |
| Monsieur | M. |
| Madame| Mme |
| Autres valeurs | ne pas mettre à jour le champ |

## Creation d'une affaire

Chaque nouvelle prestation génère un nouveau **Case** (Affaire). 

Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments**|
|----------------------|----------------------|-----------------|------------|
| Client_final__c |  |  | Le compte nouvellement créé  |
| Type |  |  | 'Vitrage de menuiserie' |
| Status |  |  | 'Nouvelle' |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de prestation |
| Sinapps_Id_Prestation__c | Prestation | properties.id |  |
| Sinapps_Id_Mission__c | Mission |  properties.id |  |
| Description | DossierSinistre | properties.sinistre.dommagesDeclares | "Dommages déclarés : " sur une première ligne |
| ^ | DossierSinistre | properties.sinistre.circonstancesDeclarees | "Circonstances déclarées : "  sur une seconde ligne |
| ^ | DossierSinistre | properties.sinistre.caracteristiques.detail.name |  "Détail du sinistre : " sur une 3eme ligne  |
| ^ | DossierSinistre | properties.sinistre.caracteristiques.cause.label  | "Cause du sinistre : " sur une 4eme ligne |
| Reference_dossier__c | DossierSinistre | properties.sinistre.reference | |
| TECH_RefSinistre__c | DossierSinistre | properties.sinistre.reference | |
| Num_Contrat__c | DossierSinistre | properties.contrat.numero.label  |  |
| Nature_du_sinistre | DossierSinistre | properties.sinistre.caracteristiques.nature.label | voir Tranco des natures de mission |
| TechAffaireInterface__c | |  | true |
| Franchise_a_collecter__c | DossierSinistre | properties.contrats[0].franchise.value.montant | le premier qui est renseigné |
| ^ | DossierSinistre | properties.franchiseApplicable.value.montant | ^ |
| Franchise_collectee__c |  | | false  |
| TVA_a_collecter__c |  |  | vrai pour une entreprise faux sinon  |
| Type_de_Local__c | DossierSinistre | properties.risques[0].typeRisque.label  |  |
| Usage_Local__c | DossierSinistre | properties.risques[0].usageAssure.label  |  |
| Qualite_Assure__c | DossierSinistre | properties.acteurs[0].relationAuRisque.label  |  |
| Date_du_sinistre__c | DossierSinistre | properties.sinistre.date  |  |
| TypeDeMission__c | Mission | mission.typeMission.name | voir Tranco des types de mission |
| sinappsMissionNumber__c | Mission | mission.numero | |
| TechCoveaExecution__c | Mission |  properties.id |  |
| Suivi_assure_activite_donneur_ordre__c | SuiviInformation | properties.statutSuiviInformation.name | faux si suiviAssureStatus.equals = "Desactive"   |
| AccountId | DossierSinistre | properties.assureurId  | Remplir le lookup vers le compte assureur correspondant à partir de son TECH_IDAssureur__c |
| ContactId | |  Remplir le lookup vers le contact nouvellement créé |
| Site_d_intervention__c |  |  | Le site d'intervention créé par automatisme à la création du compte (lookup vers le compte) | 

### Tranco des types de mission

|**Sinapps** |**Salesforce** |
|---------|-----|
| RenDirecte | REN directe |
| RenSuiteExpertise | REN suite expertise |
| RenMobiliereDirecte | REN mobilière directe |
| RenMobiliereSuiteExpertise | REN mobilière suite à expertise |
| RechercheFuite | Recherche de fuite |

### Tranco des natures de mission

|**Sinapps** |**Salesforce** |
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
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de prestation |

## Creation du second commentaire

Chaque nouvelle prestation entraine la création d'un enregistrement MessageClient__c (commentaire) contenant les informations initiales de la mission. 
Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.
Il ne faut pas créer 2 commentaire de type **Informations initiales de la prestation** avec le même numéro d'évènement.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** | **Comments**|
|-------------------|-------------------|--------------|--------------|
| Contenu__c |  | |  serialiser le contenu de la ressource dossierSinistre |
| Auteur__c |  | |  'API' |
| Type__c |  | |  'Informations initiales de la mission' |
| Affaire__c | |  |  Id du Case |
| Numero_Evenement_Sinapps__c | Event |  properties.id | numéro de l'évènement de création de prestation |
