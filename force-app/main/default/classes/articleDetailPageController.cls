public with sharing class articleDetailPageController {

    @AuraEnabled
    public static string getArticleByTitle(String UrlName){
        List<Knowledge__kav> art = [SELECT Id, Title, ArticleNumber, UrlName, Summary_RichText__c FROM Knowledge__kav Where UrlName=:UrlName];
        return JSON.serialize(art);
    }
    

}