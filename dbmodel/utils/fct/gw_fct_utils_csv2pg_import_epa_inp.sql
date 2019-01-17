/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2532

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epa_inp(p_path text)
RETURNS integer AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epa_inp()
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
		PERFORM gw_fct_utils_csv2pg_import_epanet_inp(11, p_path);
	
	ELSE
		PERFORM gw_fct_utils_csv2pg_import_swmm_inp(11, p_path);
	
	END IF;
		
RETURN 0;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;