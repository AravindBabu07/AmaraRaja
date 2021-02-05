({
    init : function(component, event, helper) {
		helper.getPrice(component);
        
        //console.log('product init');
        theItem = component.get('v.item');
        //console.log('theItem: ', theItem);
        theField = component.get('v.imageField');
        //console.log('theField: ', theField);
        if(theField && theField != ''){
            //console.log('inside the field');
            var image = theItem[theField];
            //console.log('image: ', image);
            component.set('v.image', image);
        }
	},
    
	addToOpp : function(component, event, helper) {
		var thePrefix = component.get('v.prefix');
        console.log('thePrefix: ', thePrefix);
        var theCheckLocation = '';
        if(thePrefix){
            theCheckLocation = thePrefix + '/resource/DE_UpSellLEXSLDS/assets/icons/utility/check_120.png';
        }
        else{
            theCheckLocation = '/resource/DE_UpSellLEXSLDS/assets/icons/utility/check_120.png';
        }
        console.log('theCheckLocation: ', theCheckLocation);
        console.log('addToOpp');
        var theClickedElementId = event.srcElement.id;
        console.log('event: ', event.srcElement.id);
        
        //console.log($('#'+theClickedElementId).parent().parent());
        
        $('#'+theClickedElementId).parent().parent().find('.productImgs').attr("src",theCheckLocation);
        $('#'+theClickedElementId).parent().parent().find('.overLay').show();
        $('#'+theClickedElementId).parent().parent().fadeOut();
        helper.addProduct(component,theClickedElementId);
        
	}
})