@isTest
public with sharing class CasesControllerTest {
    @isTest
    public static void getListCasesTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new HttpResponseGenerator());
        
        ListView lv = [SELECT Id, Name FROM ListView where SobjectType = 'Case' LIMIT 1];
        System.debug(lv.Id);
        CasesController.getListCases(lv.Id);
        Test.stopTest();
    }
    @isTest
    public static void getListViewTitlesTest(){
        insert new ListViewLabels__c(Name='Labels',ListLabels__c = 'Test,Test,Test');
        String listViews = CasesController.getListViewTitles();
        System.assertNotEquals(null, listViews);
    }
    @isTest
    public static void getCreateCasePicklistValueTest(){
        String picklistValues = CasesController.getCreateCasePicklistValue();
        System.assertNotEquals(null, picklistValues);
    }
    @isTest
    public static void createInquiryCaseTest(){
        Account testAccount =  new Account(Name='TestAcc', Firm_Type__c='Hospital', BillingState='Alabama', BillingPostalCode='31312' );
        insert testAccount;
        Id UserID = UserInfo.getUserId();
        User curUser = [SELECT Id, FirstName, LastName, Name FROM User Where Id=:UserID];
        Contact testContact = new Contact(FirstName=curUser.FirstName,LastName=curUser.LastName,AccountId=testAccount.Id, Phone='3333', Email='test@gmail.com');
        insert testContact;
        String createdCaseId = CasesController.createInquiryCase('Test', 'Test', 'test@gmail.com','Test', new List<String>{'0698G00000005u2QAA'}, 'test');
        System.assertNotEquals(null, createdCaseId);
    }
    
}