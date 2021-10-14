import { LightningElement, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import communityStyle from '@salesforce/resourceUrl/communityStyle';
import Images_Icons from '@salesforce/resourceUrl/Images_Icons';
import getCreateCasePicklistValue from '@salesforce/apex/CasesController.getCreateCasePicklistValue';
import createInquiryCase from '@salesforce/apex/CasesController.createInquiryCase';
import getUploadedFiles from '@salesforce/apex/ContentDocumentLinkController.getUploadedFiles';

const columns = [
    { label: 'Label', fieldName: 'Title' }
];
export default class CreateCasePage extends LightningElement {
    CaseIcon = Images_Icons + '/CaseItem.png'
    //pickListOptions = []
    //@track PicklistValue;
    @track InputNameValue;
    @track InputEmailValue;
    @track InputOrganizationValue;
    @track InputMessageValue;
    @track InputSerialNumberValue;
    filesIDs;
    columns = columns;
    data = []
    areUploadedFiles = false

    get acceptedFormats() {
        return ['.pdf', '.doc', '.docx', '.png', '.jpg'];
    }

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
        // getCreateCasePicklistValue().then((result) => {
        //     JSON.parse(result).forEach(el => {
        //         this.pickListOptions = [
        //         ...this.pickListOptions,
        //             {
        //                 label: el,
        //                 value: el
        //             }
        //         ]
        //     })
        // })


    }
    // handlePicklistChange(e){
    //     this.PicklistValue = e.target.value
    // }
    handleNameChange(e){
        this.InputNameValue = e.target.value
    }
    handleEmailChange(e){
        this.InputEmailValue = e.target.value
    }
    handleOrganizationChange(e){
        this.InputOrganizationValue = e.target.value
    }
    handleMessageChange(e){
        this.InputMessageValue = e.target.value
    }
    handleSerialNumberChange(e){
        this.InputSerialNumberValue = e.target.value
    }

    createCase(){
        if( this.InputNameValue &&
            this.InputEmailValue &&
            this.InputOrganizationValue &&
            this.InputMessageValue){

            createInquiryCase({

                Description: this.InputMessageValue,
                Name: this.InputNameValue,
                Email: this.InputEmailValue,
                Organization: this.InputOrganizationValue,
                FilesIDs: this.filesIDs,
                SerialNumber: this.InputSerialNumberValue
            }).then(result=>{
                //this.PicklistValue = '';
                this.InputNameValue = '';
                this.InputEmailValue = '';
                this.InputOrganizationValue = '';
                this.InputMessageValue = '';
                this.InputSerialNumberValue = '';

                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Case created successfully!',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);

                window.open('case/'+result+'/')
            })


        } else {
            const evt = new ShowToastEvent({
                title: 'Error during creating a case',
                message: 'All form fields should be matched.',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
        }

    }

    handleUploadFinished(event) {
        // Get the list of uploaded files
        console.log(event.detail.files)
        const uploadedFiles = event.detail.files;
        const fileDocumentIds = []
        for(let i = 0; i<uploadedFiles.length; i++){
            fileDocumentIds.push(uploadedFiles[i].documentId)
        }
        this.filesIDs = [...fileDocumentIds]
        console.log(this.filesIDs)

        getUploadedFiles({
            ContentDocumentId: this.filesIDs.join(',')
        }).then(res => {
            this.areUploadedFiles = true
            console.log(JSON.parse(res))
            this.data = [...JSON.parse(res)]
        })
    }

}