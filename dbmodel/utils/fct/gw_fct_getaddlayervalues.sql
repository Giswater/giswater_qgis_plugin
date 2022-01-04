/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getaddlayervalues(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_getaddlayervalues($${"client":{}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text

*/

DECLARE

v_schemaname text;
v_count	integer;
v_project_type text;
v_version text;
v_view_list text;
v_errortext text;
v_result text;
v_result_info json;
v_definition text;
rec record;
v_result_id text;
v_querytext text;
v_feature_list text;
v_param_list text;
rec_fields text;
v_field_array text[];

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;

	
	SELECT context, alias as "layerName", a.id as "tableName" FROM (
	SELECT 'CATALOG' as context, id, alias, (case when orderby is null then 100 else 100+orderby end) as orderby FROM sys_table where context::json->>'level_1' = 'CATALOG'
	UNION
	SELECT 'MAPZONE' as context, id, alias, (case when orderby is null then 200 else 200+orderby end) as orderby FROM sys_table where context::json->>'level_1' = 'MAPZONE'
	UNION
	SELECT 'NETWORK' as context, id, alias, (case when orderby is null then 300 else 300+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'NETWORK' AND context::json->>'level_2' = 'ARC'
	UNION
	SELECT 'NETWORK' as context, 'divider' as id, 'divider' as idval, 399 as orderby
	UNION
	SELECT 'NETWORK' as context, id, alias, (case when orderby is null then 400 else 400+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'NETWORK' AND context::json->>'level_2' = 'NODE'
	UNION
	SELECT 'NETWORK' as context, 'divider' as id, 'divider' as idval, 499 as orderby
	UNION
	SELECT 'NETWORK' as context, id, alias, (case when orderby is null then 500 else 500+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'NETWORK' AND context::json->>'level_2' = 'CONNEC'
	UNION
	SELECT 'NETWORK' as context, 'divider' as id, 'divider' as idval, 599 as orderby
	UNION
	SELECT 'NETWORK' as context, id, alias, (case when orderby is null then 600 else 600+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'NETWORK' AND context::json->>'level_2' = 'GULLY'
	UNION
	SELECT 'O&M' as context, id, alias, (case when orderby is null then 700 else 700+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'MAPZONE'
	UNION
	SELECT 'EPA' as context, id, alias, (case when orderby is null then 800 else 800+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'EPA' AND context::json->>'level_2' = 'CATALOG'
	UNION
	SELECT 'EPA' as context, 'divider' as id, 'divider' as idval, 899 as orderby
	UNION
	SELECT 'EPA' as context, id, alias, (case when orderby is null then 900 else 900+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'EPA' AND context::json->>'level_2' = 'INPUT'
	UNION
	SELECT 'EPA' as context, 'divider' as id, 'divider' as idval, 999 as orderby
	UNION
	SELECT 'EPA' as context, id, alias, (case when orderby is null then 1000 else 1000+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'EPA' AND context::json->>'level_2' = 'RESULT'
	UNION
	SELECT 'PLAN' as context, id, alias, (case when orderby is null then 1100 else 1100+orderby end) as orderby  FROM sys_table where context::json->>'level_1' = 'PLAN')a
	LEFT JOIN config_typevalue c ON c.id = context
	WHERE typevalue = 'sys_table_context'
	ORDER BY c.id, orderby, alias;


	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=195 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 1, '');
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "info":'||v_result_info||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 2776, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;