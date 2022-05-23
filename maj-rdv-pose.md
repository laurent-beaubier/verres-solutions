-refDossier
-récuperation de la mission

Dans la mission récupérer :
context.darva_ref_mission_id=(String)row20.TechCoveaExecution__c;
context.new_date_pose= row20.Date_RDV_POSE_prevue__c;

appel pour touver l'id de planification context.URI_travaux.substring(0,context.URI_travaux.length()-1)  : dans la réponse : "@.properties.id" et "@.properties.planification.name" retrouve la planification
filtrer sur "PlanificationPlage"
context.planificationId= row16.planificationId = "@.properties.id";

appel context.URI_travaux + context.planificationId + context.URI_modif_RDV_travaux (/core/api/covea/travaux/) pour la découvrabilité


String baseUrl = context.URL ;
String hrefUrl1 = context.URI_take_RDV_travaux;
String hrefUrl2 = context.darva_ref_mission_id;
String hrefUrl3 = context.URI_take_RDV2;
String putUrl = baseUrl + context.darva_rdv_dynamic_link_uri;

String travauxDate = routines.TalendDate.formatDate("yyyy-MM-dd",context.new_date_pose);
ZoneId defaultZoneId = ZoneId.of("CET");
DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");//'2011-12-03T10:15:30Z'.
String sdate = dateFormat.format(context.new_date_pose);
LocalDateTime pp = LocalDateTime.parse(sdate,DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"));
ZonedDateTime currentUTCTime = pp.atZone(ZoneId.of("UTC"));
ZonedDateTime currentCETime = currentUTCTime.withZoneSameInstant(defaultZoneId);
String travauxHeure = currentCETime.format(DateTimeFormatter.ofPattern("HH:mm"));
JSONObject valueJson = new JSONObject();
valueJson.put("dateDebut", travauxDate);
valueJson.put("heureDebut", travauxHeure);
JSONObject planificationJson = new JSONObject();
planificationJson.put("name" , "PlanificationPlage");
planificationJson.put("value" , valueJson);
JSONObject globalplanificationJson = new JSONObject();
globalplanificationJson.put("planification" , planificationJson);
okhttp3.RequestBody requestBodyMetaData = okhttp3.RequestBody.create(okhttp3.MediaType.parse("application/json"), globalplanificationJson.toString());
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
String responseJson = response.body().string();