@istest
global class TopLevelParentBatchableTest implements Schedulable {
    global void execute(SchedulableContext ctx) 
    {
        Database.executeBatch(new TopLevelParentBatchable(), 200);
    }
    
    @testSetup
    static void setup(){
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
    }
    private static testMethod void test() {
        Test.startTest();
        TopLevelParentBatchable t= new TopLevelParentBatchable();
        Id batchID=database.executeBatch(t);
        Test.stopTest();
	}  
}