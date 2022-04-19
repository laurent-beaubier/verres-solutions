**Evènement** : PrestationCree

**Objets Salesforce Créés** : Case, MessageClient__c, Account

**Ressources Sinapps** : Prestation, Mission, DossierSinistre, SuiviInforation

**Date de mise à jour** : 19/05/2022

# Mapping des données

## Creation d'un compte

Chaque nouvelle prestation entraine la création d'un nouveau Account (Compte) avec le numéro d'évènement Sinapps correspondant à la création de la prestation associée.

Si un compte avec ce numéro d'évènement est déjà présente en base de données le compte ne doit pas être créé ni aucun autre objet. Ceci permet d'éviter des erreurs de rejeux intempestif (idempotence).

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource dossierSinistre

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Sinapps name** |**Comments** |
|-------------------|-------------------|--------------|--------------|---------|
| RecordType |  |  |  |  valeur selon particulier / entreprise |
| D_eduction_de_TVA__c |  |  |  |  vrai/faux selon entreprise/particulier  |
| Salutation | Mission | properties.dossier.acteurs[0].personne.civilite | label | pour un particulier uniquement (voir Tranco des civilités)|
| LastName | Mission | properties.dossier.acteurs[0].personne | nom | pour un particulier uniquement |
| FirstName | Mission | properties.dossier.acteurs[0].personne | prenom | pour un particulier uniquement |
| Name | Mission | properties.dossier.acteurs[0].personne | nom | pour une entreprise uniquement |
| Type |  |  |  |  valeur en dur 'Prospect'|
| BillingStreet | Mission | properties.dossier.acteurs[0].personne.adresse | adresse1  | |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse2  | |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse3  | |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse4  | |
| BillingPostalCode | Mission | properties.dossier.acteurs[0].personne.adresse | codePostal | |
| BillingCity | Mission | properties.dossier.acteurs[0].personne.adresse | localite | |
| Fax | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPersonnel | |
| PersonMobilePhone | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPortable | pour les particuliers uniquement |
| Phone | Mission | properties.dossier.acteurs[0].personne.coordonnees | telProfessionnel | |
| PersonEmail | Mission | properties.dossier.acteurs[0].personne.coordonnees | email | pour les particuliers uniquement  |
| Industry |  | |  | "autre secteur d'activité" pour les entreprises uniquement  |
| ShippingStreet | Mission | properties.dossier.sinistre.adresse | adresse1 ||
| ^ | Mission | properties.dossier.sinistre.adresse | adresse2 ||
| ^ | Mission | properties.dossier.sinistre.adresse | adresse3 ||
| ^ | Mission | properties.dossier.sinistre.adresse | adresse4 ||
| ShippingPostalCode | Mission | properties.dossier.sinistre.adresse | codePostal ||
| ShippingCity | Mission | properties.dossier.sinistre.adresse | localite ||
| PersonTitle | Mission | properties.dossier.acteurs[0].personne.informationAssure | profession | pour les particuliers uniquement |
| Email_Pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | email | pour les professionnels uniquement |
| Telephone_mobile_pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPortable | pour les professionnels uniquement |
| Autre_telephone_pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPersonnel | pour les professionnels uniquement |
| Numero_Evenement_Sinapps__c | Event |  properties | id | numéro de l'évènement de création de mission |

### Tranco des civilités

|**Sinapps** |**Noé** |
|---------|-----|
| Professeur | M. |
| Maître | M. |
| Monsieur | M. |
| Madame| Mme |
| Autres valeurs | ne pas mettre à jour le champ |
## Creation d'une affaire

