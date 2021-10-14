import { LightningElement, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from "lightning/navigation";
import getMostViewedArticles from '@salesforce/apex/KnowledgeArticleController.getMostViewedArticles'
import getMostVotedArticle from '@salesforce/apex/KnowledgeArticleController.getMostVotedArticle'
import getMostViewedArticlesForHomePage from '@salesforce/apex/KnowledgeArticleController.getMostViewedArticlesForHomePage'
import getFeaturedArticlesForHomePage from '@salesforce/apex/KnowledgeArticleController.getFeaturedArticlesForHomePage'
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import getCommunityNavigationalTopicsForHomePage from '@salesforce/apex/TopicsController.getCommunityNavigationalTopicsForHomePage'

import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import Id from '@salesforce/community/Id'

export default class HomePage extends NavigationMixin(LightningElement) {

    Dots = Images_Icons + '/Dots.png'
    Top_Right_Img = Images_Icons + '/img-customer-support1.png'
    SearchIcon = Images_Icons + '/Search.png'
    ColorBar = Images_Icons + '/colorbar.png'
    IconDocument = Images_Icons + '/Icon-Document.png'
    IconHelp = Images_Icons + '/Icon-Help.png'
    IconTalis = Images_Icons + '/Icon-Talis.png'
    IconUses = Images_Icons + '/Icon-Use.png'

    navBlocks = []
    @track articles_data = [];
    inputValue = '';
    @track featureArticle = {}

    
    connectedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Files loaded');
        }).catch(error => {
                console.log(error.body.message);
            }); 

            getFeaturedArticlesForHomePage().then(response => {
                let res = JSON.parse(response)
                this.featureArticle = {
                    Id: res.Id,
                    Title: res.Title,
                    UrlName: res.UrlName,
                    url: 'article/'+res.UrlName
                }
            })
        getCommunityNavigationalTopicsForHomePage({
            communityId: Id
        }).then(res => {
            this.navBlocks = JSON.parse(res);
        }).catch(e => {
            console.error(e)
        })


        getMostViewedArticlesForHomePage().then(response => {
            let res = JSON.parse(response)
            for(let i = 0; i<res.length; i++){
                this.articles_data.push(
                    {
                        Id: res[i].Id,
                        Title: res[i].Title,
                        UrlName: res[i].UrlName,
                        url: 'article/'+res[i].UrlName
                    })
                
            }
        })
    }
    clickRed() {
        window.open('https://buildcomm-talisbio.cs219.force.com/customersuccess/s/article?urlName=testArticle')
    }

    searchSubmit(){
        window.open('global-search/'+this.inputValue)
    }

    handleInputChange(e){
        if(e.keyCode == 13){
            this.searchSubmit()
            this.inputValue = ''
        } else {
            this.inputValue = e.target.value
        }
    }

}