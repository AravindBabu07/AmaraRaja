({
	getProducts : function(component) {
        console.log('helper.getProducts');
        
		var action = component.get("c.getProducts");
        action.setParams({
            "oppId" : component.get('v.recordId'),
            "imageField" : component.get('v.imageField')
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('response.getReturnValue()', response.getReturnValue());
                component.set('v.theProducts', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
	},
    
    getObject : function(component) {
        console.log('helper.getObject');
        
        var theRecordId = component.get('v.recordId');
                
        var action = component.get("c.getsObjectType");
        
		action.setParams({
            "oppId" : theRecordId
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('getsObjectType', response.getReturnValue());
                component.set('v.objectType', response.getReturnValue());
            }
        });
        
        $A.enqueueAction(action);
        
	},
    
    createOpp : function(component, Ids) {
        console.log('helper.createOpp');
        
        var theRecordId = component.get('v.recordId');
                
        var action = component.get("c.createOpp");
        
		action.setParams({
            "oppId" : theRecordId,
            "theIds" : Ids
        });
        
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                console.log('createOpp', response.getReturnValue());
                $A.get('e.force:refreshView').fire();
            }
        });
        
        $A.enqueueAction(action);
        
	}
})