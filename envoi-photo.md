#  Envoi Photo

**Déclencheur** : PrestationAnnulée

**Objets Salesforce Source** : Case, MessageClient__c

**Ressources Sinapps** : Prestation

**Date de mise à jour** : 20/05/2022

## Changement du statut de l'affaire


**Endpoint pour récupérer l'URL à appel** /core/api/covea/missions/<missionId>/commands/ajouterPhoto

variables :
-----------
- refDossier
- url
- mission_id
- salesforceField => ref_photo_name = salesforceField+".jpeg"
- filePath

Pour document : /core/api/covea/missions/<missionId>/commands/ajouterDocument
pour rdv /core/api/covea/missions/<missionId>/commands/prendreRendezVousAvecModifications


URL DARVA : context.URI_add_photo1 +context.darva_ref_mission_id +context.URI_add_photo2


String baseUrl = "https://sinapps-ird.vabf.darva.com";
String hrefUrl1 = "/core/api/covea/missions/";
String hrefUrl2 = context.darva_ref_mission_id;
String hrefUrl3 = "/commands/ajouterPhoto?referer=test";

context.URI_add_photo1 +context.darva_ref_mission_id +context.URI_add_photo2

String putUrl = baseUrl + context.darva_picture_dynamic_link_uri;
String posttUrl = baseUrl + hrefUrl1 + hrefUrl2 + hrefUrl3;

String photoName = context.darva_ref_photo_name;

java.io.File sourceFile = new java.io.File(context.FilePath + photoName);

okhttp3.RequestBody body = new okhttp3.MultipartBody.Builder()
 .setType(okhttp3.MultipartBody.FORM)
 .addFormDataPart("file", photoName, okhttp3.RequestBody.create(okhttp3.MediaType.parse("image/jpeg"), sourceFile))
 .build();

okhttp3.Request request = new okhttp3.Request.Builder()
 .url(putUrl)
 .put(body)
 .addHeader("content-type", "multipart/form-data")
 .addHeader("Cookie", fullCookies)
 .build();

okhttp3.Response response = client.newCall(request).execute();
String responseJson = response.body().string();