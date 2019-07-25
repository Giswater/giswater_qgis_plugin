/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2716

--drop function SCHEMA_NAME.gw_fct_admin_manage_child_views(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_child_config(p_data json)
  RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_child_config($${
"client":{"device":9, "infoType":100, "lang":"ES"}, 
"form":{}, 
"feature":{"catFeature":"HYDRANT"},
"data":{"filterFields":{}, "pageInfo":{}, "view_name":"ve_node_hydrant", "feature_type":"node" }}$$);
*/
DECLARE
v_schemaname text;
v_insert_fields text;
v_view_name text;
v_feature_type text;
v_project_type text;
v_version text;
v_config_fields text;
rec record;
BEGIN
	
		-- search path
	SET search_path = "SCHEMA_NAME", public;

		-- get input parameters
	v_schemaname = 'SCHEMA_NAME';

	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1;

	--v_cat_feature = ((p_data ->>'feature')::json->>'catFeature')::text;
	v_view_name = ((p_data ->>'data')::json->>'view_name')::text;
	v_feature_type = lower(((p_data ->>'data')::json->>'feature_type')::text);

	
	EXECUTE 'SELECT DISTINCT string_agg(column_name::text,'' ,'')
	FROM information_schema.columns WHERE table_name=''config_api_form_fields'' and table_schema='''||v_schemaname||'''
	AND column_name!=''id'';'
	INTO v_config_fields;
	
	EXECUTE 'SELECT DISTINCT string_agg(concat(column_name)::text,'' ,'')
	FROM information_schema.columns WHERE table_name=''config_api_form_fields'' and table_schema='''||v_schemaname||'''
	AND column_name!=''id'' AND column_name!=''formname'';'
	INTO v_insert_fields;

	raise notice 'v_insert_fields,%',v_insert_fields;
	raise notice 'v_config_fields,%',v_config_fields;

	FOR rec IN (SELECT * FROM config_api_form_fields WHERE formname=concat('ve_',v_feature_type))
	LOOP
	raise notice 'rec,%',rec;
		EXECUTE 'INSERT INTO config_api_form_fields('||v_config_fields||')
		SELECT '''||v_view_name||''','||v_insert_fields||' FROM config_api_form_fields WHERE id='''||rec.id||''';';
	END LOOP;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
