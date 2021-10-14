global class TopLevelParentBatchable implements Database.Batchable<SObject>, Database.Stateful 
{
    //taken from http://salesforce.websolo.ca/2014/07/ultimate-parent-in-account-hierarchy.html and configured for this org to calculate the 
    //top level parent on when creating and updating a parent
    //Filling the UlimateParent2, had to replace the UlimateParent with UlimateParent2 in order to be a lookup and not a link to the parent
    //This is the batchable version that can then be scheduled with the TopLevelParentSchedulable
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return  Database.getQueryLocator([select id, Name, ParentId, Parent.ParentId, Parent.Parent.ParentId, Parent.Parent.Parent.ParentId, Parent.Parent.Parent.Parent.ParentId from Account]);
    }
    global void execute(Database.BatchableContext bc, List<SObject> batch)      
    {               
        list<Account> ListAcc = new list<Account>();
        set<id> idAcc = new set<id>();  
        for (Account a : (List<Account>) batch) 
        {
           if(a.ParentId != null)
           {
              ListAcc.add(a);
              idAcc.add(a.id);            
           }                
        }
        List<Account> AccUltP = new List<Account>();
        //if(Test.isRunningTest())
        //{
            /*Account Ac1 = new Account();
            Ac1.id = ListAcc[0].id;
            Ac1.Name = 'Test3';
            Ac1.BillingState = 'Illinois';
            Ac1.BillingPostalCode = '60133';
            Ac1.Firm_Type__c = 'Health System';
            AccUltP.add(Ac1);*/
        //}
        //else
        //{
                            AccUltP = [select id, Name,
                                             ParentId,
                                             Parent.ParentId,
                                             Parent.Parent.ParentId,
                                             Parent.Parent.Parent.ParentId,
                                             Parent.Parent.Parent.Parent.ParentId                                     
                                             from 
                                                Account
                                             where 
                                                ParentId != null
                                                and
                                                id IN: idAcc]; 
            system.debug('Accounts: '+AccUltP);
        //}  
       if(AccUltP.size() > 0)
       {                                                                        
           for(Account a: ListAcc)
           {
            for(Account b: AccUltP)
            {           
                if(a.id == b.id)
                {
                    System.debug('In first if with '+a.Name+' '+b.name);
                    if(b.Parent.Parent.Parent.Parent.ParentId != null)
                    {
                        a.UltimateParent2__c = b.Parent.Parent.Parent.Parent.ParentId;
                    }           
                    else
                    {
                        if(b.Parent.Parent.Parent.ParentId != null)
                        {
                            a.UltimateParent2__c = b.Parent.Parent.Parent.ParentId;
                        }       
                        else
                        {
                            if(b.Parent.Parent.ParentId != null)
                            {
                                a.UltimateParent2__c = b.Parent.Parent.ParentId;
                            }       
                            else
                            {
                                if(b.Parent.ParentId != null)
                                {
                                    a.UltimateParent2__c = b.Parent.ParentId;
                                }       
                                else
                                {
                                    if(b.ParentId != null)
                                    {
                                        a.UltimateParent2__c = b.ParentId;
                                    }
                                    else
                                    {
                                        a.UltimateParent2__c = b.id;
                                    }                               
                                }                   
                            }               
                        }           
                    }                   
                }
             }
          }
          update ListAcc;
       }                    
    }
    global void finish(Database.BatchableContext bc) 
    {
        
    }
           
}