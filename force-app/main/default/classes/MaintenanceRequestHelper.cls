public class MaintenanceRequestHelper{    
    public static void updateWorkOrders(List<Case> maintenanceRequests) {
        List<Case> lstNewMaintenanceRequests = new List<Case>();
        List<Equipment_Maintenance_Item__c> lstUpdatedItems = new List<Equipment_Maintenance_Item__c>();
        List<Equipment_Maintenance_Item__c> products = [SELECT Id, Equipment__r.Maintenance_Cycle__c, Maintenance_Request__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :maintenanceRequests];
        for(Case maintenanceRequest : maintenanceRequests){
        	Case newMaintenanceRequest = new Case(
            	Status = 'New',
                Origin = 'web',
            	Type = 'Routine Maintenance',
            	Vehicle__c = maintenanceRequest.Vehicle__c,
            	Subject = 'Routine Maintenance',
            	Date_Reported__c = Date.today(),
                Cloned_Case_Id__c = maintenanceRequest.Id,
            	Date_Due__c = Date.today() + getDueDate(maintenanceRequest, products)
            );
            lstNewMaintenanceRequests.add(newMaintenanceRequest);
        }
        insert lstNewMaintenanceRequests;
        updateEquipments(lstNewMaintenanceRequests);
    } 
    
    public static void updateEquipments(List<Case> lstNewMaintenanceRequests){
        List<Equipment_Maintenance_Item__c> equipments = [SELECT Id, Maintenance_Request__c FROM Equipment_Maintenance_Item__c];
        List<Equipment_Maintenance_Item__c> updatedEquipments = new List<Equipment_Maintenance_Item__c>();
        for(Case newMaintenanceRequest : lstNewMaintenanceRequests){
            for(Equipment_Maintenance_Item__c equipment : equipments){
                if(equipment.Maintenance_Request__c == newMaintenanceRequest.Cloned_Case_Id__c){
                    equipment.Maintenance_Request__c = newMaintenanceRequest.Id;
                    updatedEquipments.add(equipment);
                }
            }
        }
        update updatedEquipments;
    }
    
    public static Integer getDueDate(Case maintenanceRequest, List<Equipment_Maintenance_Item__c> products){
        Integer smallerDueDate = null;
        for (Equipment_Maintenance_Item__c product : products) {
    		if (product.Maintenance_Request__c == maintenanceRequest.Id) {
        		Integer currentDueDate = (Integer) product.Equipment__r.Maintenance_Cycle__c;
        		if (smallerDueDate == null || currentDueDate < smallerDueDate) {
            		smallerDueDate = currentDueDate;
        		}
    		}
		}
        return smallerDueDate;
    }
}