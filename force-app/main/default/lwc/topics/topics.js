import { LightningElement, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';

import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getCommunityNavigationalTopics from '@salesforce/apex/TopicsController.getCommunityNavigationalTopics'
import getRelatedListArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedListArticlesToTopic'

import Id from '@salesforce/community/Id'

export default class Topics extends LightningElement {
    IconDocument = Images_Icons + '/Icon-Document.png'
    IconHelp = Images_Icons + '/Icon-Help.png'
    IconTalis = Images_Icons + '/Icon-Talis.png'
    IconUses = Images_Icons + '/Icon-Use.png'
    IconVideo = Images_Icons + '/VideoIcon.png'
    IconSoftware = Images_Icons + '/SoftwareIcon.png'
    IconMarketing = Images_Icons + '/MarketingIcon.png'

    data = []
    topicsTitleList = []
    @track relatedArticles = []
    genData = []
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
            console.log(JSON.parse(res))
            let response = [...JSON.parse(res).managedTopics]
            for(let i = 0; i<response.length; i++){
                this.data = [
                    ...this.data,
                    {
                        id: response[i].id,
                        urlName: 'topic/'+response[i].topic.id,
                        title: response[i].topic.name,
                        img: response[i].topic.images.coverImageUrl
                    }
                ]
            }
            console.log(this.data)
            
            for(let i = 0; i<this.data.length; i++){
                this.topicsTitleList.push(this.data[i].title)
            }

            console.log(this.topicsTitleList)


            getRelatedListArticlesToTopic({
                NameOfTopic: this.topicsTitleList
            }).then(res => {
                console.log('TEST',res)
                let articles = res

                for(let i = 0; i<articles.length; i++){
                    let arr = []
                    for(let j = 0; j<articles[i].length; j++){
                        arr.push( {
                            Title: articles[i][j].Title,
                            UrlName: 'article/'+articles[i][j].UrlName,
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
                for(let i = 0; i<this.generalData.length; i++){
                    if(this.generalData[i].topicDetail.title == 'Software Updates'){
                        this.generalData[i].topicDetail.urlName = 'software-updates'
                    } else if(this.generalData[i].topicDetail.title == 'Marketing Materials'){
                        this.generalData[i].topicDetail.urlName = 'marketing-materials'
    
                    }
                }  
            })  
              
        })       
    }
}