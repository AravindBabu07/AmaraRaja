({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getEProducts1");
        action.setParams({
            oppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log(response.getReturnValue().length);
                component.set("v.EPlist", response.getReturnValue()); 
                if(response.getReturnValue().length==0){
                    var oppId = component.get("v.recordId");
                    var EPRec = {  'sobjectType' : 'Enquiry_Product__c',
                                 
                                 'Opportunity__c' : oppId};
                    var AccPlanActListEPlist = component.get("v.EPlist");
                    AccPlanActListEPlist.push(EPRec);
                    component.set("v.EPlist", AccPlanActListEPlist);
                }
            }
        });
        $A.enqueueAction(action);
    },
    addrow:function(component, event, helper) {
        var oppId = component.get("v.recordId");
        var EPRec = {  'sobjectType' : 'Enquiry_Product__c',
                     
                     'Opportunity__c' : oppId};
        var AccPlanActListEPlist = component.get("v.EPlist");
        AccPlanActListEPlist.push(EPRec);
        component.set("v.EPlist", AccPlanActListEPlist);
    },
    
    deleterow:function(component, event, helper) {
        console.log(event.getSource().get("v.value"));
        var index=event.getSource().get("v.value");
        var AllRowsList = component.get("v.EPlist");
        var ep=AllRowsList[index];
        console.log(ep);
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.EPlist", AllRowsList);
        
        var action1=component.get("c.getDeleteRecords");
        action1.setParams({"ep" : ep});
        action1.setCallback(this, function(response) {
            console.log('came getDeleteRecords');
            var res=response.getReturnValue();
            console.log('res',response.getReturnValue());
             
        });
        $A.enqueueAction(action1);

    },
    save:function(component, event, helper) {
        var EPlist = component.get("v.EPlist");
        var oppid=component.get("v.recordId");
        console.log(EPlist);
        
        var action1=component.get("c.SaveEp");
        action1.setParams({"eplist" : EPlist,"oppid":oppid});
        action1.setCallback(this, function(response) {
            console.log('came SaveEp');
            console.log(response.getReturnValue());
            component.set("v.EPlist", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
    },
    save1:function(component, event, helper) {
        var EPlist = component.get("v.EPlist");
        var oppid=component.get("v.recordId");
        
        
        
        var action1=component.get("c.SaveEpSales");
        action1.setParams({"eplist" : EPlist,"oppid":oppid});
        action1.setCallback(this, function(response) {
            console.log('came SaveEp');
            console.log(response.getReturnValue());
            component.set("v.EPlist", response.getReturnValue()); 
        });
        $A.enqueueAction(action1);
    },
    
    editClicked: function(component, event, helper) {
        console.log( event.currentTarget.getAttribute("data-target"));
        var acPlan = event.currentTarget.getAttribute("data-target");
        var acPlanList = component.get("v.EPlist");
        for (var i = 0; i < acPlanList.length; i++){
            if(acPlan == acPlanList[i].Id){
                acPlanList[i] = acPlan;
                acPlanList[i].InEditMode_c__c = true;
            }
        }
        component.set("v.EPlist", acPlanList);
    },
    
    handleEditAccPlan : function(component, event, helper) {
        console.log(event.getSource().get("v.value"));
        var acPlan = event.getSource().get("v.value");
        acPlan.InEditMode_c__c = true;
        var acPlanList = component.get("v.EPlist");
        for (var i = 0; i < acPlanList.length; i++){
            if(acPlan.Id == acPlanList[i].Id){
                acPlanList[i] = acPlan;
            }
        }
        component.set("v.EPlist", acPlanList);
    }
    
})