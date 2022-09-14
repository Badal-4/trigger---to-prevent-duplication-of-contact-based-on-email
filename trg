//trigger to prevent duplication of contact based on email
trigger trg2 on Contact(before Update,before Insert)
{
    Set<String> emailSet = new Set<String>();
   if(trigger.isBefore && (trigger.isUpdate || trigger.isInsert))
   {
       if(!trigger.new.isEmpty())
       {
           for(Contact c : trigger.new)
           {
               if(c.Email != null)
               {
                   emailSet.add(c.Email);
               }
           }
       }
   }
    
    List<Contact> conList = [Select Id,Email from Contact where Email != null and  email IN : emailSet];
    Set<String> existingEmail = new Set<String>();
    for(Contact con : conList)
    {
        existingEmail.add(con.Email);
    }
    
    for(Contact cont : trigger.new)
    {
        if(existingEmail.contains(cont.Email))
        {
            cont.addError('This contact cannot be inserted or updated due to duplication of contact');
        }
    }
}
