-- Function: SCHEMA_NAME.gw_fct_getaddlayervalues(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getaddlayervalues($${"client":{}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "parameters":{}}}$$)::text

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
v_record record;
v_fields json;
v_fields_array json[];

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	v_schemaname = 'SCHEMA_NAME';
	
	-- select config values
	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version order by id desc limit 1;
	
	SELECT array_agg(row_to_json(d)) FROM (SELECT context, alias as "layerName", st.id as "tableName",CASE WHEN c.column_name IS NULL THEN 'None' ELSE c.column_name END AS "geomField", i.column_name as "tableId", st.style_id FROM sys_table st
	join config_typevalue ct ON ct.id= context
	left join information_schema.columns c on st.id =c.table_name and udt_name='geometry' and c.table_schema='SCHEMA_NAME'
	left join information_schema.columns i on st.id =i.table_name and i.ordinal_position=1 and i.table_schema='SCHEMA_NAME'
	WHERE typevalue = 'sys_table_context'
	ORDER BY  json_extract_path_text(camelstyle::json,'orderBy')::integer,orderby, alias)d into v_fields_array;

	-- get results
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=195 order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 4, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 3, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 2, '');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (195, v_result_id, 1, '');

	v_fields := array_to_json(v_fields_array);
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
			 ',"body":{"form":{}'||
			 ',"data":{ "fields":'||v_fields||','||
				'"point":{"geometryType":"", "values":[]}'||','||
				'"line":{"geometryType":"", "values":[]}'||','||
				'"polygon":{"geometryType":"", "values":[]}'||
			   '}}'||
		'}')::json, 2776, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(json)
  OWNER TO role_admin;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(json) TO public;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(json) TO role_admin;
GRANT EXECUTE ON FUNCTION SCHEMA_NAME.gw_fct_getaddlayervalues(json) TO role_basic;
