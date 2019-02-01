/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: XXXX

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_audit_schema(p_action text)
  RETURNS integer AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_audit_schema('enable')
SELECT SCHEMA_NAME.gw_fct_audit_schema('disable')
*/

DECLARE 
      v_schema_name text;

BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schema_name = 'SCHEMA_NAME';


	FOR table_record IN SELECT * FROM audit_cat_table WHERE isaudit  IS TRUE
	LOOP 
		EXECUTE 'DROP TRIGGER IF EXISTS gw_trg_audit'||table_record.id||' ON '||table_record.id;
		IF p_action='enable' THEN
			EXECUTE 'CREATE TRIGGER gw_trg_audit'||table_record.id||' AFTER INSERT OR UPDATE OR DELETE ON '||v_schema_name||'.'
			||table_record.id||'FOR EACH ROW EXECUTE PROCEDURE '||v_schema_name||'.gw_trg_audit()';
		END IF;
	END LOOP;		

return 0;
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;