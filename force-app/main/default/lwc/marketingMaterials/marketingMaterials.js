import { LightningElement, track } from 'lwc';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import { loadStyle } from 'lightning/platformResourceLoader';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getRelatedArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedArticlesToTopic';
import getTopicInfo from '@salesforce/apex/KnowledgeArticleController.getTopicInfo';
import Id from '@salesforce/community/Id'
import getSubtopicInfo from '@salesforce/apex/SubtopicsController.getSubtopicInfo';

export default class SoftwareUpdates extends LightningElement {

    @track O_header = ''
    loadedAll = true
    relatedArticles = []
    topicDetails = {}
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
            topicName: 'Marketing Material',
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
            NameOfTopic: 'Marketing Materials',
            lim: 5
        }).then(res => {
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
            this.relatedArticles.length < 5 ? this.loadedAll = false : this.loadedAll = true
        })
        

        
    }

    loadMore(){
        getRelatedArticlesToTopic({
            NameOfTopic: 'Marketing Materials',
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
            if(this.relatedArticles.length % 5 !== 0){
                this.loadedAll = false
            }
        }).catch(e => {
            console.error(e)
        })
    }
}