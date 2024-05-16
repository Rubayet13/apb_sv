class generator;
  
   transaction tr;
  
   mailbox #(transaction) mbx;
  
   int count = 0;
  
   event nextdrv; ///driver completed task of triggering interface
  
   event nextsco; ///scoreboard completed its objective
  
   event done; 
   
   
  function new(mailbox #(transaction) mbx);
      this.mbx = mbx;
      tr=new();
   endfunction; 

   task run(); 
    
     repeat(count)	 
	     begin    
           assert(tr.randomize()) else $error("Randomization failed");	
           mbx.put(tr.copy);
           tr.display("GEN");
           @(nextdrv);
           @(nextsco);
         end  
     ->done;
   endtask
  
  
endclass