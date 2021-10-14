@isTest
public class TopLevelParentTest {
    private static testMethod void test() 
        {
            Test.startTest();
            Account Acc1 = new Account();
            Acc1.Name = 'Test1';
            Acc1.BillingState = 'Illinois';
            Acc1.BillingPostalCode = '60133';
            Acc1.Firm_Type__c = 'Health System';
            insert Acc1;
            Account Acc2 = new Account();
            Acc2.Name = 'Test2';
            Acc2.BillingState = 'Illinois';
            Acc2.BillingPostalCode = '60133';
            Acc2.Firm_Type__c = 'Health System';
            Acc2.ParentId = Acc1.id;
            insert Acc2;
            Account Acc3 = new Account();
            Acc3.Name = 'Test3';
            Acc3.BillingState = 'Illinois';
            Acc3.BillingPostalCode = '60133';
            Acc3.Firm_Type__c = 'Health System';
            Acc3.ParentId = Acc2.id;
            insert Acc3;
            Account Acc4 = new Account();
            Acc4.Name = 'Test4';   
            Acc4.BillingState = 'Illinois';
            Acc4.BillingPostalCode = '60133';
            Acc4.Firm_Type__c = 'Health System';
            Acc4.ParentId = Acc3.id;
            insert Acc4;
            
            Test.stopTest();     
        }
}