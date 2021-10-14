@isTest
public class CaseFeedItemTriggerTest {

	@isTest
	static void caseTriggerTest(){

		User u = [Select Name, Id from User where UserPermissionsKnowledgeUser=true LIMIT 1];
		System.runAs(u){
		Account account = new Account( Name ='Test', BillingPostalCode ='79004',BillingState ='Alabama');
		insert account;
		Contact c = new Contact(
				AccountId =account.Id,
				FirstName ='Test',
				LastName='Test',
				Phone ='2122222222',
				Email='FFFF@F.com'
		);
		insert c;
		Case caseObj = new Case(
				ContactId = c.Id,
				AccountId = account.Id,
				Status = 'Open',
				Origin = 'Email',
				RecordTypeId = Schema.sObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId()
		);
		insert caseObj;
		FeedItem post = new FeedItem();
		post.ParentId = caseObj.Id;
		post.Body = 'Test';
		post.IsRichText=true;
		insert post;
		system.debug(post.Id);
			Test.startTest();
			FeedItem item= [SELECT Id, Body FROM FeedItem WHERE Id=: post.Id];

			Case cc = [SELECT Id, Status FROM Case WHERE Id =:caseObj.Id];
			Test.stopTest();
			System.assertNotEquals(null, item);
			System.assertNotEquals('Open', cc.Status);
		}


	}
}