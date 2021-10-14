@IsTest
public class TopLevelParentSchedulableTest {
	private static testMethod void test() {
            Test.startTest();
            System.schedule('TopLevelParentSchedulable', '0 0 0 * * ?', new TopLevelParentSchedulable());
            Test.stopTest();
        }  
}