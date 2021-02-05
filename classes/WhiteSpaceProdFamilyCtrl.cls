public class WhiteSpaceProdFamilyCtrl {
    
    @AuraEnabled
    public static List<String> fetchProdFamilyData(String accId){
        Set<String> prodfamSet = new Set<String>();
        List<Account> allAccts = new List<Account>();
        Account theAcct = [Select Id, Name, ParentId, Description from Account where Id=:accId];

        if(theAcct.ParentId != null){
            allAccts = [Select Id, Name, Description from Account where ParentId = :theAcct.ParentId];
            allAccts.add([Select Id, Name, Description from Account where Id = :theAcct.ParentId]);
        }
        else{
            allAccts = [Select Id, Name, Description from Account where ParentId = :theAcct.Id];
            allAccts.add(theAcct);
        }
        
        List<Asset> assetList = [select id, Product2.Family from Asset where AccountId IN: allAccts];
        for(Asset assetObj : assetList){
            prodfamSet.add(assetObj.Product2.Family);
        }
        return new List<String>(prodfamSet);
    }

    @AuraEnabled
    public Static List<RowHelperWrapper> fetchRowsData(String accId) {
        List<Account> allAccts = new List<Account>();
        Account theAcct = [Select Id, Name, ParentId, Description from Account where Id=:accId];

        if(theAcct.ParentId != null){
            allAccts = [Select Id, Name, Description from Account where ParentId = :theAcct.ParentId];
            allAccts.add([Select Id, Name, Description from Account where Id = :theAcct.ParentId]);
        }
        else{
            allAccts = [Select Id, Name, Description from Account where ParentId = :theAcct.Id];
            allAccts.add(theAcct);
        }
        
        Set<String> prodfamSet = new Set<String>();
        List<Asset> assetList = [select id, Product2.Family from Asset where AccountId =: allAccts];
        for(Asset assetObj : assetList){
            prodfamSet.add(assetObj.Product2.Family);
        }
        
        List<Asset> theAssets = [Select Id, Product2Id, Product2.Name, Product2.Family, Account.Name, IsCompetitorProduct from Asset
                                 where AccountId =: allAccts];
        Map<Id, List<Asset>> accAssetMap = new Map<Id, List<Asset>>();
        for(Asset assetObj : theAssets){
            if(accAssetMap.containsKey(assetObj.AccountId)){
                List<Asset> assetListTemp = accAssetMap.get(assetObj.AccountId);
                assetListTemp.add(assetObj);
                accAssetMap.put(assetObj.AccountId, assetListTemp);
            }else{
                List<Asset> assetListTemp = new List<Asset>();
                assetListTemp.add(assetObj);
                accAssetMap.put(assetObj.AccountId, assetListTemp);
            }
        }
        
        List<RowHelperWrapper> rowHelWrapList = new List<RowHelperWrapper>();
        for(Account accObj : allAccts){
            List<String> flagTypeListStr = new List<String>();
            //List<Integer> noOfAssetsList = new List<Integer>();
            RowHelperWrapper rowHelWrap = new RowHelperWrapper();
            rowHelWrap.accName = accObj.Name;
            for(String prdFam : prodfamSet){
                String flagTypeStr;
                
                if(accAssetMap.get(accObj.Id) != null){
                    flagTypeStr = rowSetFlagTypeHelper( prdFam, accAssetMap.get(accObj.Id));
                }else{
                    flagTypeStr = 'none';
                }
                flagTypeListStr.add(flagTypeStr);
                //noOfAssetsList.add(accAssetMap.get(accObj.Id).size());
            }
            rowHelWrap.flagTypeList = flagTypeListStr;
            //rowHelWrap.noOfAssets = noOfAssetsList;
            system.debug('rowHelWrap '+rowHelWrap);
            rowHelWrapList.add(rowHelWrap);
        }
		
        system.debug('rowHelWrapList '+rowHelWrapList);
        
        return rowHelWrapList;
    }
    
    public static String rowSetFlagTypeHelper( String prdFam, List<Asset> assetAccList){
        String assetFlag;
        for(Asset assetObj : assetAccList){
            if(assetObj.Product2.Family == prdFam){
                if(assetObj.IsCompetitorProduct){
                    assetFlag = 'true';
                    return assetFlag;
                }else{
                    assetFlag = 'false';
                }
            }else{
                if(assetFlag == 'true' || assetFlag == 'false'){
                    
                }else{
                    assetFlag = 'none';
                }
            }
        }
        return assetFlag;
    }
    
    public class RowHelperWrapper{
        @AuraEnabled
        public String accName;
        @AuraEnabled
        public List<String> flagTypeList;
        @AuraEnabled
        public string assetId;
    }
    
}