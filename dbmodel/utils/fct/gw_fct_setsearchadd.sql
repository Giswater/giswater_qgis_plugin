/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2620

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setsearch_add(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setsearchadd(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT "SCHEMA_NAME".gw_fct_setsearchadd($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{"tabName":"address"}, "feature":{}, 
		"data":{"filterFields":{}, "pageInfo":{}, "add_muni":{"id":"1", "name":"Sant Boi del Llobregat"}, 
		"add_street":{"text":"Calle de Salvador Seguí"}, "add_postnumber":{"text":"3"}}}$$)

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"address"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "add_muni":{"id":"8141", "name":"Navas"}, "add_street":{"text":"Carrer de Jacint Verdaguer"}, "addSchema":"None"}}$$);

SELECT gw_fct_setsearchadd($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"address"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "add_muni":{"id":"8141", "name":"Navas"}, "add_street":{"text":"Carrer de Jacint Verdaguer"}, "add_postnumber":{"text":"22"}}}$$);


SELECT array_to_json(array_agg(row_to_json(a))) 
			FROM (

			SELECT ext_streetaxis.muni_id, ext_address.postnumber as display_name, st_x (ext_address.
			the_geom) as sys_x
			,st_y (ext_address.the_geom) as sys_y, (SELECT concat('EPSG:',epsg) FROM sys_version ORDER BY id DESC LIMIT 1) AS srid
			FROM ext_address
			JOIN ext_streetaxis ON ext_streetaxis.id = 
			ext_address.streetaxis_id
			WHERE ext_streetaxis.text = 'Carrer de Jacint Verdaguer'
			AND  ext_streetaxis.muni_id = 8141
			AND ext_address.postnumber ILIKE '%22%' 
			ORDER BY regexp_replace(postnumber,'[^0-9]+','','g')::integer LIMIT 10
			)a	
*/

DECLARE

v_response json;
v_idarg varchar;
v_searchtext varchar;
v_tab varchar;
v_editable varchar;
v_version text;
v_projecttype character varying;
 
-- Street
v_street_layer varchar;
v_street_id_field varchar;
v_street_search_field varchar;
v_street_display_field varchar;
v_street_muni_id_field varchar;
v_street_geom_id_field varchar;

-- address
v_address_layer varchar;
v_address_id_field varchar;
v_address_display_field varchar;
v_address_street_id_field varchar;
v_address_geom_id_field varchar;
v_muni integer;
v_querytext text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	--  get project type
	SELECT project_type INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	--  Get tab
	v_tab := ((p_data->>'form')::json)->>'tabName';

	-- address
	IF v_tab = 'address' THEN

		-- Parameters of the street layer
		SELECT ((value::json)->>'sys_table_id') INTO v_street_layer FROM config_param_system WHERE parameter='basic_search_street';
		SELECT ((value::json)->>'sys_id_field') INTO v_street_id_field FROM config_param_system WHERE parameter='basic_search_street';
		SELECT ((value::json)->>'sys_search_field') INTO v_street_search_field FROM config_param_system WHERE parameter='basic_search_street';
		SELECT ((value::json)->>'sys_display_field') INTO v_street_display_field FROM config_param_system WHERE parameter='basic_search_street';
		SELECT ((value::json)->>'sys_parent_field') INTO v_street_muni_id_field FROM config_param_system WHERE parameter='basic_search_street';
		SELECT ((value::json)->>'sys_geom_field') INTO v_street_geom_id_field FROM config_param_system WHERE parameter='basic_search_street';

		-- Parameters of the postnumber layer
		SELECT ((value::json)->>'sys_table_id') INTO v_address_layer FROM config_param_system WHERE parameter='basic_search_postnumber';
		SELECT ((value::json)->>'sys_id_field') INTO v_address_id_field FROM config_param_system WHERE parameter='basic_search_postnumber';
		SELECT ((value::json)->>'sys_search_field') INTO v_address_display_field FROM config_param_system WHERE parameter='basic_search_postnumber';
		SELECT ((value::json)->>'sys_parent_field') INTO v_address_street_id_field FROM config_param_system WHERE parameter='basic_search_postnumber';
		SELECT ((value::json)->>'sys_geom_field') INTO v_address_geom_id_field FROM config_param_system WHERE parameter='basic_search_postnumber';

		--Text to search
		v_muni := ((((p_data->>'data')::json)->>'add_muni')::json->>'id')::integer;
		v_idarg := (((p_data->>'data')::json)->>'add_street')::json->>'text';
		v_editable := (((p_data->>'data')::json)->>'add_postnumber')::json->>'text';
		v_searchtext := concat('%', v_editable ,'%');
		raise notice 'name_arg %', v_idarg;
		raise notice 'v_searchtext % % % % % % % % % % % % %', v_searchtext, v_address_layer, v_address_display_field, v_address_layer, v_address_geom_id_field, 
		v_street_layer, v_street_id_field, v_address_street_id_field, v_street_display_field, v_idarg, v_street_muni_id_field, v_muni, v_searchtext;

		-- Get address
		v_querytext =  'SELECT array_to_json(array_agg(row_to_json(a))) 
			FROM (SELECT '||quote_ident(v_address_layer)||'.'||quote_ident(v_address_display_field)||' as display_name, st_x ('||quote_ident(v_address_layer)||'.
			'||quote_ident(v_address_geom_id_field)||') as sys_x
			,st_y ('||quote_ident(v_address_layer)||'.'||quote_ident(v_address_geom_id_field)||') as sys_y, (SELECT concat(''EPSG:'',epsg) FROM sys_version ORDER BY id DESC LIMIT 1) AS srid
			FROM '||quote_ident(v_address_layer)||'
			JOIN '||quote_ident(v_street_layer)||' ON '||quote_ident(v_street_layer)||'.'||quote_ident(v_street_id_field)||' = 
			'||quote_ident(v_address_layer)||'.'||quote_ident(v_address_street_id_field) ||'
			WHERE '||quote_ident(v_street_layer)||'.'||quote_ident(v_street_display_field)||' = '||quote_literal(v_idarg)||'
			AND  '||quote_ident(v_street_layer)||'.muni_id = '||(v_muni)||'
			AND '||quote_ident(v_address_layer)||'.'||quote_ident(v_address_display_field)||' ILIKE '||quote_literal(v_searchtext)||' 
			ORDER BY regexp_replace(postnumber,''[^0-9]+'','''',''g'')::integer LIMIT 10)a';

		raise notice 'v_querytext %', v_querytext;

		EXECUTE v_querytext INTO v_response;
	END IF;

	-- Control NULL's
	v_response := COALESCE(v_response, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted"' ||
		', "version":"'|| v_version ||'"'||
		', "data":' || v_response ||    
		'}')::json, 2620, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;