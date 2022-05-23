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
String responseJson = response.body().string();