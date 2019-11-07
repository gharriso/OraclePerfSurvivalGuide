select 'SELECT * FROM TABLE(DBMS_XPLAN.display_cursor('''||sql_id||''','||child_number||',''BASIC''));' from v$sql where sql_text like '%+GH1%'
