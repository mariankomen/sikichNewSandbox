public with sharing class ContentDocumentLinkController {
    
    @AuraEnabled
    public static string getUploadedFiles(String ContentDocumentId){
        System.debug(ContentDocumentId);
        List<Id> IDS = ContentDocumentId.split(',');
        // List<ContentDocumentLink> fileInfo = [Select ContentDocument.Title FROM ContentDocumentLink WHERE ContentDocumentId IN: IDS];
        List<ContentDocumentLink> fileInfo = [Select ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension FROM ContentDocumentLink WHERE ContentDocumentId IN: IDS];
        return JSON.serialize(fileInfo);
    }
}