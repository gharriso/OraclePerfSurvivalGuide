var yval number;
var xval number; 

begin
    :yval:=3;
    :xval:=2;
end;
/
UPDATE bitmapped_index_table
SET y = :yval
WHERE x = :xval;
/* Formatted on 26/01/2009 1:37:36 PM (QP5 v5.120.811.25008) */
 
