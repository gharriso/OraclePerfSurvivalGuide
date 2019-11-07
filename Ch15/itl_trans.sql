var tid number;
var tdata varchar2(50);

BEGIN
   :tid := &1;
   :tdata := RPAD('y', 12);
END;
/

UPDATE itl_lock_demo
SET data = :tdata
WHERE id = :tid;
 