Chaque nouvelle prestation entraine la création d'une nouveau **Case** (affaire). 

Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource dossierSinistre

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Sinapps name** |**Comments**|
|-------------------|-------------------|--------------|--------------|---------|
| Type |  |  |  | 'Vitrage de menuiserie'  |
| Status |  |  |  | 'Nouvelle'  |
| Description | Mission | properties.dossier.sinistre | dommagesDeclares | "Dommages déclarés : " sur une première ligne |
| ^ |  |  | MissionnementSinistreCirconstances | "Circonstances déclarées : "  sur une seconde ligne |
| ^ | dossierSinistre | properties.sinistre.caracteristiques.detail | name |  "Détail du sinistre : " sur une 3eme ligne  |
| ^ | Mission | properties.dossier.sinistre.caracteristiques.cause | label  | "Cause du sinistre : " sur une 4eme ligne |
| Client_final__c |  |  |  | Le compte nouvellement créé  |
| Reference_dossier__c | dossierSinistre | properties.sinistre | reference |   |
| TECH_RefSinistre__c | dossierSinistre | properties.sinistre | reference | |
| Nature_du_sinistre | dossierSinistre | properties.sinistre.caracteristiques.nature | label | voir Tranco des natures de mission
| TechAffaireInterface__c |  |  |  | true |
| Site_d_intervention__c |  |  |  | Le site d'intervention créé par automatisme à la création du compte (lookup vers le compte)  
| Franchise_a_collecter__c | dossierSinistre | properties.contrats[0].franchise.value | montant | le premier qui est renseigné |
| ^ | dossierSinistre | properties.franchiseApplicable.value | montant | ^ |
| Franchise_collectee__c |  |  |  | false  |
| TechCoveaExecution__c |  |  |  | Id de mission  |
| TVA_a_collecter__c |  |  |  | vrai pour une entreprise faux sinon  |
| Type_de_Local__c |  |  | AssureRisqueTypeRisqueLabel  |  |
| Usage_Local__c |  |  | AssureRisqueUsageAssureLabel  |  |
| Suivi_assure_activite_donneur_ordre__c | SuiviInformation | properties.statutSuiviInformation | name | faux si suiviAssureStatus.equals = "Desactive"   |
| Num_Contrat__c | dossierSinistre | properties.contrat.numero | label  |  |
| Qualite_Assure__c | Mission | properties.dossier.acteurs[0].relationAuRisque | label  |  |
| Date_du_sinistre__c | dossierSinistre | properties.sinistre | date  |  |
| TypeDeMission__c | Mission | mission.typeMission | name | voir Tranco des types de mission 
| AssureurId |  |  | AssureurId  |  |
| Numero_Evenement_Sinapps__c | Event |  properties | id | numéro de l'évènement de création de mission |
| Sinapps_Id_Prestation__c | Prestation | properties | id |  |
| Sinapps_Id_Mission__c | Mission |  properties| id |  |
| TECH_RefMission__c |  |  | MissionnementNumero  |  |

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

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Sinapps name** |**Comments**|
|-------------------|-------------------|--------------|--------------|---------|
| Contenu__c | Mission | properties.mission.commentaires | messages | fusionnés et séparés par des ----------------- |
| Auteur__c |  |  |  |  'API' |
| Type__c |  |  |  |  'Commentaires initiaux de mission' |
| Affaire__c |  |  |  |  Id du Case |
| Numero_Evenement_Sinapps__c | Event |  properties | id | numéro de l'évènement de création de mission |

## Creation du second commentaire

Chaque nouvelle prestation entraine la création d'un enregistrement MessageClient__c (commentaire) contenant les informations initiales de la mission. 
Comme pour le compte l'idempotence est assurée par la présence d'un champ contenant le numéro d'évènement.
Il ne faut pas créer 2 commentaire de type **Informations initiales de la mission** avec le même numéro d'évènement.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Sinapps name** |**Comments**|
|-------------------|-------------------|--------------|--------------|---------|
| Contenu__c |  |  |  |  voir tableau ci-dessous |
| Auteur__c |  |  |  |  'API' |
| Type__c |  |  |  |  'Informations initiales de la mission' |
| Affaire__c |  |  |  |  Id du Case |
| Numero_Evenement_Sinapps__c | Event |  properties | id | numéro de l'évènement de création de mission |

### Contenu du commentaire

