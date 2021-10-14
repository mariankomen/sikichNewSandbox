@isTest
public with sharing class TopicsControllerTest {
    
    @isTest(SeeAllData=true)
    public static void getCommunityNavigationalTopicsTest(){
        String communityId;
        String topicName ='Test topic';
        String topicId='123456789';
        try{
            communityId = [Select Id from Network where Name = 'Customer Success' LIMIT 1].Id;
        } catch(Exception e){
            communityId='123456789';
        }
        ConnectApi.ManagedTopics.createManagedTopicByName(communityId,TopicName, ConnectApi.ManagedTopicType.Navigational);
        String managedTopics = TopicsController.getCommunityNavigationalTopics(communityId);
        String manTop = TopicsController.getCommunityNavigationalTopicsForHomePage(communityId);
        String manTopp = TopicsController.getCommunityNavigationalTopicsSSSS(communityId);
        
        System.assertNotEquals(null, managedTopics);
        System.assertNotEquals(null, manTop);
        System.assertNotEquals(null, manTopp);
        // Test For SubtopicController, method getSubtopicInfo
        String sub = SubtopicsController.getSubtopicInfo(topicName,communityId);
        System.assertNotEquals(null, sub);
      }

      @isTest(SeeAllData=true)
      public static void getCurrentTopicTest(){
        String communityId;
        Topic topic = new Topic(Name='TestTopic: ' + Datetime.now().format('yyyy-MM-dd'));
        insert topic;  
        communityId = [Select Id from Network where Name = 'Customer Success' LIMIT 1].Id;
        ConnectApi.ManagedTopics.createManagedTopicByName(communityId,topic.Name, ConnectApi.ManagedTopicType.Navigational);
        //String topicInfo = TopicsController.getCurrentTopic(communityId, topic.Id);
        String currentTopic = TopicsController.getTopicName(topic.Id);
        //System.assertNotEquals(null, topicInfo);
        System.assertNotEquals(null, currentTopic);

      }
}