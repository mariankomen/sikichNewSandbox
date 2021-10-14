import { LightningElement, api, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getCommunityNavigationalTopics from '@salesforce/apex/TopicsController.getCommunityNavigationalTopics'
import getTopicName from '@salesforce/apex/TopicsController.getTopicName'
import getRelatedListArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedListArticlesToTopic'

import Id from '@salesforce/community/Id'

export default class TopicDetailRightBar extends LightningElement {
    @api recordId;
    data = []
    topicsTitleList = []
    @track relatedArticles = []
    otherTopics = []
    @track generalData = []
    renderedCallback() {
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        })
            .catch(error => {
                console.log(error.body.message);
            });
    }
    connectedCallback(){
        getCommunityNavigationalTopics({
            communityId: Id
        }).then(res => {
            console.log("DSF", JSON.parse(res))
            let response = [...JSON.parse(res).managedTopics]
            for(let i = 0; i<response.length; i++){
                this.data = [
                    ...this.data,
                    {
                        id: response[i].id,
                        urlName: '/s/topic/'+response[i].topic.id ,
                        // urlName: response[i].topic.name !== 'Marketing Materials' :,
                        title: response[i].topic.name == 'News &amp; Events' ? 'News & Events' : response[i].topic.name,
                        img: response[i].topic.images.coverImageUrl
                    }
                ]
            }
            getTopicName({
                topicId: this.recordId
            }).then(res => {
                let currentTopicName = JSON.parse(res)[0].Name
                this.data = this.data.filter(el => el.title !== currentTopicName)
                for(let i = 0; i<this.data.length; i++){
                    if(this.data[i].title !== currentTopicName){
                        this.otherTopics.push(this.data[i].title)
                    }
                }


                getRelatedListArticlesToTopic({
                    NameOfTopic: this.otherTopics
                }).then(res => {
                    let articles = res

                    for(let i = 0; i<articles.length; i++){
                        let arr = []
                        for(let j = 0; j<articles[i].length; j++){
                            arr.push( {
                                Title: articles[i][j].Title,
                                UrlName: '/s/article/'+articles[i][j].UrlName,
                                Id: articles[i][j].Id,
                                KnowledgeArticleId: articles[i][j].KnowledgeArticleId
                                
                            })
                        }
                        this.relatedArticles.push(arr)
                    }

                    for(let j = 0; j<this.data.length; j++){
                        this.generalData.push(
                            {
                                topicDetail: this.data[j],
                                articleDetail: this.relatedArticles[j] !== undefined ? this.relatedArticles[j] : null
                            }) 
                    }
                    console.log('GEN: ', this.generalData)
                    
                })
            })
            console.log('TOPICS: ',this.otherTopics)
            
            
        })


        
    }
}