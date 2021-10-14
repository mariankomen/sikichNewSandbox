import { LightningElement, track } from 'lwc';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import { loadStyle } from 'lightning/platformResourceLoader';
import Id from '@salesforce/community/Id'

import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getRelatedArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedArticlesToTopic';
import getTopicInfo from '@salesforce/apex/KnowledgeArticleController.getTopicInfo';
import getSubtopicInfo from '@salesforce/apex/SubtopicsController.getSubtopicInfo';

export default class SoftwareUpdates extends LightningElement {

    @track O_header = Images_Icons + '/O_header.png'
    @track topicDetails = {}
    loadedAll = true
    @track relatedArticles = []
    renderedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        }).catch(error => {
                console.log(error.body.message);
            });
    }

    connectedCallback() {
        getSubtopicInfo({
            topicName: 'Software Update',
            communityId: Id
        }).then(res => {
            this.topicDetails = {
                id:  JSON.parse(res).id,
                title:  JSON.parse(res).name,
                imgUrl:  JSON.parse(res).images.coverImageUrl,
                desc:  JSON.parse(res).description
            }
            console.log(this.topicDetails)
        })
        
        
            getRelatedArticlesToTopic({
                NameOfTopic: 'Software Updates',
                lim: 5
            }).then(res => {
                this.relatedArticles = []
                let el = JSON.parse(res)
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
            }).catch(e => {
                console.error(e)
            })  

            
        
           
    }

    
    

    loadMore(){
        getRelatedArticlesToTopic({
            NameOfTopic: 'Software Updates',
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
                        url: 'https://buildcomm-talisbio.cs219.force.com/customersuccess/s/article/'+el[i].UrlName,
                    }
                ]
            }
            if(this.relatedArticles.length % 5 !== 0){
                this.loadedAll = false
            }
        }).catch(e => {
            console.error(e)
        })
    }
}