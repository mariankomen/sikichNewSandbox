import { LightningElement, api, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';

import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getRelatedArticlesToTopic from '@salesforce/apex/KnowledgeArticleController.getRelatedArticlesToTopic'



export default class RightbarForSoftMark extends LightningElement {

    @api topicTitle;
    topics = ["Software Updates", "Marketing Materials"]

    @track data = []
    connectedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        }).catch(error => {
                console.log(error.body.message);
            });

        for(let i = 0; i<this.topics.length; i++){
            if(this.topics[i] !== this.topicTitle){
                getRelatedArticlesToTopic({
                    NameOfTopic: this.topics[i],
                    lim: 5
                }).then(res => {
                    let articles = []
                    articles = []
                    console.log(JSON.parse(res))
                    for(let i = 0; i<JSON.parse(res).length; i++){
                            articles.push(JSON.parse(res)[i])
                            articles[i].UrlName = '/s/article/'+JSON.parse(res)[i].UrlName

                    }
                    console.log("ARTICLES:",articles)
                    
                    let obj = {
                        title: this.topics[i],
                        url: this.topics[i] == "Marketing Materials" ? 'marketing-materials' :  this.topics[i] == "Software Updates" ? "software-updates" : this.topics[i] == "How To Videos" ? "How To Videos" : null,
                        articles: [...articles]
                    }
                    this.data.push(obj)
                    //console.log(this.topics[i] , ' ' , JSON.parse(res))
                }).catch(e => {
                    console.error(e)
                })
            }

            
        }    
        
        
        console.log(this.data)
        console.log(this.topicTitle)
    }
}