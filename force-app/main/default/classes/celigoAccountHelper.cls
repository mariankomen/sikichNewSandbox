public class celigoAccountHelper {
    public static void setSyncedQuoteAdress(Account[] accLst) {
        Id[] aIdLst = new List<Id>();
        for(account a: accLst) {
            aIdLst.add(a.Id);
        }
        opportunity oppLst = [select accountId, stageName, syncedQuoteId, lastModifiedDate 
                                from opportunity where accountId in :aIdLst and stageName = 'Closed Won'
                               order by lastModifiedDate desc limit 1];
        quote[] qLst = [select id, billingCountry, billingState, billingCity, billingStreet, billingPostalCode 
                        from quote where id = :oppLst.SyncedQuoteId];
        //for(quote q:)
    }
}