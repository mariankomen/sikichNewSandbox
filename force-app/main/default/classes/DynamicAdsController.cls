public class DynamicAdsController {

	@AuraEnabled
	public static String getImage(String recId){
		system.debug(recId);

		try{
			Knowledge__kav k =[SELECT Id FROM Knowledge__kav WHERE UrlName=:recId];
			List<ContentDocumentLink> att =[SELECT Id, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId=: k.Id ORDER BY SystemModstamp ];
			system.debug(att);
			Id i = att.get(0).ContentDocumentId;
			ContentDocument doc = [SELECT Id,Title, FileExtension FROM ContentDocument WHERE Id=:i];
			system.debug(doc);
			//Id o = doc.Id;
			ContentVersion contentVersion = [SELECT Id,VersionData FROM ContentVersion WHERE ContentDocumentId=:doc.Id];
			system.debug(contentVersion);
			return EncodingUtil.base64Encode(contentVersion.VersionData);

		}
		catch (Exception ex){
		return 'error when loading image';
		}
	}
	@AuraEnabled
	public static Knowledge__kav getDetails(String recId){
		Knowledge__kav k =[SELECT Id FROM Knowledge__kav WHERE UrlName=:recId];
		return [SELECT Id, Ad_Description__c, Ad_Link__c, Ad_Enabled__c, Ad__c FROM Knowledge__kav WHERE Id=: k.Id];
	}
}