**Evènement** : PrestationCree

**Objets Salesforce Créés** : Case, MessageClient__c, Account

**Ressources Sinapps** : Prestation, Mission, DossierSinistre, SuiviInforation

**Date de mise à jour** : 19/05/2022

# Mapping des données

## Creation d'un compte

Chaque nouvelle prestation entraine la création d'un nouveau compte possedant une clé de mission. Si la clé de mission est déjà présente en base de données le compte ne doit pas être créé ni aucun autre objet. Ceci permet d'éviter des erreurs de rejeux intempestif.

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource dossierSinistre

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

| Salesforce Object | Salesforce Fields | Sinapps Ressource | Sinapps path | Sinapps name | Comments|
|-------------------|-------------------|-------------------|--------------|--------------|---------|
| Account | RecordType |  |  |  |  valeur en dur selon particulier / entreprise |
| Account | D_deuction_de_TVA__c |  |  |  |  vrai/faux selon entreprise/particulier  |
| Account | Salutation | Mission | properties.dossier.acteurs[0].personne | ????? non mappé dans Talend ???? | pour un particulier uniquement transco xxxxx |
| Account | LastName | Mission | properties.dossier.acteurs[0].personne | nom | pour un particulier uniquement |
| Account | FirstName | Mission | properties.dossier.acteurs[0].personne | ????? non mappé dans Talend ???? | pour un particulier uniquement |
| Account | Name | Mission | properties.dossier.acteurs[0].personne | nom | pour une entreprise uniquement |
| Account | Type |  |  |  |  valeur en dur 'Prospect'|
| Account | BillingStreet | Mission | properties.dossier.acteurs[0].personne.adresse | adresse1  | |
| Account | ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse2  | |
| Account | ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse3  | |
| Account | ^ | Mission | properties.dossier.acteurs[0].personne.adresse | adresse4  | |
| Account | BillingPostalCode | Mission | properties.dossier.acteurs[0].personne.adresse | codePostal | |
| Account | BillingCity | Mission | properties.dossier.acteurs[0].personne.adresse | localite | |
| Account | Fax | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPersonnel | |
| Account | PersonMobilePhone | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPortable | pour les particuliers uniquement |
| Account | Phone | Mission | properties.dossier.acteurs[0].personne.coordonnees | telProfessionnel | |
| Account | PersonEmail | Mission | properties.dossier.acteurs[0].personne.coordonnees | email | pour les particuliers uniquement  |
| Account | Industry |  | |  | "autre secteur d'activité" pour les entreprises uniquement  |
| Account | ShippingStreet | Mission | properties.dossier.sinistre.adresse | adresse1 ||
| Account | ^ | Mission | properties.dossier.sinistre.adresse | adresse2 ||
| Account | ^ | Mission | properties.dossier.sinistre.adresse | adresse3 ||
| Account | ^ | Mission | properties.dossier.sinistre.adresse | adresse4 ||
| Account | ShippingPostalCode | Mission | properties.dossier.sinistre.adresse | codePostal ||
| Account | ShippingCity | Mission | properties.dossier.sinistre.adresse | localite ||
| Account | PersonTitle | Mission | properties.dossier.acteurs[0].personne.informationAssure | profession | pour les particuliers uniquement |
| Account | Email_Pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | email | pour les professionnels uniquement |
| Account | Telephone_mobile_pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPortable | pour les professionnels uniquement |
| Account | Autre_telephone_pro__c | Mission | properties.dossier.acteurs[0].personne.coordonnees | telPersonnel | pour les professionnels uniquement |
| Account | CleMission__c | Mission |  |  | calcul xxxx|

## Creation d'une affaire

Chaque nouvelle prestation entraine la création d'une nouvelle affaire possedant une clé de mission. Si la clé de mission est déjà présente en base de données l'affaire ne doit pas être créée. Ceci permet d'éviter des erreurs de rejeux intempestif. Les commentaires associés à l'affaire ne doivent pas non plus créer de doublons dans ce cas.

On détermine si un compte correspond à un particulier ou à un professionnel en fonction de la valeur de la propriété properties.contrat.professionnel sur la ressource dossierSinistre

