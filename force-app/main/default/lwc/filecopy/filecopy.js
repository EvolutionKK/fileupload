import { LightningElement, wire, api } from 'lwc';
import fnoppfile from '@salesforce/apex/oppfile.fnoppfile';
import getContentDetails from '@salesforce/apex/oppfile.getContentDetails';
import getAllContentDetails from '@salesforce/apex/oppfile.getAllContentDetails';
import deleteContentDocument from '@salesforce/apex/oppfile.deleteContentDocument';
import { NavigationMixin } from 'lightning/navigation';
//import sendmail from '@salesforce/apex/oppfile.sendmail';
import updatecontent from '@salesforce/apex/oppfile.updatecontent';

export default class Filecopy extends NavigationMixin(LightningElement) {

    ext;
    // actions = [
    //     { label: 'Preview', name: 'preview' },
    //     { label: 'Download', name: 'download' },
    // ];
    columns = [
        {
            label: 'Icons',
            fieldName: ' ',
            cellAttributes: {
                iconName: { fieldName: 'FileType' }
            }
        },
        { label: 'Title', fieldName: 'Title', type: 'text ' },
        { label: 'isValid', fieldName: 'evolution__isValid__c', type: 'boolean' },
        { label: 'Category', fieldName: 'evolution__Category__c', type: 'text' },
        {
            label: 'Actions',
            type: 'action',
            typeAttributes: { rowActions: { fieldName: 'evolution__Action__c' } },
        }
    ];
    show1 = true;
    show = false;
    @wire(fnoppfile) oplist;
    notelist = [];
    @api myRecordId;
    openModal = false;
    mail = '';
    mailId = '';
    openfileupload = false;
    category;
    check='All';
    selected='All';
    take=false;
    filsel;
    filval;
    ar20 = [{}];
    ar21 = [{}];
    ar22 = [{}];
    years = [
        {
            year : 2020,
            arr : this.ar20
        },
        {
            year : 2021,
            arr : this.ar21
        },
        {
            year : 2022,
            arr : this.ar22
        }
    ]
    activeSectionMessage = '';

    handleToggleSection(event) {
        this.activeSectionMessage =
            'Open section name:  ' + event.detail.openSections;
    }

    handleclicked(event) {
        let opid = event.target.dataset.id;
        console.log(opid);
        this.myRecordId = event.target.dataset.id;
        getContentDetails({
            recordId: opid
        }).then(result => {
            console.log(result);
            this.show1 = false;
            this.show = true;
            this.notelist = result;
            this.notelist.forEach(elem=>{
                if(elem.evolution__getyear__c == 2020){
                    this.ar20.push(elem);
                }else if(elem.evolution__getyear__c == 2021){
                    this.ar21.push(elem);
                }else if(elem.evolution__getyear__c == 2022){
                    this.ar22.push(elem);
                }
            })
            this.notelist.map(elem => {
                if (elem.evolution__isValid__c == true) {
                    elem.evolution__Action__c = [
                        { label: 'Preview', name: 'preview' },
                        { label: 'Download', name: 'download' },
                    ]
                } else {
                    elem.evolution__Action__c =[
                        { label: 'Preview', name: 'preview' },
                    ];
                }
                if (elem.FileExtension == 'jpg') {
                    elem.FileType = 'doctype:image';
                } else if (elem.FileExtension == 'pdf') {
                    elem.FileType = 'doctype:pdf';
                } else if (elem.FileExtension == 'txt') {
                    elem.FileType = 'doctype:txt';
                } else if (elem.FileExtension == 'csv') {
                    elem.FileType = 'doctype:csv';
                }
            })
        }).catch(err => {
            console.log(err);
        })
    }

    selclass(event) {
        console.log(event.target.value);
        this.category = event.target.value;
    }
    contentname(event) {
        var docname = event.target.value;
    }

