public class celigoOpportunityHelper {
    public static void updateAccaunt(Opportunity[] oppLst) {
        id[] idlst = new List<id>();
        for(opportunity o: oppLst) {
            if(o.StageName == 'Closed Won') {
                idlst.add(o.AccountId);
            }
        }
        account[] accLst = [select id from account where id in :idlst];
        update accLst;
    }
}