|**Préfixe** |**Sinapps Ressource** |**Sinapps path** |**Sinapps name** |
|---------|-------------------|--------------|--------------|
| Cause du sinistre  | dossierSinistre | properties.sinistre.caracteristiques.cause | label |
| Détail du sinistre | dossierSinistre | properties.sinistre.caracteristiques.detail | name |
| Dommages déclarés | Mission | properties.dossier.sinistre | dommagesDeclares |
| Circonstances | dossierSinistre | properties.sinistre | circonstancesDeclarees |
| Nature du sinistre | dossierSinistre | properties.sinistre.caracteristiques.nature | label |
| Date du sinistre  | Mission | properties.dossier.sinistre | date |
| Adresse du sinistre | Mission | properties.dossier.sinistre.adresse | adresse1 |
| ^ | Mission | properties.dossier.sinistre.adresse | adresse2 |
| ^ | Mission | properties.dossier.sinistre.adresse | adresse3 |
| ^ | Mission | properties.dossier.sinistre.adresse | adresse4 |
| ^ | Mission | properties.dossier.sinistre.adresse | codePostal |
| ^ | Mission | properties.dossier.sinistre.adresse | localite |
| ^ | Mission | properties.dossier.sinistre.adresse | codePays |
| Référence sinistre | dossierSinistre | properties.sinistre | reference
| Type de mission  | Mission | mission.typeMission | name | 
| Référence mission  | Mission | properties.mission | numero |
| Assureur émetteur  | Mission | properties.missioncontactAssureur.value.personne | nom |
| Entreprise mandatée | Prestation | properties |  prestataireId |
| Date de missionnement | Mission | properties.mission | dateDeMissionnement |
| Type de risque | dossierSinistre | properties.risques[0].typeRisque | label |
| Usage du risque | dossierSinistre | properties.risques[0].usageAssure | label |
| Qualité de l'assuré | Mission | properties.dossier.acteurs[0].relationAuRisque | label |
| Mesure 1  | Mission | properties.dossier.risques[0].mesures[0].typeMesure | label |
| ^ | Mission | properties.dossier.risques[0].mesures[0] | valeur |
| Mesure 2 | Mission | properties.dossier.risques[0].mesures[1].typeMesure | label |
| ^  | Mission | properties.dossier.risques[0].mesures[1] | valeur |
| Mesure 3 | Mission | properties.dossier.risques[0].mesures[2].typeMesure | label |
| ^ | Mission | properties.dossier.risques[0].mesures[1] | valeur |
| Nom de l'assuré  | Mission | properties.dossier.acteurs[0].personne | nom |
| Adresse de l'assuré  | Mission | properties.dossier.acteurs[0].personne.adresse | adresse1  |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse2  |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse3  |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse4  |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | codePostal |
| ^ | Mission | properties.dossier.acteurs[0].personne.adresse | localite |
| Téléphone personnel | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPersonnel |
| Téléphone portable | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPortable |
| Téléphone professionnel| Mission | properties.dossier.acteurs[0].personne.coordonnees | telProfessionnel |
| Email de l'assuré | Mission | properties.dossier.acteurs[0].personne.coordonnees | email |
| Profession de l'assuré| Mission | properties.dossier.acteurs[0].personne.informationAssure | profession |
| Numéro de contrat | dossierSinistre | properties.contrat.numero | label 
| Type de contrat | Mission | properties.dossier.contrat | typeContrat |
| Activités professionnelles 1 | Mission | properties.missionnement.informationAssure.contrat | activiteSouscrite[0] |
| Activités professionnelles 2 | Mission | properties.dossier.informationsAssure.contrat | activitesSouscrites[1] |
| Activités professionnelles 3 | Mission | properties.dossier.informationsAssure.contrat | activitesSouscrites[2] |
| Franchise | dossierSinistre | properties.franchiseApplicable.value | montant |
| Code Gestionnaire | Mission | properties.mission.contactAssureur.value | code |
| Nom Gestionnaire | Mission | properties.mission.contactAssureur.value.personne | nom |
| Adresse Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.adresse | adresse1  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse | adresse2  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse | adresse3  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse | codePostal  |
| ^ | Mission | properties.mission.contactAssureur.value.personne.adresse | localite  |
| Téléphone personnel Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees | telPersonnel |
| DossierGestionnaireCoordTelPortable | Mission | properties.mission.contactAssureur.value.personne.coordonnees | telPortable |
| Téléphone Professionnel Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees | telProfessionnel |
| Email Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees | email |
| Fax Gestionnaire | Mission | properties.mission.contactAssureur.value.personne.coordonnees | fax |
| Convention IRSI applicable | dossierSinistre | properties.sinistre | ConventionIRSIAApplicable |
| Nbre de pièces | dossierSinistre | properties.risques[0].mesures[?(@.typeMesure.name=='NombreDePieces')] | valeur |
| Superficie | dossierSinistre | .risques[0].mesures[?(@.typeMesure.name=='Superficie')] | valeur |
| Clauses particulières | dossierSinistre | properties.contrat | clausesParticulieres |
| Informations spécifiques | dossierSinistre | properties.contrat | informationsSpecifiques |
| Apporteur d’affaires | dossierSinistre | properties.contrats[0].apporteur | nom |
| Contrat professionnel | dossierSinistre | properties.contrat | professionnel |
| Numéro de contrat d’assistance | dossierSinistre | properties.contrat.numero | label |
