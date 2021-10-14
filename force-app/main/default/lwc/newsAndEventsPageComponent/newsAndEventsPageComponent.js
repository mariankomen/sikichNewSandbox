import {LightningElement, api, track} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';

export default class NewsAndEventsPageComponent extends LightningElement {
    Header = Images_Icons+'/O_header.png';
    IconVideo = Images_Icons + '/VideoIcon.png';
    IconSoftware = Images_Icons + '/SoftwareIcon.png';
    IconMarketing = Images_Icons + '/MarketingIcon.png';
    bigTitle ='News & EVENTS';

    connectedCallback(){
        Promise.all([
            loadStyle(this, communityStyle)
        ]).then(() => {
            console.log('Static resources loaded');
        })
            .catch(error => {
                console.log(error.body.message);
            });
    }
}