# Création d'une prestation

**Evènement** : PrestationCree

**Objets Salesforce Créés** : Case, MessageClient__c, Account

**Ressources Sinapps** : Prestation, Mission, DossierSinistre, SuiviInformation

**Date de mise à jour** : 02/01/2023


## Creation d'un compte

Chaque nouvelle prestation Sinappes génère un nouveau Account (Compte Professionnel) avec le numéro d'évènement Sinapps correspondant à la création de la prestation associée.

Si un compte avec ce numéro d'évènement est déjà présente en base de données le compte ne doit pas être créé ni aucun autre objet. Ceci permet d'éviter des erreurs de rejeux intempestif (idempotence).

Les addresses 1,2,3 et 4 sont séparées par des retours à la ligne et concaténées dans le même champ Salesforce

La ressource DossierSinistre est accessible dans les liens (links["rel"="dossierSinistre"]) de la ressource prestation.

|**Salesforce Fields** |**Sinapps Ressource** |**Sinapps path** |**Comments** |
|-------------------|-------------------|--------------|--------------|
| RecordType |  |  | Entreprise |
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
| Industry |  | | "autre secteur d'activité" |
| ShippingStreet | DossierSinistre | properties.sinistre.adresse.adresse1 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse2 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse3 ||
| ^ | DossierSinistre | properties.sinistre.adresse.adresse4 ||
| ShippingPostalCode | DossierSinistre | properties.sinistre.adresse.codePostal ||
| ShippingCity | DossierSinistre | properties.sinistre.adresse.localite ||
| Email_Pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.email | |
| Telephone_mobile_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPortable |  |
| Autre_telephone_pro__c | DossierSinistre | properties.acteurs[0].personne.coordonnees.telPersonnel |  |
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
