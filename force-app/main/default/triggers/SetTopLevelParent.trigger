trigger SetTopLevelParent on Account (before insert, before update) {
    //taken from http://salesforce.websolo.ca/2014/07/ultimate-parent-in-account-hierarchy.html and configured for this org to calculate the 
    //top level parent on when creating and updating a parent
    //Filling the UlimateParent2, had to replace the UlimateParent with UlimateParent2 in order to be a lookup and not a link to the parent
    list<Account> ListAcc = new list<Account>();
    set<id> idAcc = new set<id>();
    set<id> idParAcc = new set<id>();
    for(Account a: Trigger.new)
    {
        if(a.ParentId != null)
        {
            ListAcc.add(a);
            idAcc.add(a.id);
			idParAcc.add(a.ParentID);            
        }
    }
    
    List<Account> AccUltP = [select id, Name,
                                     ParentId,
                                     Parent.ParentId,
                                     Parent.Parent.ParentId,
                                     Parent.Parent.Parent.ParentId,
                                     Parent.Parent.Parent.Parent.ParentId                                     
                                     from 
                                        Account
                                     where 
                                        //ParentId != null
                                        //and
                                        //id IN: idAcc];
                             			id IN: idParAcc]; 
   if(AccUltP.size() > 0)
   {                                                                        
       for(Account a: ListAcc)
       {
          
        for(Account b: AccUltP)
        {           
            
            if(a.ParentId == b.id)
            {	
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
   }                                    
}