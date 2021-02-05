public class DE_EnquiryProductCls {
    @AuraEnabled
    public static list<Enquiry_product__C> getEProducts1(string oppId){
        list<Enquiry_product__C> eplist=[select id,opportunity__c,Dia_mm__c,Height_mm__c,Thickness_mm__c,InEditMode_c__c ,List_Price__c,Quantity__c,Discount__c,Sales_Price__c,product__c,type__c from Enquiry_product__C where opportunity__c=:oppid];
        return eplist;
    }
    @auraEnabled
    public static list<Enquiry_product__C> SaveEp(list<Enquiry_Product__c> eplist,string oppid){
        list<Enquiry_product__C>  neweplist=new list<Enquiry_product__C>();
        list<Enquiry_product__C>  updateeplist=new list<Enquiry_product__C>();
        List<Opportunity> oppty = new List<Opportunity>();
        system.debug('oppty'+oppty);
        oppty = [select id,owner.Email from Opportunity where id=:oppid];
        String ownerEmail;
        if(oppty != null && oppty[0] != null){
          ownerEmail = oppty[0].owner.Email;  
        }
        
        for(Enquiry_product__C ep:eplist){
            //System.debug('ep-->'+ep);
            ep.InEditMode_c__c = false; 
            if(ep.id!=null){
                updateeplist.add(ep);
            }
            else
                neweplist.add(ep);
        }
        if(neweplist!=null){insert neweplist;}
        
        if(updateeplist!=null){update updateeplist;}
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        String plainTextBody = 'Hello,<br/>';
        plainTextBody += 'A new opportunity for Datsun has been submitted to you for pricing. Please review and input pricing information. <br/>';
        plainTextBody +='<a href="https://www.google.com">Click here to view the opportunity.</a><br/><br/>';
        plainTextBody += 'Thank you \n<br/>';
        plainTextBody += 'Wendt Sales\n\n';
        message.toAddresses = new String[] { 'mthottathil@salesforce.com' };
            if(ownerEmail != null && ownerEmail != ''){
                message.toAddresses.add(ownerEmail);
            }
            message.optOutPolicy = 'FILTER';
        message.subject = 'Pricing Input Required';
        message.setHtmlBody(plainTextBody);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        list<Enquiry_product__C> eplistSaved=[select id,opportunity__c,Dia_mm__c,Height_mm__c,InEditMode_c__c ,product__c,type__c,Thickness_mm__c,List_Price__c,
                                              Quantity__c,Discount__c,Sales_Price__c from Enquiry_product__C where opportunity__c=:oppid];
        return eplistSaved;
    }
    @auraEnabled
    public static list<Enquiry_product__C> SaveEpSales(list<Enquiry_Product__c> eplist,string oppid){
        system.debug('Enquiry_Product__c list'+eplist);
        list<Enquiry_product__C>  neweplist=new list<Enquiry_product__C>();
        list<Enquiry_product__C>  updateeplist=new list<Enquiry_product__C>();
        List<Opportunity> oppty = new List<Opportunity>();
        oppty = [select id,owner.Id,owner.Email from Opportunity where id=:oppid];
        system.debug('oppty'+oppty);
        String ownerEmail;
        if(oppty != null && oppty[0] != null){
          ownerEmail = oppty[0].owner.Email;  
        }
        for(Enquiry_product__C ep:eplist){
            //System.debug('ep-->'+ep);
            ep.InEditMode_c__c = false; 
            if(ep.id!=null){
                updateeplist.add(ep);
            }
            else
                neweplist.add(ep);
        }
        if(neweplist!=null){insert neweplist;}
        
        if(updateeplist!=null){update updateeplist;}        system.debug(eplist);
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new String[] { 'mthottathil@salesforce.com' };
             if(ownerEmail != null && ownerEmail != ''){
                message.toAddresses.add(ownerEmail);
             }
            String plainTextBody = 'Hello,<br/>';
        plainTextBody += 'Pricing has been updated on the Datsun opportunity <br/>';
        plainTextBody +='<a href="https://www.google.com">Please Click here to review the same.</a><br/><br/>';
        plainTextBody += 'Thank you \n<br/>';
        plainTextBody += 'Wendt Pricing Team\n\n';
        message.optOutPolicy = 'FILTER';
        message.subject = 'Pricing Info Shared';
        message.setHtmlBody(plainTextBody);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: ' + results[0].errors[0].message);
        }
        list<Enquiry_product__C> eplistSaved=[select id,opportunity__c,Dia_mm__c,Height_mm__c,InEditMode_c__c ,product__c,type__c,Thickness_mm__c,List_Price__c,Quantity__c,Discount__c,Sales_Price__c from Enquiry_product__C where opportunity__c=:oppid];
        return eplistSaved;
    }
    
    @AuraEnabled
    public static list<Enquiry_product__C> getEProducts(string oppId){
        list<Enquiry_product__C> eplist=[select id,opportunity__c,Dia_mm__c,Height_mm__c,Thickness_mm__c,List_Price__c,Quantity__c,Discount__c,Sales_Price__c from Enquiry_product__C where opportunity__c=:oppid];
        return eplist;
    }
        @AuraEnabled
    public static void getDeleteRecords(Enquiry_product__C ep){
        if(ep.id!=null){
            delete ep;
        }
    }
}