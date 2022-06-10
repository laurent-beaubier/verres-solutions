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
- [Paramètres](context.txt)