    handleUploadFinished(event) {
        getContentDetails({
            recordId: this.myRecordId
        }).then(res => {
            // this.take = this.template.querySelector('.isvalo');
            if(this.template.querySelector('.isvalo').checked != null){
                this.take = this.template.querySelector('.isvalo').checked;
            }else{

            }

            if (this.take.checked == true) {
                var decide = true;
                res[0].evolution__isValid__c = true;
            } else {
                var decide = false;
                res[0].evolution__isValid__c = false;
            }
            res[0].evolution__Category__c = this.category;
            console.log('cat', res[0].evolution__Category__c);
            updatecontent({ recId: res[0].Id, bool: decide, cat: res[0].evolution__Category__c });
            console.log('ch', this.check, 'sel', this.selected);
            getAllContentDetails({ recordId: this.myRecordId, check: this.check, sel: this.selected }).then(result => {
                console.log(this.notelist);
                this.notelist = result;
                this.notelist.map(elem => {
                    if (elem.evolution__isValid__c == true) {
                        elem.evolution__Action__c = [
                            { label: 'Preview', name: 'preview' },
                            { label: 'Download', name: 'download' },
                        ];
                    } else {
                        elem.evolution__Action__c =[
                            { label: 'Preview', name: 'preview' },
                        ];
                    }
                    if (elem.FileExtension == 'jpg') {
                        elem.FileType = 'doctype:image';
                    } else if (elem.FileExtension == 'pdf') {
                        elem.FileType = 'doctype:pdf';
                    } else if (elem.FileExtension == 'txt') {
                        elem.FileType = 'doctype:txt';
                    } else if (elem.FileExtension == 'csv') {
                        elem.FileType = 'doctype:csv';
                    }
                })
            })
        })
    }


    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        this.mailId = row.ContentDocumentId;
        if (actionName == 'delete') {
            deleteContentDocument({
                recordId: row.ContentDocumentId
            }).then(result => {
                getContentDetails({
                    recordId: this.myRecordId
                }).then(res => {
                    this.notelist = res;
                    this.notelist.map(elem => {
                        if (elem.evolution__isValid__c == true) {
                            elem.evolution__Action__c = [
                                { label: 'Preview', name: 'preview' },
                                { label: 'Download', name: 'download' },
                            ];
                        } else {
                            elem.evolution__Action__c =[
                                { label: 'Preview', name: 'preview' },
                            ];
                        }
                        if (elem.FileExtension == 'jpg') {
                            elem.FileType = 'doctype:image';
                        } else if (elem.FileExtension == 'pdf') {
                            elem.FileType = 'doctype:pdf';
                        } else if (elem.FileExtension == 'txt') {
                            elem.FileType = 'doctype:txt';
                        } else if (elem.FileExtension == 'csv') {
                            elem.FileType = 'doctype:csv';
                        }
                    })
                });
            }).catch(err => {
                console.log(err);
            })
        } else if (actionName == 'preview') {
            this.previewFile(row);
        } else if (actionName == 'download') {
            this.download(row);
        }
        // else if (actionName == 'email') {
        //     this.openModal = true;
        // }
    }


    download(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://cyntexa-4a2-dev-ed.lightning.force.com/sfc/servlet.shepherd/document/download/' + event.target.dataset.name
            }
        }
        );
    }
    closeModal() {
        this.openModal = false;
    }

    previewfile(event){
        console.log(event.target.dataset.name);
        this[NavigationMixin.Navigate]({
                    type: 'standard__namedPage',
                    attributes: {
                        pageName: 'filePreview'
                    },
                    state: {
                        recordIds: event.target.dataset.name
                    }
                })
    }
    openfile() {
        this.openfileupload = true;
    }
    closefileupload() {
        this.openfileupload = false;
    }



    selfilter(event) {
        this.check = this.template.querySelector(".sval").value;
        this.selected = event.target.value;
        console.log(this.check);
        console.log(this.selected);
        getAllContentDetails({ recordId: this.myRecordId, check: this.check, sel: this.selected }).then(res => {
            this.notelist = res;
            this.notelist.map(elem => {
                if (elem.evolution__isValid__c == true) {
                    elem.evolution__Action__c = [
                        { label: 'Preview', name: 'preview' },
                        { label: 'Download', name: 'download' },
                    ];
                } else {
                    elem.evolution__Action__c = [
                        { label: 'Preview', name: 'preview' },
                    ];
                }
                if (elem.FileExtension == 'jpg') {
                    elem.FileType = 'doctype:image';
                } else if (elem.FileExtension == 'pdf') {
                    elem.FileType = 'doctype:pdf';
                } else if (elem.FileExtension == 'txt') {
                    elem.FileType = 'doctype:txt';
                } else if (elem.FileExtension == 'csv') {
                    elem.FileType = 'doctype:csv';
                }
            })
            console.log(this.notelist);
        }).catch(err => {
            console.log(err);
        })
    }


    selvalid(event) {
        this.check = event.target.value;
        this.selected = this.template.querySelector(".selec").value;
        console.log(this.check);
        console.log(this.selected);
        getAllContentDetails({ recordId: this.myRecordId, check: this.check, sel: this.selected }).then(res => {
            this.notelist = res;
            this.notelist.map(elem => {
                if (elem.evolution__isValid__c == true) {
                    elem.evolution__Action__c = [
                        { label: 'Preview', name: 'preview' },
                        { label: 'Download', name: 'download' },
                    ];
                } else {
                    elem.evolution__Action__c =[
                        { label: 'Preview', name: 'preview' },
                    ];
                }
                if (elem.FileExtension == 'jpg') {
                    elem.FileType = 'doctype:image';
                } else if (elem.FileExtension == 'pdf') {
                    elem.FileType = 'doctype:pdf';
                } else if (elem.FileExtension == 'txt') {
                    elem.FileType = 'doctype:txt';
                } else if (elem.FileExtension == 'csv') {
                    elem.FileType = 'doctype:csv';
                }
            })
            console.log(this.notelist);
        }).catch(err => {
            console.log(err);
        })

    }

}










