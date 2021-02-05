public class DE_UpSellLEXCompCtrl {

    @AuraEnabled
    public static List<Product2> getProducts(String oppId, String imageField){
        
        //check if opp or Account
        Id tempId = (Id)oppId;
        String objectAPIName = tempId.getSObjectType().getDescribe().getName();
        
        system.debug('objectAPIName: '+ objectAPIName);
        
        if(objectAPIName == 'Opportunity'){
            
            List<OpportunityLineItem> theOppLineItemList = [SELECT Id, OpportunityId, PricebookEntryId, Product2Id, Product2.Name FROM OpportunityLineItem WHERE OpportunityId = :oppId];
            system.debug('theOppLineItemList: '+theOppLineItemList);
            
            String theQuery = '';
            if(imageField != null && imageField != ''){
                theQuery = 'SELECT Id, Name, IsUpSell__c, UpSell_Image__c, UpSell_Price__c,'+imageField+' FROM Product2 WHERE IsUpSell__c = TRUE';
            }
            else{
                theQuery = 'SELECT Id, Name, IsUpSell__c, UpSell_Image__c, UpSell_Price__c FROM Product2 WHERE IsUpSell__c = TRUE';
            }
            List<Product2> theProducts = Database.query(theQuery);
            
                    
            for(Integer i=0;i<theOppLineItemList.size();i++){
                for(Integer z=0;z<theProducts.size();z++){
                    if(theOppLineItemList[i].Product2Id == theProducts[z].Id){
                        system.debug('Opp.Product.Name: '+theOppLineItemList[i].Product2.Name+' = ProductList.Product: '+theProducts[z].Name);
                        theProducts.remove(z);
                    }
                }
            }
            system.debug('theProducts: '+theProducts);
            
            return theProducts;
        }
        else if(objectAPIName == 'Account'){
            
            String theQuery = '';
            if(imageField != null && imageField != ''){
                theQuery = 'SELECT Id, Name, IsUpSell__c, UpSell_Image__c, UpSell_Price__c,'+imageField+' FROM Product2 WHERE IsUpSell__c = TRUE';
            }
            else{
                theQuery = 'SELECT Id, Name, IsUpSell__c, UpSell_Image__c, UpSell_Price__c FROM Product2 WHERE IsUpSell__c = TRUE';
            }
            List<Product2> theProducts = Database.query(theQuery);
            
            system.debug('theProducts: '+theProducts);
            
            return theProducts;
        }
        else{
            return null;
        }            
        
    }
    
    @AuraEnabled
    public static OpportunityLineItem addProduct(String oppId, String theClickedProduct){
        
        Id tempId = (Id)oppId;
        String objectAPIName = tempId.getSObjectType().getDescribe().getName();
        
        system.debug('objectAPIName: '+ objectAPIName);
        
        if(objectAPIName == 'Opportunity'){
            Opportunity theOpp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id = :oppId];
            
            PricebookEntry thePricebookEntry = new PricebookEntry();
            System.Debug('Pricebook : '+theOpp.Pricebook2Id);
            
            if(theOpp.Pricebook2Id != null){
                thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :theOpp.Pricebook2Id AND Product2Id = :theClickedProduct];
            }
            else{
                Pricebook2 thePricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' Limit 1];
                thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :thePricebook.Id AND Product2Id = :theClickedProduct];
            }
            
            OpportunityLineItem theOppLineItem = new OpportunityLineItem();
            
            theOppLineItem.PricebookEntryId = thePricebookEntry.Id;
            theOppLineItem.OpportunityId = theOpp.Id;
            theOppLineItem.UnitPrice = thePricebookEntry.UnitPrice;
            theOppLineItem.Quantity = 1;
            
            insert theOppLineItem;
            return theOppLineItem;
        }
        else if(objectAPIName == 'Account'){
            Account theAccount = [SELECT Id FROM Account WHERE Id = :oppId];
            
            return null;
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static PricebookEntry getProductPrice(String itemId, String oppId){
        
        Id tempId = (Id)oppId;
        String objectAPIName = tempId.getSObjectType().getDescribe().getName();
        
        system.debug('objectAPIName: '+ objectAPIName);
        
        if(objectAPIName == 'Opportunity'){
            Opportunity theOpp = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id = :oppId];
    
            PricebookEntry thePricebookEntry = new PricebookEntry();
            System.Debug('Pricebook : '+theOpp.Pricebook2Id);
          
            if(theOpp.Pricebook2Id != null){
                thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :theOpp.Pricebook2Id AND Product2Id = :itemId];
            }
            else{
                Pricebook2 thePricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' Limit 1];
                thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :thePricebook.Id AND Product2Id = :itemId];
            }
    
            return thePricebookEntry; 
        }
        else if(objectAPIName == 'Account'){
            Account theAccount = [SELECT Id FROM Account WHERE Id = :oppId];
            
            PricebookEntry thePricebookEntry = new PricebookEntry();
            
            Pricebook2 thePricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' Limit 1];
            thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :thePricebook.Id AND Product2Id = :itemId];
            
            return thePricebookEntry; 
        }
        else{
            return null;
        }
    }
    
    @AuraEnabled
    public static String getsObjectType(String oppId){
        Id tempId = (Id)oppId;
        String objectAPIName = tempId.getSObjectType().getDescribe().getName();
        
        return objectAPIName;
    }
    
    @AuraEnabled
    public static Opportunity createOpp(String oppId, List<String> theIds){
        
        Account theAccount = [SELECT Id FROM Account WHERE Id = :oppId];
        
        Opportunity theNewOpp = new Opportunity();
        
        theNewOpp.Name = 'New Opp';
        theNewOpp.StageName = 'Prospecting';
        Date theDate = Date.today().addYears(1);
        theNewOpp.CloseDate = theDate;
        theNewOpp.AccountId = theAccount.Id;
        
        system.debug('theNewOpp: '+ theNewOpp);
        insert theNewOpp;
        
        Pricebook2 thePricebook = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' Limit 1];

        List<PricebookEntry> thePriceBookList = new List<PricebookEntry>();
        List<OpportunityLineItem> theOppLineItemList = new List<OpportunityLineItem>();
        
        for(integer i=0;i<theIds.size();i++){
            try{
                PricebookEntry thePricebookEntry = [SELECT Id, UnitPrice FROM PricebookEntry WHERE Pricebook2Id = :thePricebook.Id AND Product2Id = :theIds[i]];
            	thePriceBookList.add(thePricebookEntry);
                system.debug('thePricebookEntry: '+ thePricebookEntry);
                
                OpportunityLineItem theOppLineItem = new OpportunityLineItem();
            
                theOppLineItem.PricebookEntryId = thePricebookEntry.Id;
                theOppLineItem.OpportunityId = theNewOpp.Id;
                theOppLineItem.UnitPrice = thePricebookEntry.UnitPrice;
                theOppLineItem.Quantity = 1;
                
                theOppLineItemList.add(theOppLineItem);
                
            }
            catch(exception e){
                
            }
            
        }
        
        insert theOppLineItemList;
        system.debug('theOppLineItemList: '+ theOppLineItemList);
        
        return theNewOpp;
    }
}