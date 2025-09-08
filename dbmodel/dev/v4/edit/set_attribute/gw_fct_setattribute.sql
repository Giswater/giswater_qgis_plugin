/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


-- DROP FUNCTION SCHEMA_NAME.gw_fct_setattribute(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setattribute(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/* Example:

SELECT gw_fct_setattribute($${"client":{"device":4, "lang":"", "version":"4.2.2", "infoType":1, "epsg":25831}, "form":{}, 
"feature":{"id":["143", "163", "164", "165"]}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"1", "arccat_id":"SIPHON-CC100", 
"workcat_id":"work1", "datasource":"hols", "builtdate":"2025/09/10"}, "aux_params":null}}$$);


*/

DECLARE

-- p_data
v_expl_id INTEGER;
v_arccat_id TEXT;
v_workcat_id TEXT;
v_datasource integer;
v_builtdate date;
v_id JSONB;
v_selectionmode TEXT;

v_id_list TEXT;
v_count integer;

-- return
v_message JSON;
v_version TEXT;
v_Result JSON;
v_Result_info JSON;


v_sql TEXT;
BEGIN

    SET search_path = "SCHEMA_NAME", public;

	v_expl_id := p_data->'data'->'parameters'->>'expl_id';
	v_arccat_id := p_data->'data'->'parameters'->>'arccat_id';
	v_workcat_id := p_data->'data'->'parameters'->>'workcat_id';
	v_datasource := p_data->'data'->'parameters'->>'datasource';
	v_builtdate := p_data->'data'->'parameters'->>'builtdate';
  	v_selectionmode := p_data->'data'->'selectionMode';
	v_id := p_data->'feature'->'id';

	v_message := (SELECT json_build_object('level', 1, 'text', error_message) FROM sys_message WHERE id = 3700);
	v_version := (SELECT giswater FROM sys_version ORDER BY id ASC LIMIT 1);

	select string_agg(a,',') into v_id_list from jsonb_array_elements_text(v_id) a;

	-- wholeSelection disabled
	IF v_selectionmode = '"wholeSelection"' THEN -- OPTION NOT enabled
	
		v_message := (SELECT json_build_object('level', 1, 'text', error_message) FROM sys_message WHERE id = 4352);
	
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
 		"data":{"message":"4352", "function":"3514", "fid":"670", "cur_user":"current_user", "is_process":false}}$$)';

	
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":'||v_message||', "version":"'||v_version||'"'||
		 ',"body":{"form":{}'||
		 ',"data":{ "info":{}}}'||
		'}')::json, 3514, null, null, null);
	
	END IF;

	-- update data
	EXECUTE '
	    UPDATE ve_arc
	    SET expl_id    = $1,
	        arccat_id  = $2,
	        workcat_id = $3,
	        datasource = $4,
	        builtdate  = $5
	    WHERE arc_id = ANY(string_to_array($6, '','')::int[])'
	USING v_expl_id, v_arccat_id, v_workcat_id, v_datasource, v_builtdate, v_id_list;

	GET DIAGNOSTICS v_count = ROW_COUNT;


	-- return
	execute 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
    "data":{"message":"4350", "function":"3514", "fid":"670", "cur_user":"current_user", "is_process":false, "parameters":{"v_count":'||v_count||'}}}$$)'; 

   
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=670 AND tstamp = now() order by id) row;

	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');



	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
  		     ',"data":{ "info":'||v_result_info||'}}'||
  	    '}')::json, 3514, null, null, null);

    

END;
$function$
;

-- Permissions

ALTER FUNCTION SCHEMA_NAME.gw_fct_setattribute(json) OWNER TO postgres;
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_setattribute(json) TO postgres;
