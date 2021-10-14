import {LightningElement, api, track} from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';

export default class AdsComponent extends LightningElement {
@api value;
    adIcon;
    connectedCallback() {

    }
}