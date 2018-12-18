/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2546

CREATE OR REPLACE FUNCTION ws_sample.gw_fct_utils_schema_update(p_data json) RETURNS json AS
$BODY$

/*
SELECT ws_sample.gw_api_getlist($${
"client":{"lang":"ES"},
"data":{"isNewProject":"TRUE", "gwVersion":"3.1.105", "projectType"="WS", "epsg":25831}}$$)
*/

DECLARE 
	v_dbnname varchar;
	v_projecttype text;
	v_priority integer;
	v_message text;
	v_version record;
	v_gwversion text;
	v_language text;
	v_epsg integer;
	v_isnew boolean;

BEGIN 
	-- search path
	SET search_path = "ws_sample", public;

	-- get input parameters
	v_gwversion := (p_data ->> 'data')::json->> 'gwVersion';
	v_language := (p_data ->> 'client')::json->> 'lang';
	v_projecttype := (p_data ->> 'data')::json->> 'projectType';
	v_epsg := (p_data ->> 'data')::json->> 'epsg';
	v_isnew := (p_data ->> 'data')::json->> 'isNewProject';

	-- update permissions	
	PERFORM gw_fct_utils_role_permissions();

	
	-- last proccess
	IF v_isnew IS TRUE THEN

		-- inserting version table
		INSERT INTO version (giswater, wsoftware, language, epsg) VALUES (v_gwversion, v_projectype, v_language, v_epsg);		
	ELSE
		-- check project consistency
		IF v_projecttype = 'WS' THEN
	
			-- look for inp_pattern_value bug (+18 values are not possible)
			IF (SELECT factor_19, factor_20, factor_21, factor_22, factor_23, factor_24 FROM inp_pattern_value LIMIT 1) IS NOT NULL THEN
				INSERT INTO audit_log_project (fprocesscat_id, table_id, log_message) 
				VALUES (33, inp_pattern_value, '"version":"'||v_gwversion||'", "message":"There are some values on columns form 19 to 24. It must be deleted because it causes a bug on EPANET"');
				v_priority=1;
			END IF;
			
		ELSIF v_projecttype = 'UD' THEN

		END IF;

		-- inserting version table
		SELECT * INTO v_version FROM version LIMIT 1;	
		INSERT INTO version (giswater, wsoftware, language, epsg) VALUES (v_gwversion, v_version.wsoftware, v_version.language, v_version.epsg);
	END IF;
	
	-- get return message
	IF v_priority=0 THEN
		v_message="Project updated sucessfully";
	ELSIF v_priority=1 THEN
		v_message=concat($$Project updated but there some warnings. Please check on audit_log_project table to see it 
				SELECT * FROM audit_log_project WHERE fprocesscat_id=33 and (message::json->>'version')=$$, v_gwversion);
	ELSIF v_priority=2 THEN
		v_message="Project updated failed";
	END IF;
	
	-- Return
	RETURN ('{"message":{"priority":"'||v_priority||'", "text":"'||v_message||'"}}');	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

