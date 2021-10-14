import { LightningElement } from 'lwc';
import getRecordDetail from "@salesforce/apex/CaseRecordController.getRecordDetail"
import getTopicName from "@salesforce/apex/TopicsController.getTopicName"
import getArticleByTitle from "@salesforce/apex/articleDetailPageController.getArticleByTitle"


export default class SubheaderWithNaviBar extends LightningElement {


    iterData = []
    url = window.location.href

    connectedCallback(){
        console.log('PREVURL: ',document.referrer)
        if(this.url.includes('/s/case/')){
            let recId = this.url.slice(this.url.indexOf('/case/')+6,this.url.indexOf('/case/')+24)
            getRecordDetail({
                recId: recId
            }).then(res => {
                console.log('STATUS: ',res)
                this.iterData = [
                    {
                        key: res.External_Status__c == 'Closed' ? 'My Closed Cases' : 'My Open Cases',
                        url: '/s/case-list-views'
                    },
                    {
                        key: ' > ' + res.CaseNumber
                    }
                ];
            })
        } else if(this.url.includes('/s/topic/')){
            let recId = this.url.slice(this.url.indexOf('/topic/')+7,this.url.indexOf('/topic/')+25)
            getTopicName({
                topicId: recId
            }).then(res => {
                this.iterData = [
                    {
                        key: 'Topics',
                        url: '/s/topics-page'
                    },
                    {
                        key: ' > ' + JSON.parse(res)[0].Name,
                        
                    }
                ];
            })
        } else if(this.url.includes('/s/article/')){
            let articleUrlName = this.url.split('/article/')[1]
            getArticleByTitle({
                UrlName: articleUrlName
            }).then(res => {
                console.log("ASDASDASDASDASD", JSON.parse(res));
                this.iterData = [
                    {
                        key: 'Topics',
                        url: '/s/topics-page'
                    },
                    {
                        key: ' > ' + 'Article'
                    },
                    {
                        key: ' > ' + JSON.parse(res)[0].Title
                    }
                ];
            })
        }
    }
}