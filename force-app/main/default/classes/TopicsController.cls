public with sharing class TopicsController {
    
    @AuraEnabled
    public static string getCommunityNavigationalTopics(String communityId){
        return JSON.serialize(ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational));
    }
    
    @AuraEnabled
    public static string getCommunityNavigationalTopicsForHomePage(String communityId){
        ConnectAPI.ManagedTopicCollection k = ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational);
        HomePageTopics__c mcs = HomePageTopics__c.getValues('titles');
        List<String> topicsLabel = mcs.topicsTitles__c.split(',');
        List <Map<String, String>> topicInfo = new List <Map<String, String>>();

        for(Integer i = 0; i<k.managedTopics.size(); i++){
            for(Integer j = 0; j<topicsLabel.size(); j++){
                if(k.managedTopics[i].topic.name == topicsLabel[j]){
                    topicInfo.add(new Map<String, String>{'id'   => k.managedTopics[i].id,
                                                  'name' => k.managedTopics[i].topic.name,
                                                  'img'  => k.managedTopics[i].topic.images.coverImageUrl,
                                                  'url'  =>'topic/'+k.managedTopics[i].topic.id});
                }
            } 
        }
        return JSON.serialize(topicInfo);
    }

    @AuraEnabled
    public static string getCommunityNavigationalTopicsSSSS(String communityId){
        
        ConnectAPI.ManagedTopicCollection navTopics = ConnectAPI.ManagedTopics.getManagedTopics(communityId, ConnectApi.ManagedTopicType.Navigational);
        List <Map<String, String>> topics = new List <Map<String, String>>();
        List<String> topicsTitles = new List<String>();
        List<String> topicsIds = new List<String>();
        for(Integer i = 0; i<navTopics.managedTopics.size(); i++){
            topics.add(new Map<String, String>{    'id'   => navTopics.managedTopics[i].id,
                                                  'name' => navTopics.managedTopics[i].topic.name,
                                                  'img'  => navTopics.managedTopics[i].topic.images.coverImageUrl,
                                                  'url'  =>'topic/'+navTopics.managedTopics[i].topic.id});
                                    }
        for(Map<String, String> i :topics){
                topicsTitles.add(String.valueOf(i.get('name')));
                topicsIds.add(String.valueOf(i.get('id')));
        }
        List<List<KnowledgeArticleVersion>> art = KnowledgeArticleController.getRelatedListArticlesToTopic(topicsTitles);
        List<List <Map<String, String>>> sortedArt = new List<List <Map<String, String>>>();
        System.debug(JSON.serialize(art));


        // for(Integer i = 0; i<art.size(); i++){
        //     List <Map<String, String>> articleItem = new List<Map<String, String>>();
        //     for(Integer j = 0; j<art[i].size(); j++){
        //         articleItem.add(new Map<String, String>{
        //             'Title' => art[i][j].Title,
        //             'UrlName' => 'article/'+art[i][j].UrlName,
        //             'Id' => art[i][j].Id,
        //             'KnowledgeArticleId' => art[i][j].KnowledgeArticleId
        //         });  
        //     }
        //     sortedArt.add(articleItem);
        // }
        // Map<String, Object> te = new Map<String, Object>{'topicDetail' => topics, 'articleDetail' => sortedArt};      
        return JSON.serialize(art);        
    }

    @AuraEnabled
    public static String getCurrentTopic(String communityId, String topicId){
        return JSON.serialize(ConnectApi.Topics.getTopic(communityId, topicId));
    }
    

    @AuraEnabled
    public static string getTopicName(String topicId){
        return JSON.serialize([SELECT Id, Name FROM Topic WHERE Id =: topicId LIMIT 1]);
    }

    
}