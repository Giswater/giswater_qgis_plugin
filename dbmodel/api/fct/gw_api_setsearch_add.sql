/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2620

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_setsearch_add(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_api_setsearch_add($${
		"client":{"device":9, "infoType":100, "lang":"ES"},
		"form":{"tabName": "address"},
		"data":{"add_street":{"text":"Calle d'Antoni Gaudí"}, "add_postnumber":{"text":"8"}}
		}$$)
SELECT "SCHEMA_NAME".gw_api_setsearch_add($${
		"client":{"device":9, "infoType":100, "lang":"ES"}, 
		"form":{"tabName":"address"}, "feature":{}, 
		"data":{"filterFields":{}, "pageInfo":{}, "add_muni":{"id":"1", "name":"Sant Boi del Llóbregat"}, 
		"add_street":{"text":"Calle de Salvador Seguí"}, "add_postnumber":{"text":"32"}}}$$)
*/

DECLARE

--    Variables
    v_response json;
    v_idarg varchar;
    v_searchtext varchar;
    v_tab varchar;
    v_editable varchar;
    v_apiversion json;
    v_projecttype character varying;
     
    -- Street
    v_street_layer varchar;
    v_street_id_field varchar;
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



BEGIN

--    Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--      get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;

--     get project type
    SELECT wsoftware INTO v_projecttype FROM version LIMIT 1;

--    Get tab
    v_tab := ((p_data->>'form')::json)->>'tabName';


-- address
---------
IF v_tab = 'address' THEN

	-- Parameters of the street layer
	SELECT ((value::json)->>'sys_table_id') INTO v_street_layer FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_street';
	SELECT ((value::json)->>'sys_id_field') INTO v_street_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_street';
	SELECT ((value::json)->>'sys_search_field') INTO v_street_display_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_street';
	SELECT ((value::json)->>'sys_parent_field') INTO v_street_muni_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_street';
	SELECT ((value::json)->>'sys_geom_field') INTO v_street_geom_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_street';

	-- Parameters of the postnumber layer
	SELECT ((value::json)->>'sys_table_id') INTO v_address_layer FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_postnumber';
	SELECT ((value::json)->>'sys_id_field') INTO v_address_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_postnumber';
	SELECT ((value::json)->>'sys_search_field') INTO v_address_display_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_postnumber';
	SELECT ((value::json)->>'sys_parent_field') INTO v_address_street_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_postnumber';
	SELECT ((value::json)->>'sys_geom_field') INTO v_address_geom_id_field FROM SCHEMA_NAME.config_param_system WHERE parameter='api_search_postnumber';


	--Text to search
	v_muni := ((((p_data->>'data')::json)->>'add_muni')::json->>'id')::integer;
	v_idarg := (((p_data->>'data')::json)->>'add_street')::json->>'text';
	v_editable := (((p_data->>'data')::json)->>'add_postnumber')::json->>'text';
	v_searchtext := concat('%', v_editable ,'%');
	raise notice 'name_arg %', v_idarg;
	--raise notice 'v_searchtext %', v_searchtext;


	-- Get address
	EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) 
		FROM (SELECT '||v_address_layer||'.'||v_address_display_field||' as display_name, st_x ('||v_address_layer||'.'||v_address_geom_id_field||') as sys_x
		,st_y ('||v_address_layer||'.'||v_address_geom_id_field||') as sys_y, (SELECT concat(''EPSG:'',epsg) FROM version LIMIT 1) AS srid
		FROM '||v_address_layer||'
		JOIN '||v_street_layer||' ON '||v_street_layer||'.'||v_street_id_field||' = '||v_address_layer||'.'||v_address_street_id_field ||'
		WHERE '||v_street_layer||'.'||v_street_display_field||' = $$'||v_idarg||'$$
		AND '||v_street_layer||'.'||v_street_muni_id_field||' = '||v_muni||'
		AND '||v_address_layer||'.'||v_address_display_field||' ILIKE '''||v_searchtext||''' LIMIT 10 
		)a'
		INTO v_response;

END IF;

  --    Control NULL's
    v_response := COALESCE(v_response, '{}');

--    Return
    RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| v_apiversion ||
        ', "data":' || v_response ||    
        '}')::json;

--    Exception handling
    --EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


