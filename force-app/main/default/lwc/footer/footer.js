import { LightningElement } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';

import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';

export default class Footer extends LightningElement {

    LinkedInIcon = Images_Icons + '/LinkedInPNG.png'
    FooterDots = Images_Icons + '/FooterDots.png'

    currentYear = new Date().getFullYear()

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

    
}