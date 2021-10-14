import {LightningElement, api, track} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getImage from '@salesforce/apex/DynamicAdsController.getImage';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import getDetails from '@salesforce/apex/DynamicAdsController.getDetails';

export default class DynamicAdsComponent extends LightningElement {
    @api value;
    image ='data:image/jpeg;base64,';
    AD_image = Images_Icons + '/Ad_img.png'
    ArrowIcon = Images_Icons + '/Arrow.png'
    ColorBar = Images_Icons + '/colorbar.png'
    knowlege;
    title='';
    subtitle='';
    link=''
    enabled=true;
    connectedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Static resources loaded');
        })
            .catch(error => {
                console.log(error.body.message);
            });
        getImage({recId: this.value}).then(result=>{
            this.image+= result;
        });
        getDetails({recId: this.value}).then(result=>{
            if(result.Ad_Enabled__c==true){

                this.knowlege= JSON.parse(JSON.stringify(result));
                this.title = this.knowlege.Ad__c;
                this.subtitle = this.knowlege.Ad_Description__c;
                this.link = this.knowlege.Ad_Link__c;
            }
            else {
                this.enabled = false;
            }

        });


    }

}