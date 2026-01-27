/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2580

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getinfofromcoordinates(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfofromcoordinates(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE},
		"form":{},
		"feature":{},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["ve_node","ve_arc"],
			"addSchema":"ud",
			"infoType":"full",
			"projecRole":"role_admin",
			"toolBar":"basic",
			"coordinates":{"epsg":SRID_VALUE, "xcoord":419204.96, "ycoord":4576509.27, "zoomRatio":1000}}}$$)
SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE},
		"form":{},
		"feature":{},
		"data":{"activeLayer":"ve_node",
			"visibleLayer":["ve_node","ve_arc"],
			"toolBar":"epa",
			"coordinates":{"epsg":SRID_VALUE, "xcoord":419204.96, "ycoord":4576509.27, "zoomRatio":1000}}}$$)

SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE},
		"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"", "featureDialog":["PIPE"],
		"visibleLayer":["v_om_mincut_valve", "v_om_mincut_arc", "ve_dma", "ve_node", "ve_node", "ve_arc", "ve_connec", "ve_link", "ve_pol_fountain", "ve_pol_register", "ve_pol_tank", "ve_inp_connec",
		"ve_inp_inlet", "ve_inp_junction", "ve_inp_pipe", "ve_inp_pump", "ve_inp_reservoir", "ve_inp_shortpipe", "ve_inp_tank", "ve_inp_valve", "ve_inp_virtualvalve"],
		"mainSchema":"NULL", "addSchema":"NULL", "infoType":"full", "projecRole":"role_admin", "epsg":SRID_VALUE, "coordinates":{"xcoord":418930.4280605118,"ycoord":4576587.621989262, "zoomRatio":1341.590797402754}}}$$);

 SELECT gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "editable":"false", "activeLayer":"",
		"visibleLayer":["ve_arc", "ve_dma", "ve_connec", "ve_element", "ve_node", "ve_link", "ve_sector", "ve_exploitation"], "addSchema":"None", "infoType":"None", "projecRole":"None",
		"featureDialog":["VALVE"],
		"coordinates":{"xcoord":418911.7807826943,"ycoord":4576796.706092382, "zoomRatio":5804.613871393841}}}$$);


 SELECT gw_fct_getinfofromcoordinates($${
		"client":{"device":4, "infoType":1, "lang":"ES"},
		"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "activeLayer":"",
		"visibleLayer":["ve_arc", "ve_dma", "ve_connec", "ve_element", "ve_node", "ve_link", "ve_sector", "ve_exploitation"],
		"addSchema":"None", "infoType":"None", "projecRole":"None", "coordinates":{"xcoord":418894.6048028714,"ycoord":4576612.785781575, "zoomRatio":2105.7904524867854}}}$$);
*/

DECLARE

v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_activelayer text;
v_visiblelayer text;
v_zoomratio double precision;
v_device integer;
v_point public.geometry;
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
v_errcontext text;
v_addschema text;
v_projectrole text;
v_flag boolean = false;
v_infotype text;
v_data json;
v_querystring text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_featuredialog text;
v_client_epsg integer;
v_parent text;

BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';

	--  get system parameters
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- get input parameters
	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';
	v_toolbar := ((p_data ->> 'data')::json->> 'toolBar');
	v_projectrole = (p_data ->> 'data')::json->> 'projecRole';
	v_addschema = (p_data ->> 'data')::json->> 'addSchema';
	v_infotype = (p_data ->> 'client')::json->> 'infoType';
	v_iseditable = (p_data ->> 'data')::json->> 'editable';
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;


	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null' OR v_addschema IS NULL THEN
		v_addschema = null;
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"3132", "function":"2580","parameters":null, "is_process":true}}$$)';
			-- todo: send message to response
		END IF;
	END IF;

	v_activelayer := (p_data ->> 'data')::json->> 'activeLayer';
	v_featuredialog := coalesce((p_data ->> 'data')::json->> 'featureDialog','[]');
	v_visiblelayer := (p_data ->> 'data')::json->> 'visibleLayers';

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

	ELSIF  v_device = 3 THEN
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomratio * 10 * v_sensibility_f);

	ELSIF  v_device IN (4, 5) THEN
		EXECUTE 'SELECT (value::json->>''desktop'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;

		-- ESCALE 1:5000 as base sensibility
		v_sensibility = ((v_zoomratio/5000) * 10 * v_sensibility_f);

	END IF;

	v_config_layer='config_info_layer';


	-- Make point
	SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

	-- Get feature
	v_sql = concat('SELECT layer_id, 0 as orderby, a.addparam->>''geomType'' as geomtype FROM  ',quote_ident(v_config_layer),' a WHERE layer_id = ',quote_literal(v_activelayer),'::text 
		AND (a.addparam->>''forceWhenActive'')::boolean IS TRUE
		UNION
		SELECT layer_id, orderby , b.addparam->>''geomType'' as geomtype FROM  ',quote_ident(v_config_layer),' b WHERE layer_id = any(',quote_literal(v_visiblelayer),'::text[]) 
		UNION 
		SELECT DISTINCT ON (layer_id) layer_id, orderby+100, c.addparam->>''geomType'' as geomtype FROM  ',quote_ident(v_config_layer),' c JOIN cat_feature ON parent_layer=layer_id 
		WHERE child_layer = any(',quote_literal(v_visiblelayer),'::text[]) ORDER BY orderby');
	v_debug_vars := json_build_object('v_config_layer', v_config_layer, 'v_activelayer', v_activelayer, 'v_visiblelayer', v_visiblelayer);
	v_debug := json_build_object('querystring', v_sql, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 10);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

	FOR v_layer IN EXECUTE v_sql
	LOOP
		PERFORM gw_fct_debug(concat('{"data":{"msg":"Layer", "variables":"',v_layer,'"}}')::json);

		-- Indentify geometry type
		v_count=v_count+1;

		--    Get id column
		v_querystring = concat('SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = ''',v_layer.layer_id,'''::regclass AND i.indisprimary');
		v_debug_vars := json_build_object('layer_id', v_layer.layer_id);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 20);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

		EXECUTE v_querystring INTO v_idname;

		--    For views it suposse pk is the first column
		IF v_idname IS NULL THEN
			v_querystring = concat('SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = ''',v_layer.layer_id,''' 
			AND s.nspname = ''',v_schemaname,'''
			ORDER BY a.attnum LIMIT 1');
			v_debug_vars := json_build_object('layer_id', v_layer.layer_id, 'v_schemaname', v_schemaname);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 30);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

			EXECUTE v_querystring INTO v_idname;

		END IF;

		--     Get geometry_column
		v_querystring = concat('SELECT attname FROM pg_attribute a        
                JOIN pg_class t on a.attrelid = t.oid
                JOIN pg_namespace s on t.relnamespace = s.oid
                WHERE a.attnum > 0 
                AND NOT a.attisdropped
                AND t.relname = ',quote_nullable(v_layer.layer_id),'
                AND s.nspname = ',quote_nullable(v_schemaname),'
                AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
                ORDER BY a.attnum');
		v_debug_vars := json_build_object('layer_id', v_layer.layer_id, 'v_schemaname', v_schemaname);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 40);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

		EXECUTE v_querystring INTO v_the_geom;
	
		-- get table parent
		select lower(feature_type) into v_parent from cat_feature where id = v_layer.layer_id ;
		
		if v_parent is null then -- look for parent
			select lower(feature_type) into v_parent from cat_feature where parent_layer  = v_layer.layer_id limit 1;
		end if;
	        
		IF v_layer.geomtype = 'polygon' THEN

			--  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)        
			v_querystring = concat('SELECT ',quote_ident(v_idname),' FROM ',quote_ident(v_layer.layer_id),' WHERE st_dwithin (''',v_point,''', ',quote_ident(v_layer.layer_id),'.',quote_ident(v_the_geom),', ',v_sensibility,') 
			ORDER BY  ST_area(',v_layer.layer_id,'.',v_the_geom,') asc LIMIT 1');
			v_debug_vars := json_build_object('v_idname', v_idname, 'layer_id', v_layer.layer_id, 'v_point', v_point, 'v_the_geom', v_the_geom, 'v_sensibility', v_sensibility);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 50);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			
			EXECUTE v_querystring INTO v_id;
		
		ELSIF v_layer.layer_id ILIKE '%visit' THEN
			--  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
			v_querystring = concat('SELECT ',quote_ident(v_idname),' FROM ',quote_ident(v_layer.layer_id),' WHERE st_dwithin (''',v_point,''', ',quote_ident(v_layer.layer_id),'.',quote_ident(v_the_geom),', ',v_sensibility,') 
			ORDER BY ST_Distance(',v_layer.layer_id,'.',v_the_geom,', ''',v_point,''') asc LIMIT 1');
			v_debug_vars := json_build_object('v_idname', v_idname, 'layer_id', v_layer.layer_id, 'v_point', v_point, 'v_the_geom', v_the_geom, 'v_sensibility', v_sensibility);
			v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 60);
			SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			
			EXECUTE v_querystring INTO v_id;
		else
			--  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
			if v_parent is null then
				v_querystring = concat('SELECT ',quote_ident(v_idname),' FROM ',quote_ident(v_layer.layer_id),' WHERE st_dwithin (''',v_point,''', ',quote_ident(v_layer.layer_id),'.',quote_ident(v_the_geom),', ',v_sensibility,') 
				ORDER BY ST_Distance(',v_layer.layer_id,'.',v_the_geom,', ''',v_point,''') asc LIMIT 1');
				v_debug_vars := json_build_object('v_idname', v_idname, 'layer_id', v_layer.layer_id, 'v_point', v_point, 'v_the_geom', v_the_geom, 'v_sensibility', v_sensibility);
				v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 60);
				SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;
			else 
				
			--  Get element from active layer, using parent layer with exists wich enhances a lot the performance
				v_querystring = concat(
					'WITH params AS (SELECT ',
						'''', v_point, '''::geometry(POINT,', v_client_epsg, ') as pt, ', 
						v_sensibility, '::double precision AS r)',

					', near AS (',
						'SELECT lp.', quote_ident(v_idname), ', lp.state, lp.', quote_ident(v_the_geom),
						' FROM ', quote_ident(v_parent), ' lp, params p',
						' ORDER BY lp.', quote_ident(v_the_geom), ' <-> p.pt',
						' LIMIT 200)',
					
					' SELECT n.', quote_ident(v_idname),
					' FROM near n, params p',
					' WHERE n.', quote_ident(v_the_geom), ' && ST_Expand(p.pt, p.r)',
					' AND ST_DWithin(n.', quote_ident(v_the_geom), ', p.pt, p.r)',
					' ORDER BY CASE WHEN n.state=1 THEN 1 WHEN n.state=2 THEN 2 WHEN n.state=0 THEN 3 ELSE 4 END,',
					' n.', quote_ident(v_the_geom), ' <-> p.pt',
					' LIMIT 1'
				);
			end if;			
		
			EXECUTE v_querystring INTO v_id;
		END IF;      

		IF v_id IS NOT NULL THEN 
			v_flag = true;
			exit;
		ELSE 
		-- RAISE NOTICE 'Searching for layer....loop number: % layer: % ,idname: %, id: %', v_count, v_layer, v_idname, v_id;    
		END IF;
	END LOOP;

	-- Get editability of layer
	v_querystring = concat('SELECT (CASE WHEN is_editable=TRUE AND layer_id = any(',quote_literal(v_visiblelayer),'::text[]) THEN ''True'' ELSE ''False'' END) 
	FROM  ',quote_ident(v_config_layer),' WHERE layer_id=',quote_literal(v_layer.layer_id),';');
	v_debug_vars := json_build_object('v_visiblelayer', v_visiblelayer, 'v_config_layer', v_config_layer, 'layer_id', v_layer.layer_id);
	v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 70);
	SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

	EXECUTE v_querystring INTO v_iseditable;

	-- looking for additional schema
	IF v_addschema IS NOT NULL AND v_addschema != v_schemaname AND v_flag IS FALSE THEN

		v_data = gw_fct_json_object_set_key((p_data->>'data')::json, 'editable', 'false'::text);
		p_data = gw_fct_json_object_set_key(p_data, 'data', v_data::text);

		v_querystring = concat('SET search_path = ',v_addschema,', public');
		v_debug_vars := json_build_object('v_addschema', v_addschema);
		v_debug := json_build_object('querystring', v_querystring, 'vars', v_debug_vars, 'funcname', 'gw_fct_getinfofromcoordinates', 'flag', 80);
		SELECT gw_fct_debugsql(v_debug) INTO v_msgerr;

		EXECUTE v_querystring;
		SELECT gw_fct_getinfofromcoordinates(p_data) INTO v_return;
		SET search_path = 'SCHEMA_NAME', public;
		RETURN v_return;
	END IF;

	-- Control NULL's
	IF v_id IS NULL THEN
		RETURN ('{"status":"Accepted", "message":{"level":0, "text":"No feature found"}, "results":0, "version":"'|| v_version ||'"'||
		', "formTabs":[] , "tableName":"", "featureType": "","idName": "", "geometry":"", "linkPath":"", "editData":[] }')::json;
	END IF;

	IF v_toolbar IS NULL THEN
		v_toolbar = 'basic';
	END IF;

	PERFORM gw_fct_debug(concat('{"data":{"msg":"Toolbar", "variables":"',v_toolbar,'"}}')::json);

	v_return = concat('{"client":',(p_data->>'client'),',"form":{"editable":"',v_iseditable, '", "featureDialog": ',v_featuredialog,
	'},"feature":{"tableName":"',v_layer.layer_id,'","id":"',v_id,'"},"data":{"toolBar":"'||v_toolbar||'"}}');


	--   Call and return gw_fct_getinfofromid
	RETURN gw_fct_json_create_return(gw_fct_getinfofromid(v_return::json), 2580, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	 RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'))::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;