/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2518

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_export_epa_inp(p_resultname text)
RETURNS integer AS
$BODY$

/* EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_export_epa_inp('demo1')
*/

DECLARE
	project_type_aux text;
	schemas_array name[];

	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

   	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	IF project_type_aux='WS' THEN
		PERFORM gw_fct_utils_csv2pg_export_epanet_inp(p_resultname, null);
	
	ELSE
		PERFORM gw_fct_utils_csv2pg_export_swmm_inp(p_resultname, null);
	
	END IF;
		
RETURN v_count;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;