trigger MaintenanceRequest on Case (before update, after update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        List<Case> maintenanceRequests = new List<Case>();
    	for(Case maintenanceRequest : Trigger.new){
        	if(maintenanceRequest.Status == 'Closed' && (maintenanceRequest.Type == 'Repair' || maintenanceRequest.Type == 'Routine Maintenance')){
                // MaintenanceRequestHelper.updateWorkOrders(maintenanceRequest);
                maintenanceRequests.add(maintenanceRequest);
        	}
    	}
        MaintenanceRequestHelper.updateWorkOrders(maintenanceRequests);
    }
}