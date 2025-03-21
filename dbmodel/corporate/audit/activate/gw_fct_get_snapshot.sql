/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- DROP FUNCTION SCHEMA_NAME.gw_fct_get_snapshot();

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_snapshot(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

DECLARE

v_schemaname text;
v_version text;
v_error_context text;
v_date date;
v_polygon text;
v_features text[];
v_last_snapshot_date date;

BEGIN
	-- search path
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Get api version
    SELECT value INTO v_version FROM PARENT_SCHEMA.config_param_system WHERE parameter = 'admin_version';

	v_date = ((p_data ->>'form')::json->>'date');
	v_polygon = ((p_data ->>'form')::json->>'polygon');
	v_features := ARRAY(SELECT * FROM jsonb_array_elements_text((p_data -> 'form' ->> 'features')::jsonb));

	-- Get last snapshot date
	SELECT "date" INTO v_last_snapshot_date FROM "snapshot" WHERE "date" <= v_date ORDER BY "date" DESC LIMIT 1;

	-- Return JSON
	RETURN PARENT_SCHEMA.gw_fct_json_create_return(('{
		"status": "Accepted",
		"version": ' || to_json(v_version) || ',
		"body": {
			"data": {
				"fields": "test"
			}
		}
	}')::json, 3348, null, null, null)::json;


	EXCEPTION
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
			RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||
				',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;

$function$
;
