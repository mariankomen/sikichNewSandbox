global class TopLevelParentSchedulable implements Schedulable{
    //taken from http://salesforce.websolo.ca/2014/07/ultimate-parent-in-account-hierarchy.html and configured for this org to calculate the 
    //top level parent on when creating and updating a parent
    //Filling the UlimateParent2, had to replace the UlimateParent with UlimateParent2 in order to be a lookup and not a link to the parent
    //To Run: TopLevelParentSchedulable t=new TopLevelParentSchedulable();
	//String sch= '0 0 0 * * ?';// where this is the time you want it to run hours minutes seconds
	//String jobId=system.schedule('TopLevelParentScheduler', sch,t);
    global void execute(SchedulableContext ctx) 
        {
            Database.executeBatch(new TopLevelParentBatchable(), 200);
        }
          

}