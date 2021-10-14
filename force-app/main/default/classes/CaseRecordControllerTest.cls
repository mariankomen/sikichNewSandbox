@isTest
public with sharing class CaseRecordControllerTest {
    
    @TestSetup
    static void makeData(){
        String RTInquiryId = [SELECT id from RecordType where Name ='Inquiry'].Id;
        Case c = new Case(Subject='test', RecordTypeId=RTInquiryId);
        insert c;
        
        ContentVersion contentVersion = new ContentVersion(Title = 'Penguins',PathOnClient = 'Penguins.jpg',VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = c.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        
        
        FeedItem f = new FeedItem();
        f.Body = 'legal test';
        f.parentID = c.Id;
        
        insert f;

        FeedComment fedcom = new FeedComment(CommentBody='test', FeedItemId=f.Id);
        insert fedcom;
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Id= f.CreatedById, Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standASDarduser@testorg.com');
        insert u;
    }

    @isTest
    public static void getRecordDetailTest(){
        Case l = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
        Case k = CaseRecordController.getRecordDetail(l.Id);
        system.assertNotEquals(null, k);
    }
    @isTest
    public static void getAttachmentsTest(){
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        Case c = [SELECT Id FROM Case WHERE Subject='test'];
        List<String> l = CaseRecordController.getAttachments(c.Id);
        system.assertNotEquals(null, l.size());
    }

    @isTest
    public static void getChatterTest(){
        Case l = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
        List<CaseRecordController.CommentWrapper> k = CaseRecordController.getChatter(l.Id);
        system.assertNotEquals(null, k.size());

    }
    @isTest
    public static void saveTheChunkFileTest(){
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];

        ContentVersion versionData = [
				SELECT Id, VersionData,ContentDocumentId
				FROM ContentVersion
				WHERE ContentDocumentId =: documents[0].id LIMIT 1
		];
        Case c = [SELECT Id FROM Case LIMIT 1];
        Id test = CaseRecordController.saveFiles(c.Id, 'test', '543');
        // Id test1 = CaseRecordController.saveTheChunk(c.Id, 'test', '543', 'test', versionData.Id);
    }

    // @isTest
    // public static void createCommentTest(){
    //     Case c = [SELECT Id FROM Case WHERE Subject='test' LIMIT 1];
    //     CaseRecordController.createComment(c.Id, '<img src="testImg">Test</img>');
    // }
}