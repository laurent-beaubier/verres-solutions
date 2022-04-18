| Case | Sinapps_Prestation_Id | Prestation | properties | id |
| Case | Sinapps_Mission_Id | Prestation | properties | missionId |
| Case | prestataireId | Prestation | properties |  prestataireId |
| Case | atat | Prestation | properties.etat | label |
| Case | typeDePrestation | Prestation | properties.typeDePrestation | label |
| Case | estCloturee | Prestation | properties | estCloturee |
| Case | initiateurId | Prestation | properties | initiateurId |
| Case | criticite | Prestation | properties.criticite | label |
| Case | anomalieEnCours | Prestation | properties | anomalieEnCours |
| Case | Salesforce Fields | Prestation | properties |  |
| Case | RessourceId | Mission | properties | Id |
| Case | dateDeCreation | Mission | properties | dateDeCreation |
| Case | dateDeDerniereModification | Mission | properties | dateDeDerniereModification |
| Case | nouveauxCommentaires | Mission | properties | nouveauxCommentaires |
| Case | commentaires | Mission | properties.mission | commentaires.messages fusionnés et séparés par des ----------------- |
| Case | MissionnementSinistreDommageConstates | Mission | properties.dossier.sinistre | dommagesDeclares |
| Case | assureurId | Mission | properties.dossier.sinistre | assureurId |
| Case | SinistreDate | Mission | properties.dossier.sinistre | date |
| Case | SinistreReference | Mission | properties.dossier.sinistre | reference |
| Case | SinistreNatureName | Mission | properties.dossier.sinistre.caracteristiques.nature | name |
| Case | SinistreNatureLabel | Mission | properties.dossier.sinistre.caracteristiques.nature | label |
| Case | SinistreCauseName | Mission | properties.dossier.sinistre.caracteristiques.cause | name |
| Case | SinistreCauseLabel | Mission | properties.dossier.sinistre.caracteristiques.cause | label |
| Case | MissionnementInformationAssureUsageAssure | Mission | properties.dossier.risques[0].usageAssure | label |
| Case | Assureur | Mission | mission.contactAssureur.value.personne | nom |
| Case | statutSuivi | SuiviInformation | properties.statutSuiviInformation | name |
| Case | version | dossierSinistre | properties | version |
| Case | apporteurNom | dossierSinistre | properties.contrats[0].apporteur | nom |
| Case | apporteurAdresse1 | dossierSinistre | properties.contrats[0].apporteur.adresse | adresse1 |
| Case | apporteurAdresse2 | dossierSinistre | properties.contrats[0].apporteur.adresse | adresse2 |
| Case | apporteurAdresse3 | dossierSinistre | properties.contrats[0].apporteur.adresse | adresse3 |
| Case | apporteurCodePostal| dossierSinistre | properties.contrats[0].apporteur.adresse | codePostal |
| Case | apporteurLocalite| dossierSinistre | properties.contrats[0].apporteur.adresse | localite |
| Case | apporteurCoordTelPro | dossierSinistre | properties.contrats[0].apporteur.coordonnees | telProfessionnel |
| Case | apporteurCoordTelPerso | dossierSinistre | properties.contrats[0].apporteur.coordonnees | telPersonnel |
| Case | apporteurCoordTelPortable | dossierSinistre | properties.contrats[0].apporteur.coordonnees | telPortable |
| Case | apporteurCoordEmail | dossierSinistre | properties.contrats[0].apporteur.coordonnees | email |
| Case | apporteurCoordFax | dossierSinistre | properties.contrats[0].apporteur.coordonnees | fax |
| Case | SinistreNatureName | dossierSinistre | properties.sinistre.caracteristiques.nature | name |
| Case | SinistreNatureLabel| dossierSinistre | properties.sinistre.caracteristiques.nature | label |
| Case | SinistreCauseName | dossierSinistre | properties.sinistre.caracteristiques.cause | name |
| Case | SinistreReference| dossierSinistre | properties.sinistre | reference |
| Case | SinistreDate | dossierSinistre | properties.sinistre | date |
| Case | assureContratNumero| dossierSinistre | properties.contrat.numero | label |
| Case | SinistreDetail | dossierSinistre | properties.sinistre.caracteristiques.detail | name |
| Case | ConventionIRSIAApplicable | dossierSinistre | properties.sinistre | ConventionIRSIAApplicable |

AssureurId+"-"+SinistreReference+"-"+MissionId+"-"+ PresationId = Cle de Mission
