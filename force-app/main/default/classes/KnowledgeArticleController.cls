public without sharing class KnowledgeArticleController {
    
    @AuraEnabled
    public static List<TopicAssignment> getRelatedArticles(String TopicName){
        List<String> displayedTopic = new List<String>();
        displayedTopic.add(TopicName);
        List<TopicAssignment> top = [SELECT Id, TopicId, Topic.Name, EntityId FROM TopicAssignment WHERE Topic.Name NOT IN: displayedTopic];
        return top;
    }

    @AuraEnabled
    public static List<Knowledge__kav> getMostViewedArticles(){
        List<Knowledge__ka> parentArticle = [SELECT Id, ArticleNumber, TotalViewCount FROM Knowledge__ka ORDER BY TotalViewCount DESC LIMIT 5];
        // List<Knowledge__kav> articl = [SELECT Id, Title, UrlName FROM Knowledge__kav WHERE KnowledgeArticleId IN: parentArticle LIMIT 5];
        List<Knowledge__kav> articl = [SELECT Id, Title, UrlName FROM Knowledge__kav WHERE KnowledgeArticleId IN: parentArticle AND PublishStatus='Online'];
        return articl;
    }

    @AuraEnabled
    public static void voteArticle(String articleURL, String VoteType){
        Knowledge__kav allArticles = [SELECT Id, KnowledgeArticleId, UrlName FROM Knowledge__kav WHERE UrlName=:articleURL LIMIT 1];
        List<Vote> vot = [SELECT Id, ParentId, Type FROM Vote Where ParentId=:allArticles.KnowledgeArticleId AND CreatedById=:userinfo.getUserId()];

        if(vot.size() == 0){
            Vote v = new Vote();
            v.ParentId = allArticles.KnowledgeArticleId; 
            v.Type = VoteType;
            insert v;
            
        } else {
            vot[0].Type = VoteType;
            update vot;
        }
    }

    @AuraEnabled
    public static string getVotedResult(String articleURL){
        Knowledge__kav allArticles = [SELECT Id, KnowledgeArticleId, UrlName FROM Knowledge__kav WHERE UrlName=:articleURL LIMIT 1];
        List<Vote> vot = [SELECT Id, ParentId, Type FROM Vote Where ParentId=:allArticles.KnowledgeArticleId AND CreatedById=:userinfo.getUserId()];
        if(vot.size() > 0){
            return JSON.serialize(vot[0].Type);
        } else{
            return JSON.serialize('0');
        }
    }
    @AuraEnabled
    public static string getMostVotedArticle(){
        Integer k = 0;
        List<Knowledge__kav> allArticles = [SELECT Id, KnowledgeArticleId, UrlName FROM Knowledge__kav];
        String mostLikedArticleId = '';
		Set<Id> ids = new Set<Id>();
        for(Knowledge__kav i: allArticles){
            ids.add(i.KnowledgeArticleId);
        }
		List<Vote> votes = [SELECT Id, ParentId FROM Vote WHERE Type='5' AND ParentId IN: ids AND Parent.Type='Knowledge__ka'];
		Map<Id, Integer> mostLikedArticleCollection = new Map<Id, Integer>();
        for(Vote i:votes){
            if(mostLikedArticleCollection.containsKey(i.ParentId)){
                mostLikedArticleCollection.put(i.ParentId, mostLikedArticleCollection.get(i.ParentId)+1);
            } else {
                mostLikedArticleCollection.put(i.ParentId, 1);
            }
        }
        for(Id i:mostLikedArticleCollection.keySet()){
            if(mostLikedArticleCollection.get(i) > k){
                k = mostLikedArticleCollection.get(i);
                mostLikedArticleId=String.valueOf(i);
            }
        }
        Knowledge__kav mostLikedArticle = [SELECT Id, KnowledgeArticleId, UrlName, Title FROM Knowledge__kav WHERE KnowledgeArticleId=:mostLikedArticleId LIMIT 1];
        return JSON.serialize(mostLikedArticle);
        // return JSON.serialize([SELECT Id, KnowledgeArticleId, UrlName, Title FROM Knowledge__kav WHERE KnowledgeArticleId=:mostLikedArticleId LIMIT 1]);
    }

    @AuraEnabled
    public static string getCategoryOfArticle(String ArticleUrlName){
        Knowledge__kav art = [SELECT Id FROM Knowledge__kav WHERE UrlName=:ArticleUrlName LIMIT 1];
        return JSON.serialize([SELECT Id, DataCategoryName FROM Knowledge__DataCategorySelection WHERE ParentId=:art.Id]);
    }

    @AuraEnabled
    public static string getTopicInfo(String TopicTitle){
        Topic t = [SELECT Id, Name, Description FROM Topic WHERE Name=:TopicTitle];
        return JSON.serialize(t);
    }

    @AuraEnabled
    public static string getRelatedArticlesToTopic(String NameOfTopic, Integer lim){
        Topic t = [SELECT Id, Name FROM Topic WHERE Name=: NameOfTopic LIMIT 1];
        List<KnowledgeArticleVersion> relatedArt = [SELECT Title, ArticleNumber, UrlName, Id,  KnowledgeArticleId  FROM  KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Id in (SELECT EntityId FROM TopicAssignment WHERE TopicId =: t.Id ) LIMIT :lim];
        return JSON.serialize(relatedArt);
    }
    @AuraEnabled
    public static List<List<KnowledgeArticleVersion>> getRelatedListArticlesToTopic(List<String> NameOfTopic){
        List<String> tId = new List<String>();
        for(Integer i = 0; i<NameOfTopic.size(); i++){
            //System.debug([SELECT Id, Name FROM Topic WHERE Name =: NameOfTopic[i]].Id);
            tId.add([SELECT Id, Name FROM Topic WHERE Name =: NameOfTopic[i]].Id);
        }

        List<List<KnowledgeArticleVersion>> rA = new List<List<KnowledgeArticleVersion>>();
		for(String i: tId){
            rA.add([SELECT Title, UrlName, Id,  KnowledgeArticleId  FROM  KnowledgeArticleVersion WHERE PublishStatus = 'Online' AND Id in (SELECT EntityId FROM TopicAssignment WHERE TopicId =: i ) LIMIT 5]);
        }

        return rA;
    }
    @AuraEnabled
    public static string getMostViewedArticlesForHomePage(){
        homePageArticles__c mostViewed = homePageArticles__c.getValues('mostViewedArticles');
        List<String> mostViewedArticleTitles = mostViewed.listArticles__c.split(',');
        List<Knowledge__kav> mostViewedData = [SELECT Id, Title, UrlName FROM Knowledge__kav WHERE Title IN: mostViewedArticleTitles AND PublishStatus='Online' LIMIT 5];
        return JSON.serialize(mostViewedData);
    }

    @AuraEnabled
    public static string getFeaturedArticlesForHomePage(){
        homePageArticles__c mostViewed = homePageArticles__c.getValues('FeaturedArticle');
        List<String> mostViewedArticleTitles = mostViewed.listArticles__c.split(',');
        Knowledge__kav mostViewedData = [SELECT Id, Title, UrlName FROM Knowledge__kav WHERE Title =: mostViewedArticleTitles[0] AND PublishStatus='Online' LIMIT 1];
        return JSON.serialize(mostViewedData);
    }

    @AuraEnabled
    public static string getCaseDeflactionArticles(){
        List<String> listCaseDeflTopic = CaseDeflectionTopic__c.getValues('title').topicName__c.split(',');
        return JSON.serialize(getRelatedListArticlesToTopic(new List<String>{listCaseDeflTopic[0]}));
    }
}