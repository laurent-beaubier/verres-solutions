#  Envoi Photo

**Déclencheur** : à détailler à partir du CaseHandler

**Objets Salesforce Source** : Case

**Ressources Sinapps à mettre àjour** : Mission

**Date de mise à jour** : 20/05/2022

## Envoi d'une photo

baseUrl = "https://sinapps-ird.vabf.darva.com"; //Recette

baseUrl = "https://sinapps-ird.darva.com"; // Prod

**Endpoint pour récupérer l'URL à appel** <baseUrl>+/core/api/covea/missions/<missionId>/commands/ajouterPhoto
Il s'agit de récupérer la commande 'ajouterPhoto' sur la mission avec la mécanique de découvrabilité de l'API

**infos utiles à récupérer sur l'affaire (Case)**
- salesforceField => ref_photo_name = salesforceField+".jpeg"
- filePath
- url

String putUrl = baseUrl + context.darva_picture_dynamic_link_uri;

java.io.File sourceFile = new java.io.File(ref_photo_name);

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