-- Parameters of unsupported types detected.
-- Please modify the code below manually.
DECLARE
Return_Value opsg.opsg_time_model_typ;
BEGIN
  Return_Value := opsg.opsg_pkg.wait_time_report(
    p_mode=>NULL);
END;
