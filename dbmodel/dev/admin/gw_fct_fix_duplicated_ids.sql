/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_fix_duplicated_ids(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_fix_duplicated_ids(p_data json)
  RETURNS json AS
$BODY$
/*
SELECT SCHEMA_NAME.gw_fct_fix_duplicated_ids($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{},
"feature":{"tableName":"v_edit_connec", "featureType":"CONNEC", "id":["3235", "3239", "3197"]}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"exploitation":"1", "updateValues":"allValues"}}}$$)::text


*/

DECLARE

v_schemaname text;
v_id json;
v_array text;
v_worklayer text;
v_updatevalues text;
v_saveondatabase boolean;
v_elevation numeric;
v_exploitation integer;
v_query text;
rec record;
v_geom text;
v_check_null_elevation record;
v_version text;
v_project_type text;
v_feature_type text;
v_result json;
v_result_info json;
v_result_point json;
v_newid text;
BEGIN
	
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_feature_type := lower(((p_data ->>'feature')::json->>'featureType'))::text;
	v_updatevalues :=  ((p_data ->>'data')::json->>'parameters')::json->>'updateValues'::text;
	v_exploitation := ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';

	IF v_project_type = 'WS' THEN
		INSERT INTO temp_arc (result_id, arc_id, node_1, node_2)
		SELECT 'duplicatedId', node_id AS feature_id, 'node', 'arc' FROM node n JOIN arc a ON a.arc_id=n.node_id
		UNION SELECT 'duplicatedId', node_id, 'node', 'connec' FROM node n JOIN connec c ON c.connec_id=n.node_id
		UNION SELECT 'duplicatedId', a.arc_id, 'arc', 'connec'  FROM arc a JOIN connec c ON c.connec_id=a.arc_id;
	ELSIF v_project_type = 'UD' THEN
		INSERT INTO temp_arc (result_id, arc_id, node_1, node_2)
		SELECT 'duplicatedId',  node_id AS feature_id,  'node', 'arc'  FROM node n JOIN arc a ON a.arc_id=n.node_id
		UNION SELECT 'duplicatedId', node_id, 'node', 'connec'  FROM node n JOIN connec c ON c.connec_id=n.node_id
		UNION SELECT 'duplicatedId', node_id,  'node', 'gully'  FROM node n JOIN gully g ON g.gully_id=n.node_id
		UNION SELECT 'duplicatedId', connec_id,  'connec', 'gully'  FROM connec c JOIN gully g ON g.gully_id=c.connec_id
		UNION SELECT 'duplicatedId', a.arc_id, 'arc', 'connec' FROM arc a JOIN connec c ON c.connec_id=a.arc_id	
		UNION SELECT 'duplicatedId', a.arc_id, 'arc', 'gully' FROM arc a JOIN gully g ON g.gully_id=a.arc_id;
	END IF;

	FOR rec in (SELECT * FROM temp_arc WHERE result_id='duplicatedId') LOOP
		v_newid=(SELECT nextval('urn_id_seq'));
		EXECUTE 'UPDATE '||rec.node_2||' SET '||rec.node_2||'_id = '||quote_literal(v_newid)||' WHERE '||rec.node_2||'_id = '||quote_literal(rec.arc_id)||';';
	END LOOP;
		--    Control nulls
		v_result_info := COALESCE(v_result_info, '{}'); 
		v_result_point := COALESCE(v_result_point, '{}'); 

		--  Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"point":'||v_result_point||
				'}}'||
		    '}')::json,2760, null, null, null);


	RETURN null;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