| Salesforce Object | Salesforce Fields | Sinapps Ressource | Sinapps path | Sinapps name | Comments|
|-------------------|-------------------|-------------------|--------------|--------------|---------|
| Case | Type |  |  |  | 'Vitrage de menuiserie'  |
| Case | Status |  |  |  | 'Nouvelle'  |
| Case | Description |  |  | MissionnementSinistreDommagesConstates | "Dommages déclarés : " sur une première ligne |
| Case | ^ |  |  | MissionnementSinistreCirconstances | "Circonstances déclarées : "  sur une seconde ligne |
| Case | ^ |  dossierSinistre | properties.sinistre.caracteristiques.detail | name |  "Détail du sinistre : " sur une 3eme ligne  |
| Case | ^ |  |  | SinistreInitialCauseLabel | "Cause du sinistre : " sur une 4eme ligne |
| Case | Client_final__c |  |  |  | Le compte nouvellement créé  |
| Case | Reference_dossier__c | dossierSinistre | properties.sinistre | reference |   |
| Case | TECH_RefSinistre__c | dossierSinistre | properties.sinistre | reference | |
| Case | Nature_du_sinistre |  |  | NatureSinistre  |  |
| Case | TechAffaireInterface__c |  |  |  | true |
| Case | Site_d_intervention__c |  |  |  | Le site d'intervention créé par automatisme à la création du compte (lookup vers le compte)  
| Case | Franchise_a_collecter__c |  |  | MissionnementFranchiseMontant ou franchiseApplicable | le premier qui est renseigné |
| Case | ^ | dossierSinistre | properties.franchiseApplicable.value | montant | ^ |
| Case | Franchise_collectee__c |  |  |  | false  |
| Case | TechCoveaExecution__c |  |  |  | Id de mission  |
| Case | TVA_a_collecter__c |  |  |  | vrai pour une entreprise faux sinon  |
| Case | Type_de_Local__c |  |  | AssureRisqueTypeRisqueLabel  |  |
| Case | Usage_Locale__c |  |  | AssureRisqueUsageAssureLabel  |  |
| Case | Suivi_assure_activite_donneur_ordre__c |  |  | suiviAssureStatus | faux si suiviAssureStatus.equals = "Desactive"   |
| Case | Num_Contrat__c | dossierSinistre | properties.contrat.numero | label  |  |
| Case | Qualite_Assure__c |  |  | AssureRisqueRelationAssureLabel  |  |
| Case | Date_du_sinistre__c | dossierSinistre | properties.sinistre | date  |  |
| Case | TypeDeMission__c |  |  | typeDeMissions |  |
| Case | CleMission__c | Mission |  |  | calcul xxxx |
| Case | AssureurId |  |  | AssureurId  |  |
| Case | Sinapps_Id_Prestation__c |  |  | Sinapps_Id_Prestation__c  |  |
| Case | Sinapps_Id_Mission__c |  |  | Sinapps_Id_Mission__c   |  |
| Case | TECH_RefMission__c |  |  | MissionnementNumero  |  |

## Creation du premier commentaire

| Salesforce Object | Salesforce Fields | Sinapps Ressource | Sinapps path | Sinapps name | Comments|
|-------------------|-------------------|-------------------|--------------|--------------|---------|
| MessageClient__c | Contenu__c | Mission | properties.mission.commentaires | messages | fusionnés et séparés par des ----------------- |
| MessageClient__c | Auteur__c |  |  |  |  'API' |
| MessageClient__c | Type__c |  |  |  |  'Commentaires initiaux de mission' |
| MessageClient__c | Affaire__c |  |  |  |  Id du Case |

## Creation du second commentaire

| Salesforce Object | Salesforce Fields | Sinapps Ressource | Sinapps path | Sinapps name | Comments|
|-------------------|-------------------|-------------------|--------------|--------------|---------|
| MessageClient__c | Contenu__c |  |  |  |  voir tableau ci-dessous |
| MessageClient__c | Auteur__c |  |  |  |  'API' |
| MessageClient__c | Type__c |  |  |  |  'Informations initiales de la mission' |
| MessageClient__c | Affaire__c |  |  |  |  Id du Case |

### Contenu du commentaire

| Préfixe | Sinapps Ressource | Sinapps path | Sinapps name |
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
