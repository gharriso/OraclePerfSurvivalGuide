declare
    phys_reads number;
    log_reads number;
begin  
   gen_hit_rate.read_stats( phys_reads     NUMBER,
                           log_reads      NUMBER) ; 
                           dbms_output.put_line(phys_reads);
                           dbms_output.put_line(log_reads);
end; 
