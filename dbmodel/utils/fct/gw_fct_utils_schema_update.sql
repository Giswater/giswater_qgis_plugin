/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2546

CREATE OR REPLACE FUNCTION ws_sample.gw_fct_utils_schema_update(p_newversion text, p_projectype text, p_lang text, p_epsg integer) RETURNS json AS
$BODY$

DECLARE 
	v_dbnname varchar;
	v_schema_array name[];
	v_schemaname varchar;
	v_tablerecord record;
	v_projecttype text;
	v_query_text text;
	v_function_name text;
	v_apiservice boolean;	
	v_priority integer;
	v_message text;
	v_version record;

BEGIN 

	-- search path
	SET search_path = "ws_sample", public;
	
		
	-- check inconsistency for ws project:
	IF v_projecttype = 'WS' THEN
	
		-- look for inp_pattern_value bug (+18 values are not possible)
		IF (SELECT factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM inp_pattern_value LIMIT 1) IS NOT NULL THEN
			INSERT INTO audit_log_project (fprocesscat_id, table_id, log_message) 
					VALUES (33, inp_pattern_value, '"version":"'||p_newversion||'", "message":"There are some values on columns form 19 to 24. It must be deleted because it causes a bug on EPANET"');
			v_priority=1;
		
		END IF;
			
	ELSIF v_projecttype = 'UD' THEN
	
	END IF;
	
	-- update permissions	
	PERFORM gw_fct_utils_role_permissions();
	
	-- version table (for new project)
	IF p_lang IS NOT NULL THEN 
		-- inserting version table
		INSERT INTO version (giswater, wsoftware, language, epsg) VALUES (p_newversion, p_projectype, v_version.language, v_version.epsg);
		
	-- for updates
	ELSE 
		-- Looking for project type
		SELECT * INTO v_version FROM version LIMIT 1;

		-- inserting version table
		INSERT INTO version (giswater, wsoftware, language, epsg) VALUES (p_newversion, v_version.wsoftware, p_lang, p_epsg);
	END IF;
	
	-- get return message
	IF v_priority=0 THEN
		v_message="Project updated sucessfully";
	
	ELSIF v_priority=1 THEN
		v_message=concat($$Project updated but there some warnings. Please check on audit_log_project table to see it 
					SELECT * FROM audit_log_project WHERE fprocesscat_id=33 and (message::json->>'version')=$$, p_newversion);
	
	ELSIF v_priority=2 THEN
	
	END IF;
	
	-- Return
    RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');
	
			

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

