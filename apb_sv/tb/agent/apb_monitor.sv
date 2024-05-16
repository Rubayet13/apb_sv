class monitor;

   virtual abp_if vif;
  
   mailbox #(transaction) mbx;
  
   transaction tr;

  

 
    function new(mailbox #(transaction) mbx);
      this.mbx = mbx;     
   endfunction;
  
  task run();
    tr = new();
    forever begin
      @(posedge vif.pclk);
      if((vif.psel) && (!vif.penable)) 
            begin
              
      		  @(posedge vif.pclk);
              if(vif.psel && vif.pwrite && vif.penable) ////write access
        			 begin
                      @(posedge vif.pclk);  
        			 tr.pwdata = vif.pwdata;
        			 tr.paddr = vif.paddr;
        			 tr.pwrite = vif.pwrite;
                     tr.pslverr = vif.pslverr;
                       $display("[MON] : DATA WRITE data : %0d and addr : %0d write :%0b", vif.pwdata, vif.paddr, vif.pwrite);
                       @(posedge vif.pclk);
         			end ////write access
     			 else if (vif.psel && !vif.pwrite && vif.penable)
          			 begin
                        @(posedge vif.pclk);
         			tr.prdata = vif.prdata;
         			tr.pwrite = vif.pwrite;
        			tr.paddr = vif.paddr;
                    tr.pslverr = vif.pslverr;
                      @(posedge vif.pclk);  
                       
                       $display("[MON] : DATA READ data : %0d and addr : %0d write:%0b", vif.prdata,vif.paddr, vif.pwrite);
                       
                       
                       
          			 end
      	
         
    
           mbx.put(tr);
         end
    end
  endtask
  

  
endclass