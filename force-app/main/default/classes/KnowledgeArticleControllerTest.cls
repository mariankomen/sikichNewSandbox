@isTest
public with sharing class KnowledgeArticleControllerTest {
    
    @isTest
    public static void getRelatedArticlesTest(){
        
        Topic top = new Topic(Name='TestTopic: ' + Datetime.now().format('yyyy-MM-dd'));
        insert top;
        List<TopicAssignment> topicGotten = KnowledgeArticleController.getRelatedArticles(top.Name);
        System.assertNotEquals(1, topicGotten.size());
    }

    @isTest
    public static void getMostViewedArticlesTest(){
        Knowledge__kav ka = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'uniqsdfgUrl1');
        insert ka;
        // KbManagement.PublishingService.publishArticle(ka.KnowledgeArticleId, true);
        //KnowledgeArticleVersion knowId = [SELECT Id, KnowledgeArticleId, UrlName, Title FROM KnowledgeArticleVersion WHERE KnowledgeArticleId=:ka.Id];
        //KbManagement.PublishingService.publishArticle(knowId.Id, true);
        List<Knowledge__kav> lArt = KnowledgeArticleController.getMostViewedArticles();
        //System.assertNotEquals(1, lArt.size());
        
    }
    @isTest
    public static void voteArticleTest(){
        Knowledge__kav ka = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'salesfsorce-crm');
        insert ka;
        KnowledgeArticleController.voteArticle(ka.UrlName, '5');
        String votResult = KnowledgeArticleController.getVotedResult(ka.UrlName);
        System.assertNotEquals(null, votResult);
    }

    @isTest
    public static void getMostVotedArticleTest(){
        Knowledge__kav knowKAV = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'salesgasdfaforce-crm');
        insert knowKAV;
        Id articleKa = [select id  from Knowledge__ka  LIMIT 1].Id;
		List<Vote> vot = [SELECT Id, ParentId, Type FROM Vote Where ParentId=:articleKa];
		delete vot;
        Vote gol = new Vote(ParentId=articleKa, Type='5');
        insert gol;
        String mostVoted = KnowledgeArticleController.getMostVotedArticle();
        System.assertNotEquals(null, mostVoted);
    }

    @isTest
    public static void getCategoryOfArticleTest(){
        Knowledge__kav knowKAV = new Knowledge__kav(Title = 'Salesforce CRM', UrlName = 'salesgaDDsdfaforce-crm');
        insert knowKAV;
        String category = KnowledgeArticleController.getCategoryOfArticle(knowKav.UrlName);
        System.assertNotEquals(null, category);

    }
    @isTest
    public static void getTopicInfoTest(){
        Topic top = new Topic(Name='TestTopic: ' + Datetime.now().format('yyyy-MM-dd'));
        insert top;
        String topicInfo = KnowledgeArticleController.getTopicInfo(top.Name);
        System.assertNotEquals(null, topicInfo);
    }
    @isTest
    public static void getRelatedArticlesToTopicTest(){
        Topic top = new Topic(Name='TestTopicС: ' + Datetime.now().format('yyyy-MM-dd'));
        insert top;
        String topicInfo = KnowledgeArticleController.getRelatedArticlesToTopic(top.Name, 5);
        System.assertNotEquals(null, topicInfo);
    }
    @isTest
    public static void getRelatedListArticlesToTopicTest(){
        Topic top = new Topic(Name='TestTopicС: ' + Datetime.now().format('yyyy-MM-dd'));
        List<String> topicsNames = new List<String>();
        topicsNames.add(top.Name);
        insert top;
        List<List<KnowledgeArticleVersion>> topicInfo = KnowledgeArticleController.getRelatedListArticlesToTopic(topicsNames);
        System.assertEquals(1, topicInfo.size());
    }

}