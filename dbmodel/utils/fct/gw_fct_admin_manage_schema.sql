/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2084

--drop function SCHEMA_NAME.gw_fct_admin_manage_schema(json)
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_schema(p_data json)
  RETURNS void AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_admin_manage_schema($${"client":{"lang":"ES"}, "data":{"action":"REPAIRVIEWS","source":"ws_sample", "target":"ws"}}$$);

*/

DECLARE 
v_action text;
v_source text;
v_target text;
v_view record;

BEGIN
	
	v_action = ((p_data ->>'data')::json->>'action')::text; 
	v_source = ((p_data ->>'data')::json->>'source')::text; 
	v_target = ((p_data ->>'data')::json->>'target')::text; 

	-- search path
	EXECUTE 'SET search_path = '||v_target||', public';


	IF v_action = 'REPAIRVIEWS' THEN

		FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, '||quote_literal(v_source)||','||quote_literal(v_target)||') as definition FROM information_schema.VIEWS WHERE table_schema = '
					||quote_literal(v_source)||' and table_name not in (SELECT table_name FROM information_schema.VIEWS WHERE table_schema = '||quote_literal(v_target)||')'
		LOOP
			EXECUTE 'CREATE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;
		END LOOP;
	
	END IF;

	-- admin role permissions
	PERFORM gw_fct_admin_role_permissions();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;