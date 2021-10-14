import { LightningElement, track, wire } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { NavigationMixin } from 'lightning/navigation';
import getListCases from '@salesforce/apex/CasesController.getListCases'
import getListViewTitles from '@salesforce/apex/CasesController.getListViewTitles'
import getCaseDeflactionArticles from '@salesforce/apex/KnowledgeArticleController.getCaseDeflactionArticles'

import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';

export default class CaseListViews extends LightningElement {

    ArrowIcon = Images_Icons + '/Arrow.png'
    pickListOptions = []
    pickListDefault = ''
    bigTitle = 'All Open Cases'
    @track data = []
    @track caseDeflactionArticles = []

    ID = '';


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

    convertDate(inputFormat) {
        if(inputFormat){
            let k = inputFormat.split('-').reverse()
            return k[0].slice(0,2)+'/'+k[1]+'/'+k[2]
        } else return null

    }

    connectedCallback() {
        /* Get ListView titles of Case Object */
        getListViewTitles().then(res => {
            JSON.parse(res).forEach(el => {
                this.pickListOptions = [
                    ...this.pickListOptions,
                    {
                        label: el.Name,
                        value: el.Id
                    }
                ]

            })
            this.bigTitle = this.pickListOptions[0].label
            /* Get ListViews records from first ListView of custom setting*/
            getListCases({ ListViewID: this.pickListOptions[0].value }).then(res => {
                let returnedData = JSON.parse(res)
                for(let i = 0; i<returnedData.length; i++){
                    this.data = [
                        ...this.data,
                        {
                            Id: returnedData[i].Id,
                            Subject: returnedData[i].Subject,
                            CaseNumber: returnedData[i].CaseNumber,
                            Date_Time_Opened__c: this.convertDate(returnedData[i].CreatedDate),
                            External_Status__c: returnedData[i].External_Status__c,
                            redUrl: 'case/'+returnedData[i].Id
                        }
                    ];
                }

                // this.data = [...JSON.parse(res)]
            }).catch(e => {
                console.error(e)
            })
        })

        getCaseDeflactionArticles().then(res => {
            for(let i = 0; i<JSON.parse(res)[0].length; i++){
                this.caseDeflactionArticles = [
                    ...this.caseDeflactionArticles,
                    {
                        Title: JSON.parse(res)[0][i].Title,
                        UrlName: 'article/'+JSON.parse(res)[0][i].UrlName,
                        Id: JSON.parse(res)[0][i].Id
                    }
                ]
            }
        })



    }

    handlePicklistChange(e) {
        this.data = []
        getListCases({ ListViewID: e.target.value }).then(res => {
            // this.data = [...JSON.parse(res)]
            let returnedData = JSON.parse(res)
            console.log("RE:", returnedData)
            for(let i = 0; i<returnedData.length; i++){
                this.data = [
                    ...this.data,
                    {
                        Id: returnedData[i].Id,
                        Subject: returnedData[i].Subject,
                        CaseNumber: returnedData[i].CaseNumber,
                        Date_Time_Opened__c: this.convertDate(returnedData[i].CreatedDate),
                        External_Status__c: returnedData[i].External_Status__c,
                        redUrl: 'case/'+returnedData[i].Id

                    }
                ];
            }
            console.log("THISDATA:", this.data)
        }).catch(e => {
            console.error(e)
        })
        const index = this.pickListOptions.map(e => e.value).indexOf(e.target.value);
        /*
           Cutting first useless str of ListViewTitles
           For ex: if in picklist value is equal 2 - All Open Cases then our bigtitle will be equal 'All Open Cases' without '2 - '
        */
        this.pickListOptions[index].label.slice(0, 8).includes(' - ') ? this.bigTitle = this.pickListOptions[index].label.substring(4)
            : this.bigTitle = this.pickListOptions[index].label


    }


}