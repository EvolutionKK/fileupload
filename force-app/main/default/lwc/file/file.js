import { LightningElement, wire, api } from 'lwc';
import fnoppfile from '@salesforce/apex/oppfile.fnoppfile';
import getContentDetails from '@salesforce/apex/oppfile.getContentDetails';
import deleteContentDocument from '@salesforce/apex/oppfile.deleteContentDocument';
import { NavigationMixin } from 'lightning/navigation';
import sendmail from '@salesforce/apex/oppfile.sendmail';

export default class File extends NavigationMixin(LightningElement) {

    ext;
    actions = [
        { label: 'Preview', name: 'preview' },
        { label: 'Download', name: 'download' },
        { label: 'Email', name: 'email' },
        { label: 'Delete', name: 'delete' },
    ];
    columns = [
        { label: 'Icons', 
        fieldName: ' ',
        cellAttributes: { iconName: {fieldName: 'FileType'}
        }}  ,
        { label: 'Title', fieldName: 'Title', type: 'text ' },
        {
            type: 'action',
            typeAttributes: { rowActions: this.actions },
        }
    ];
    show1 = true;
    show = false;
    @wire(fnoppfile) oplist;
    notelist = [];
    acceptedFormats = ['.pdf', '.png', '.jpg', 'csv', 'txt', 'excel'];
    @api myRecordId;
    openModal  = false;
    mail = '';
    mailId = '';

    handleclicked(event) {
        let opid = event.target.dataset.id;
        console.log(opid);
        this.myRecordId = event.target.dataset.id;
        getContentDetails({
            recordId : opid
        }).then(result => {
            console.log(result);
            this.show1 = false;
            this.show = true;
            this.notelist = result;
             this.notelist.map(elem=>{
                if(elem.FileExtension == 'jpg')
                    {
                        elem.FileType = 'doctype:image';
                    }else if(elem.FileExtension == 'pdf')
                    {
                        elem.FileType = 'doctype:pdf';
                    }else if(elem.FileExtension == 'txt')
                    {
                        elem.FileType = 'doctype:txt';
                    }else if(elem.FileExtension == 'csv')
                    {
                        elem.FileType = 'doctype:csv';
                    }
             })
        }).catch(err => {
            console.log(err);
        })
    }

    handleUploadFinished(event) {
        getContentDetails({
            recordId : this.myRecordId
        }).then(res=>{
            this.notelist = res;
            this.notelist.map(elem=>{
                if(elem.FileExtension == 'jpg')
                    {
                        elem.FileType = 'doctype:image';
                    }else if(elem.FileExtension == 'pdf')
                    {
                        elem.FileType = 'doctype:pdf';
                    }else if(elem.FileExtension == 'txt')
                    {
                        elem.FileType = 'doctype:txt';
                    }else if(elem.FileExtension == 'csv')
                    {
                        elem.FileType = 'doctype:csv';
                    }
             })
        })
    }


    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.mailId= row.ContentDocumentId;
        if (actionName == 'delete') {
            deleteContentDocument({
                recordId : row.ContentDocumentId
            }).then(result=>{
                getContentDetails({
                    recordId : this.myRecordId
                }).then(res=>{
                    this.notelist = res;
                    this.notelist.map(elem=>{
                        if(elem.FileExtension == 'jpg')
                            {
                                elem.FileType = 'doctype:image';
                            }else if(elem.FileExtension == 'pdf')
                            {
                                elem.FileType = 'doctype:pdf';
                            }else if(elem.FileExtension == 'txt')
                            {
                                elem.FileType = 'doctype:txt';
                            }else if(elem.FileExtension == 'csv')
                            {
                                elem.FileType = 'doctype:csv';
                            }
                     })
                });
            }).catch(err=>{
                console.log(err);
            })
        } else if (actionName == 'preview') {
            this.previewFile(row).then(res => {
                console.log(res);
            }).catch(err => {
                console.log(err);
            })
        } else if (actionName == 'download') {
            this.download(row);
        } else if (actionName == 'email') {
            this.openModal = true;
        }
    }

    
    download(file){
        this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: 'https://cyntexa-4a2-dev-ed.lightning.force.com/sfc/servlet.shepherd/document/download/'+file.ContentDocumentId
                }
            } 
        );
    }
    closeModal()
    {
        this.openModal = false;
    }
    closeModalandsubmit()
    {
        this.mail = this.template.querySelector('[data-id="mail"]').value;
        this.openModal = false;
        let body = '/sfc/servlet.shepherd/document/download/'+this.mailId;
        sendmail({email: this.mail, body : body}).then(res=>{
            alert('mail sent');
        }).catch(err=>{
            console.log(err);
        })
    }

    previewFile(file){
            this[NavigationMixin.Navigate]({
                type: 'standard__namedPage',
                attributes: {
                    pageName: 'filePreview'
                },
                state : {
                    recordIds: file.ContentDocumentId
                }
            });
        } 
}


