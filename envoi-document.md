type :
document_id (contentdocumentid)
mission_id (techwoveaexecution__c)

URL découvrable : context.URI_add_document1 +context.darva_mission_id +context.URI_add_document2
Pour document : /core/api/covea/missions/<missionId>/commands/ajouterDocument


retrieveFile : "SELECT ContentDocumentId, VersionData, title, FileExtension FROM ContentVersion WHERE IsLatest = true AND ContentDocumentId='"+ context.Document_Id +"' ORDER BY CreatedDate DESC LIMIT 1"

Recuperation du type de media
----------------------------

String filename = context.darva_doc_type+ "_" + input_row.Title + "." + input_row.FileExtension;
context.darva_doc_file_name= filename;

if(input_row.FileExtension != null) {

	if(input_row.FileExtension.toString().equalsIgnoreCase("txt")) {
		logger.info("Correct MediaType found for this file extension = txt");
		context.MediaType= "text/plain";
	
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("pdf")) {
		logger.info("Correct MediaType found for this file extension = pdf");
		context.MediaType= "application/pdf";
	
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("doc")) {
		logger.info("Correct MediaType found for this file extension = doc");
		context.MediaType= "application/msword";
		
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("docx")) {
		logger.info("Correct MediaType found for this file extension = docx");
		context.MediaType= "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
	  
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("xls")) {
		logger.info("Correct MediaType found for this file extension = xls");
		context.MediaType= "application/vnd.ms-excel";
		
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("xlsx")) {
		logger.info("Correct MediaType found for this file extension = xlsx");
		context.MediaType= "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
		
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("odt")) {
		logger.info("Correct MediaType found for this file extension = odt");
		context.MediaType= "application/vnd.oasis.opendocument.text";
	
	} else if (input_row.FileExtension.toString().equalsIgnoreCase("ods")) {
		logger.info("Correct MediaType found for this file extension = ods");
		context.MediaType= "application/vnd.oasis.opendocument.spreadsheet";
	}

} else {
	logger.info("Correct MediaType found for this file extension is DEFAULT");
	context.MediaType= "application/octet-stream";
}

Envoi du fichier
-------------------
String baseUrl = "https://sinapps-ird.vabf.darva.com";
String hrefUrl1 = "/core/api/covea/missions/";
String hrefUrl2 = context.darva_ref_mission_id;
String hrefUrl3 = "/commands/ajouterDocument?referer=test";
String putUrl = baseUrl + context.darva_dynamic_document_uri;
String posttUrl = baseUrl + hrefUrl1 + hrefUrl2 + hrefUrl3;

String documentName = context.darva_doc_file_name;

java.io.File sourceFile = new java.io.File(context.FilePath + documentName);

JSONObject labelJson = new JSONObject();

String docType =context.darva_doc_type;

//docType="Mandat";
if("PV de réception".equalsIgnoreCase(docType)){
	labelJson.put("name", "ProcesVerbalFinDeTravaux");

	labelJson.put("value", "Procès verbal de fin de travaux");

}else if("Cerfa TVA réduite".equalsIgnoreCase(docType)){
	labelJson.put("name", "AttestationTVA");

	labelJson.put("value", "Attestation de TVA");

}else if("Mandat".equalsIgnoreCase(docType)){
	labelJson.put("name", "DelegationDePaiement");

	labelJson.put("value", "Délégation de paiement");

};

JSONObject fileJson = new JSONObject();

fileJson.put("label", labelJson);

fileJson.put("descriptif", "Descriptif de ma PJ");

//if("Cerfa".equalsIgnoreCase(docType) || "Mandat".equalsIgnoreCase(docType))

fileJson.put("signature", true);

JSONObject globalFileJson = new JSONObject();

globalFileJson.put("file", fileJson);

okhttp3.RequestBody requestBodyMetaData = okhttp3.RequestBody.create(okhttp3.MediaType.parse("application/json"), globalFileJson.toString());

String mimeType = "application/pdf";

String metaData = globalFileJson.toString();

okhttp3.RequestBody body = new okhttp3.MultipartBody.Builder()
 .setType(okhttp3.MultipartBody.FORM)
 .addFormDataPart("file", documentName, okhttp3.RequestBody.create(okhttp3.MediaType.parse(context.MediaType), sourceFile))
 .addFormDataPart("meta", metaData)
 .build();

okhttp3.Request request = new okhttp3.Request.Builder()
 .url(putUrl)
 .put(body)
 .addHeader("Cookie", fullCookies)
 .build();

okhttp3.Response response = client.newCall(request).execute();

String responseJson = response.body().string();
