/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3030
-- DROP FUNCTION SCHEMA_NAME.gw_fct_debugsql(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_project_layers(p_data json)
  RETURNS json AS
$BODY$
/*EXAMPLE:

*/

DECLARE
v_version text;
v_status text;
v_level integer = 1;
v_message text;
v_querystring text;
v_funcname text;
v_flag int;
v_vars json;
v_records json;
v_key text;
v_value text;
v_msgerr text;
v_error_context text;
v_error boolean = False;

v_project_type text;
project_type_id integer;
v_layers text[];
v_result_info json;
v_fields_array json;
item json;
v_final json;

BEGIN
	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	v_project_type := (p_data ->> 'data')::json->> 'project_type';

	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	SELECT id INTO project_type_id FROM config_typevalue WHERE typevalue = 'project_type' AND idval = v_project_type;


	SELECT array_to_json((WITH geomtable AS (SELECT column_name, table_name from information_schema.columns WHERE udt_name='geometry' and table_schema in ('SCHEMA_NAME', 'am')),
	idtable AS (SELECT column_name, table_name from information_schema.columns WHERE ordinal_position=1 and table_schema in ('SCHEMA_NAME', 'am'))
	SELECT array_agg(row_to_json(d)) FROM (SELECT project_template AS template, context, alias as "layerName", st.id as "tableName",
	CASE WHEN c.column_name IS NULL THEN 'None'
	WHEN st.addparam->>'geom' IS NOT NULL THEN st.addparam->>'geom'
	ELSE c.column_name END AS "geomField",
	CASE WHEN st.addparam->>'pkey' IS NULL THEN i.column_name
	ELSE st.addparam->>'pkey' END AS "tableId"
	FROM sys_table st
	join config_typevalue ct ON ct.id= context
	left join geomtable c ON st.id =c.table_name
	left join idtable i ON st.id =i.table_name
	WHERE typevalue = 'sys_table_context' and (c.column_name IS null or c.column_name != 'link_the_geom') and project_template->'template' @> to_jsonb(ARRAY[project_type_id])
	ORDER BY json_extract_path_text(ct.addparam,'orderBy')::integer, orderby, alias)d)) into v_final;


	v_result_info := v_final;
	
	RETURN ('{"status":"Accepted", "version":"'||v_version||'"'||
   		',"body":{"form":{}'||
       		',"data":{"layers":'||v_result_info||' }}'||
        		'}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
