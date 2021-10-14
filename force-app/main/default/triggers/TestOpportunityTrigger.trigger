trigger TestOpportunityTrigger on Opportunity (after insert, after update) {
     celigoOpportunityHelper.updateAccaunt(trigger.new);
	 integrator_da__.RealTimeExportResult res = integrator_da__.RealTimeExporter.processExport(); 
}