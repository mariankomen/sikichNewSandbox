public with sharing class SubtopicsController {
    
    @AuraEnabled
    public static string getSubtopicInfo(String topicName, String communityId){
        Topic top = [SELECT Id, NetworkId, Name FROM Topic Where Name=:topicName LIMIT 1];
        return TopicsController.getCurrentTopic(communityId, top.Id);
    }
}