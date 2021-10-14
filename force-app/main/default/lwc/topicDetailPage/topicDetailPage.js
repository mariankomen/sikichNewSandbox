import { LightningElement, api, track } from 'lwc';
import Id from '@salesforce/community/Id'
import { loadStyle } from 'lightning/platformResourceLoader';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getRelatedArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedArticlesToTopic';

import getCurrentTopic from '@salesforce/apex/TopicsController.getCurrentTopic'

export default class TopicDetailPage extends LightningElement {
    @api recordId;
    @track relatedArticles = []
    @track data = {}
    loadedAll = true
    connectedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        }).catch(error => {
                console.log(error.body.message);
        });

        console.log('COM:', Id)
        console.log('RC:', this.recordId)
        getCurrentTopic({
            communityId: Id,
            topicId: this.recordId
        }).then(res => {
            console.log(JSON.parse(res))
           this.data = {
                name: JSON.parse(res).name == 'News &amp; Events' ? 'News & Events' : JSON.parse(res).name,
                description: JSON.parse(res).description,
                img: JSON.parse(res).images.coverImageUrl
                
           }

           getRelatedArticlesToTopic({
                NameOfTopic: this.data.name,
                lim: 5
            }).then(res => {
                let el = JSON.parse(res)
                for(let i = 0; i< JSON.parse(res).length; i++){
                    this.relatedArticles = [
                        ...this.relatedArticles,
                        {
                            id: el[i].Id,
                            title: el[i].Title,
                            url: '/s/article/'+el[i].UrlName,
                        }
                    ]
                }
                JSON.parse(res).length < 5 ? this.loadedAll = false : this.loadedAll = true
            }).catch(e => {
                console.error(e)
            }) 
        })

        
        
    }

    loadMore(){
        getRelatedArticlesToTopic({
            NameOfTopic: this.data.name,
            lim: this.relatedArticles.length + 5
        }).then(res => {
            let el = JSON.parse(res)
            this.relatedArticles = []
            for(let i = 0; i< JSON.parse(res).length; i++){
                this.relatedArticles = [
                    ...this.relatedArticles,
                    {
                        id: el[i].Id,
                        title: el[i].Title,
                        url: 'article/'+el[i].UrlName,
                    }
                ]
            }
            if(this.relatedArticles.length % 5 !== 0  ){
                this.loadedAll = false
            }
        }).catch(e => {
            console.error(e)
        })
    }

}