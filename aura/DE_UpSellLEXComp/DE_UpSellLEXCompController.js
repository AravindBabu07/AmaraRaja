({
	init : function(component, event, helper) {
		console.log('init');
        helper.getObject(component);
        helper.getProducts(component);
	},
    theCreateOpp : function(component, event, helper) {
		console.log('theCreateOpp');
        
        var Ids = [];

        $('.checkBoxClick').each(function(){
            //console.log('inside each');
            //console.log('this: ', this);
            if(this.checked){
                Ids.push( this.id );
            }
        });
        
        console.log('theIds: ', Ids);
        helper.createOpp(component, Ids);
	},
    doneRendering : function(component, event, helper) {
		//console.log('reRender');
	}
})