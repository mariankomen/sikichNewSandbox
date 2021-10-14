public class CaseFeedItemTriggerHandler {
	public CaseFeedItemTriggerHandler(List<FeedItem> feedItems) {
		system.debug('Its case feed item trigger handler'+feedItems);
		List<Id> ids = new List<Id>();
		List<Id> caseIds = new List<Id>();
		for(FeedItem it: feedItems){
			ids.add(it.CreatedById);
			caseIds.add(it.ParentId);
		}
		List<Id> contactsIds = new List<Id>();
		List<String>contactNames = new List<String>();
		for(Contact c:  [SELECT Id, Name FROM Contact] ){
		contactsIds.add(c.Id);
			contactNames.add(c.Name);
		}
		List<User> users = [SELECT Id, Name, Username,ContactId FROM User WHERE ContactId IN: contactsIds];
		system.debug('users'+users);
		List<Case> casesList = [SELECT Id, Status, CreatedById FROM Case WHERE Id IN: caseIds];
		for(Case c: casesList){
			for(User u: users){
				for( String name: contactNames){
					if(name==u.Name){
						if( u.ContactId!=null){
							c.Status ='Pending Talis Task';
						}
						else{
							c.Status ='Pending Customer';
						}
					}
				}
				system.debug('Created by Id'+c.CreatedById);
				system.debug('User id'+u.Id+u.Name);
				if(c.CreatedById==u.Id){
				}
				else{
				}
			}
		}
		update casesList;
	}
}