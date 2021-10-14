import { LightningElement, track, api } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityStyle from '@salesforce/resourceUrl/communityStyle';

import getArticleByTitle from '@salesforce/apex/articleDetailPageController.getArticleByTitle';
import voteArticle from '@salesforce/apex/KnowledgeArticleController.voteArticle';
import getVotedResult from '@salesforce/apex/KnowledgeArticleController.getVotedResult';
import getCategoryOfArticle from '@salesforce/apex/KnowledgeArticleController.getCategoryOfArticle';

export default class ArticleDetailPage extends LightningElement {
    @api recordId;
    data;
    urlNameOfArticle= ' ';
    styleYesVoted = 'ADP_helpful_item'
    styleNoVoted = 'ADP_helpful_item'
    votedBeforeResult;
    categoryTags = []

    renderedCallback() {
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        }).catch(error => {
            console.log(error.body.message);
        });
    }
    connectedCallback() {
        let articleUrlName = window.location.href.split('/article/')[1];
        this.urlNameOfArticle = articleUrlName
        console.log(articleUrlName)
        getArticleByTitle({ UrlName: articleUrlName }).then((response) => {
            JSON.parse(response).forEach((el) => {
                this.data = [{
                    Id: el.Id,
                    Title: el.Title,
                    Summary: el.Summary_RichText__c,
                    UrlName: el.UrlName
                }]

                this.urlNameOfArticle = el.UrlName
            })
            
        }).catch(error => {
            console.error(error)
        })
        // console.log(this.urlNameOfArticle)
        getVotedResult({articleURL: articleUrlName}).then(res => {
            console.log(JSON.parse(res))
            this.votedBeforeResult = JSON.parse(res);
            if(JSON.parse(res) == '5'){
                this.styleYesVoted = "ADP_helpful_item voted"
            } else if(JSON.parse(res) == '1'){
                this.styleNoVoted = "ADP_helpful_item voted"
            }
        }).catch(error => {
            console.error(error)
        })

        getCategoryOfArticle({ArticleUrlName: this.urlNameOfArticle}).then(res => {
            console.log(JSON.parse(res))
            for(let i = 0; i<JSON.parse(res).length; i++){
                this.categoryTags.push(JSON.parse(res)[i].DataCategoryName.split('_').join(' '))
            }

            console.log(this.categoryTags)
            
        })

        
        // this.urlNameOfArticle = location.href.slice(url.indexOf('e/')+2)
    }
    voteYes(){
        if(this.votedBeforeResult == '5'){
            const event = new ShowToastEvent({
                title: 'Error during voting',
                message: 'You selected "Yes" before, please select another one.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        } else {
            this.styleYesVoted = "ADP_helpful_item voted"
            this.styleNoVoted = "ADP_helpful_item"
            voteArticle({
                articleURL: this.urlNameOfArticle,
                VoteType: '5'
            })
            this.votedBeforeResult = '5'
        }
        
    }

    voteNo(){
        if(this.votedBeforeResult == '1'){
            const event = new ShowToastEvent({
                title: 'Error during voting',
                message: 'You selected "No" before, please select another one.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        } else {
            this.styleNoVoted = "ADP_helpful_item voted"
            this.styleYesVoted = "ADP_helpful_item"
            voteArticle({
                articleURL: this.urlNameOfArticle,
                VoteType: '1'
            })
            this.votedBeforeResult = '1'
        }
        
    }

}