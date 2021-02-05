({
    getPrice : function(component) {
        console.log('helper.getPrice');
        
        var theItem = component.get('v.item');
        var theOppId = component.get('v.oppId');
                
        var action = component.get("c.getProductPrice");
        
		action.setParams({
            "itemId" : theItem.Id,
            "oppId" : theOppId
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('getProductPrice', response.getReturnValue());
                var pricebookEntry = response.getReturnValue();
                component.set('v.productPrice', pricebookEntry.UnitPrice);
            }
        });
        
        $A.enqueueAction(action);
        
	},
    
	addProduct : function(component, theClickedProduct) {
        console.log('helper.addProduct');
        console.log('theClickedProduct', theClickedProduct);
        
		var action = component.get("c.addProduct");
        
        action.setParams({
            "oppId" : component.get('v.oppId'),
            "theClickedProduct" : theClickedProduct
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('OppLineItem', response.getReturnValue());
                $A.get('e.force:refreshView').fire(); 
            }
        });
        
        $A.enqueueAction(action);
        
	}
})