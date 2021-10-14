trigger CaseChatterTrigger on FeedItem (after insert) {

	if(String.valueOf(Trigger.new.get(0).ParentId.getSobjectType())=='Case'){

		CaseFeedItemTriggerHandler caseFeedItemTriggerHandler = new CaseFeedItemTriggerHandler(Trigger.new);
	}

}