/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2580

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getinfofromcoordinates(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromcoordinates(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{},
		"feature":{},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["ve_node","ve_arc"],
			"addSchema":"ud",
			"infoType":"full",
			"projecRole":"role_admin",
			"toolBar":"basic",
			"coordinates":{"epsg":25831, "xcoord":419204.96, "ycoord":4576509.27, "zoomRatio":1000}}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{},
		"feature":{},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["ve_node","ve_arc"],
			"toolBar":"epa",
			"coordinates":{"epsg":25831, "xcoord":419204.96, "ycoord":4576509.27, "zoomRatio":1000}}}$$)

 SELECT gw_fct_getinfofromcoordinates($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "editable":"false", "rolePermissions":"None", "activeLayer":"", "visibleLayer":["v_edit_arc", "v_edit_dma", "v_edit_connec", "v_edit_element", "v_edit_node", "v_edit_link", "v_edit_sector", "v_edit_exploitation"], "addSchema":"None", "infoType":"None", "projecRole":"None", "coordinates":{"xcoord":418911.7807826943,"ycoord":4576796.706092382, "zoomRatio":5804.613871393841}}}$$);

 SELECT gw_fct_getinfofromcoordinates($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"None", "activeLayer":"", "visibleLayer":["v_edit_arc", "v_edit_dma", "v_edit_connec", "v_edit_element", "v_edit_node", "v_edit_link", "v_edit_sector", "v_edit_exploitation"], "addSchema":"None", "infoType":"None", "projecRole":"None", "coordinates":{"xcoord":418894.6048028714,"ycoord":4576612.785781575, "zoomRatio":2105.7904524867854}}}$$);

*/

DECLARE

v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_activelayer text;
v_visiblelayer text;
v_zoomratio double precision; 
v_device integer;  
v_point geometry;
v_sensibility float;
v_sensibility_f float;
v_id varchar;
v_layer record;
v_sql text;
v_sql2 text;
v_iseditable text;
v_return json;
v_idname text;
v_schemaname text;
v_count int2=0;
v_geometrytype text;
v_version text;
v_the_geom text;
v_config_layer text;
v_toolbar text;
v_role text;
v_errcontext text;
v_addschema text; 
v_projectrole text; 
v_flag boolean = false;
v_infotype text;
v_data json;


BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get system parameters
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'  INTO v_version;

	-- get input parameters
	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version LIMIT 1);
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_toolbar := ((p_data ->> 'data')::json->> 'toolBar');
	v_role = (p_data ->> 'data')::json->> 'rolePermissions';
	v_projectrole = (p_data ->> 'data')::json->> 'projecRole';
	v_addschema = (p_data ->> 'data')::json->> 'addSchema';
	v_infotype = (p_data ->> 'data')::json->> 'infoType';
	v_iseditable = (p_data ->> 'data')::json->> 'editable';

	
	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null'
		THEN v_addschema = null; 
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"3132", "function":"2580","debug_msg":null}}$$)';
			-- todo: send message to response
		END IF;
	END IF;
		
	v_activelayer := (p_data ->> 'data')::json->> 'activeLayer';
	v_visiblelayer := (p_data ->> 'data')::json->> 'visibleLayer';

	--  Harmonize v_visiblelayer
	v_visiblelayer = concat('{',substring((v_visiblelayer) from 2 for LENGTH(v_visiblelayer)));
	v_visiblelayer = concat('}',substring(reverse(v_visiblelayer) from 2 for LENGTH(v_visiblelayer)));
	v_visiblelayer := reverse(v_visiblelayer);

	-- Sensibility factor
	IF v_device = 1 OR v_device = 2 THEN
		EXECUTE 'SELECT (value::json->>''mobile'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomratio * 10 * v_sensibility_f);
		v_config_layer='config_web_layer';
		
	ELSIF  v_device = 3 THEN
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;     
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomratio * 10 * v_sensibility_f);
		v_config_layer='config_web_layer';

	ELSIF  v_device = 4 THEN
		EXECUTE 'SELECT (value::json->>''desktop'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;

		--v_sensibility_f = 1;

		-- ESCALE 1:5000 as base sensibility
		v_sensibility = ((v_zoomratio/5000) * 10 * v_sensibility_f);
		v_config_layer='config_info_layer';

	END IF;

	-- Make point
	SELECT ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_epsg) INTO v_point;
	
	-- Get feature
	v_sql := 'SELECT layer_id, orderby , addparam->>''geomType'' as geomtype FROM  '||quote_ident(v_config_layer)||' WHERE layer_id = any('||quote_literal(v_visiblelayer)||'::text[]) UNION 
              SELECT DISTINCT ON (layer_id) layer_id, orderby+100, addparam->>''geomType'' as geomtype FROM  '||quote_ident(v_config_layer)||' JOIN cat_feature ON parent_layer=layer_id 
              WHERE child_layer = any('||quote_literal(v_visiblelayer)||'::text[]) ORDER BY orderby';

	FOR v_layer IN EXECUTE v_sql     
	LOOP
		PERFORM gw_fct_debug(concat('{"data":{"msg":"Layer", "variables":"',v_layer,'"}}')::json);

		-- Indentify geometry type   
		v_count=v_count+1;

		--    Get id column
		EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
		INTO v_idname
		USING v_layer.layer_id;
            
		--    For views it suposse pk is the first column
		IF v_idname IS NULL THEN
			EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
			INTO v_idname
			USING v_layer.layer_id, v_schemaname;

		END IF;

		--     Get geometry_column
		EXECUTE 'SELECT attname FROM pg_attribute a        
                JOIN pg_class t on a.attrelid = t.oid
                JOIN pg_namespace s on t.relnamespace = s.oid
                WHERE a.attnum > 0 
                AND NOT a.attisdropped
                AND t.relname = $1
                AND s.nspname = $2
                AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
                ORDER BY a.attnum' 
	        INTO v_the_geom
	        USING v_layer.layer_id, v_schemaname;
	        
		IF v_layer.geomtype = 'polygon' THEN

			--  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)        
			EXECUTE 'SELECT '||quote_ident(v_idname)||' FROM '||quote_ident(v_layer.layer_id)||' WHERE st_dwithin ($1, '||quote_ident(v_layer.layer_id)||'.'||quote_ident(v_the_geom)||', $2) 
			ORDER BY  ST_area('||v_layer.layer_id||'.'||v_the_geom||') asc LIMIT 1'
			INTO v_id
			USING v_point, v_sensibility;
		ELSE

			--  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
			EXECUTE 'SELECT '||quote_ident(v_idname)||' FROM '||quote_ident(v_layer.layer_id)||' WHERE st_dwithin ($1, '||quote_ident(v_layer.layer_id)||'.'||quote_ident(v_the_geom)||', $2) 
			ORDER BY  ST_Distance('||v_layer.layer_id||'.'||v_the_geom||', $1) asc LIMIT 1'
			INTO v_id
			USING v_point, v_sensibility;
		END IF;      

		IF v_id IS NOT NULL THEN 
			v_flag = true;
			exit;
		ELSE 
		-- RAISE NOTICE 'Searching for layer....loop number: % layer: % ,idname: %, id: %', v_count, v_layer, v_idname, v_id;    
		END IF;
	END LOOP;

	IF v_iseditable THEN

		-- Get editability of layer
		EXECUTE 'SELECT (CASE WHEN is_editable=TRUE AND layer_id = any('||quote_literal(v_visiblelayer)||'::text[]) THEN ''True'' ELSE ''False'' END) 
		FROM  '||quote_ident(v_config_layer)||' WHERE layer_id='||quote_literal(v_layer.layer_id)||';'
			INTO v_iseditable;
	END IF;

	-- looking for additional schema 
	IF v_addschema IS NOT NULL AND v_addschema != v_schemaname AND v_flag IS FALSE THEN

		v_data = gw_fct_json_object_set_key((p_data->>'data')::json, 'editable', 'false'::text);
		p_data = gw_fct_json_object_set_key(p_data, 'data', v_data::text);
		
		EXECUTE 'SET search_path = '||v_addschema||', public';
		SELECT gw_fct_getinfofromcoordinates(p_data) INTO v_return;
		SET search_path = 'SCHEMA_NAME', public;
		RETURN v_return;
	END IF;
	
	-- Control NULL's
	IF v_id IS NULL THEN
		RETURN ('{"status":"Accepted", "message":{"level":0, "text":"No feature found"}, "results":0, "version":'|| v_version 
		||', "formTabs":[] , "tableName":"", "featureType": "","idName": "", "geometry":"", "linkPath":"", "editData":[] }')::json;
	END IF;

	IF v_toolbar IS NULL THEN
		v_toolbar = 'basic';
	END IF;
    
	PERFORM gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"',v_toolbar,'"}}')::json);
			
	--   Call and return gw_fct_getinfofromid
	RETURN gw_fct_json_create_return(gw_fct_getinfofromid(concat('{"client":',(p_data->>'client'),',"form":{"editable":"',v_iseditable, 
	'"},"feature":{"tableName":"',v_layer.layer_id,'","id":"',v_id,'"},"data":{"toolBar":"'||v_toolbar||'","rolePermissions":"', v_role,'"}}')::json), 2580);
	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;  
	RETURN ('{"status":"Failed", "SQLERR":' || to_json(SQLERRM) || ',"SQLCONTEXT":' || to_json(v_errcontext) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;