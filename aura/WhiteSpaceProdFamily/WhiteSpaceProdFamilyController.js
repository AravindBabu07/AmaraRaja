({
	doInit : function(component, event, helper) {
		var action = component.get("c.fetchProdFamilyData");
        
        action.setParams({
             accId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if (state === "SUCCESS") {
                var resp = a.getReturnValue();
                component.set("v.prodFamListAttr", resp);
                
                var action1 = component.get("c.fetchRowsData");
        
                action1.setParams({
                     accId: component.get("v.recordId")
                });
                
                action1.setCallback(this, function(a) {
                    console.log('inside callback');
                    var state = a.getState();
                    
                    if (state === "SUCCESS") {
                        var resp1 = a.getReturnValue();
                        console.log('resp1 '+ JSON.stringify(resp1));
                        component.set("v.rowsListAttr", resp1);
                        
                    }else if (state === "INCOMPLETE") {
                        
                    }else if (state === "ERROR") {
                        
                    }
                });
                    
                $A.enqueueAction(action1);
                
            }else if (state === "INCOMPLETE") {
                
            }else if (state === "ERROR") {
                
            }
        });
            
        $A.enqueueAction(action); 
	}
})