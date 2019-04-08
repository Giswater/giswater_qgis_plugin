/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2536

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_utils_csv2pg_import_epa_rpt(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epa_rpt(p_resultname text)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epa_rpt('demo1')
*/

DECLARE
	project_type_aux text;
	schemas_array name[];
	v_result json;
	v_result_info 	json;
	v_result_point	json;
	v_result_line 	json;
	v_version	json;
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

   	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
	
	IF project_type_aux='WS' THEN
		PERFORM gw_fct_utils_csv2pg_import_epanet_rpt(p_resultname, null);
	
	ELSE
		PERFORM gw_fct_utils_csv2pg_import_swmm_rpt(p_resultname, null);
	
	END IF;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=40 AND result_id=p_resultname order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	--points
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript, the_geom FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=40 AND result_id=p_resultname) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "values":',v_result, '}');

	--lines
	v_result = null;
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom FROM anl_arc WHERE cur_user="current_user"() AND (fprocesscat_id=40) AND result_id=p_resultname) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "values":',v_result, '}');


	--Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 	

--  Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"This is a test message"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
		       '}'||
	    '}')::json;
	
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;