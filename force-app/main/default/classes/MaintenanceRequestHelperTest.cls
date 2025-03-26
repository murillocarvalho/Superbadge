@isTest
public with sharing class MaintenanceRequestHelperTest {
    @isTest
    static void testRequest(){
        Vehicle__c vehicle = new Vehicle__c(Name = 'Opala');
        insert vehicle;
        
        Case newMaintenanceRequest = new Case(
        	Status = 'New',
            Type = 'Repair',
            Vehicle__c = vehicle.Id,
            Subject = 'Routine Maintenance',
            Date_Reported__c = Date.today()
        );
        insert newMaintenanceRequest;
        
        System.debug('Case da Test: ' + newMaintenanceRequest.Id);
        
        Product2 equip = new Product2(Name = 'Eixo', Maintenance_Cycle__c = 25, Replacement_Part__c = True);
        insert equip;
        System.debug('Insert de Equipment');
        
        Equipment_Maintenance_Item__c maintenanceItem = new Equipment_Maintenance_Item__c(
        	Quantity__c = 1,
            Equipment__c = equip.Id,
            Maintenance_Request__c = newMaintenanceRequest.Id
        );
        insert maintenanceItem;
        System.debug('Insert de Equipment Maintenance Item');
        
        newMaintenanceRequest.Status = 'Closed';
        update newMaintenanceRequest;
        System.debug('Terminou o teste');
    }
}