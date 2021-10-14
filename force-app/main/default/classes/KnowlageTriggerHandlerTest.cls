@isTest
public class KnowlageTriggerHandlerTest {

	public static String docString ='[{"attributes":{"type":"ContentDocumentLink","url":"/services/data/v52.0/sobjects/ContentDocumentLink/06A8G0000000GshUAE"},"Id":"06A8G0000000GshUAE","ContentDocumentId":"0698G0000000BYgQAM"}]';

	@isTest
	static void updateKnowlage(){
		Knowledge__kav ka = new Knowledge__kav();
		ka.Title = 'Salesforce CRM';
		ka.UrlName = 'salesforce-crm';
		ka.Summary = 'Salesforce Cloud CRM';
		ka.Language = 'en_US';
		insert ka;
		Test.startTest();


		ka.Ad_Description__c ='Test';
		ka.Ad__c ='Test';
		ka.Ad_Link__c = 'Test-One';
		update ka;
		Test.stopTest();
		Knowledge__kav k = [SELECT Title,UrlName,Summary,Language,Ad_Description__c FROM Knowledge__kav WHERE Id=: ka.Id];
		System.assertEquals(k.Ad_Description__c, ka.Ad_Description__c);
	}

}