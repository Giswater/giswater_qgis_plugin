/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2590

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getlayersfromcoordinates(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_api_getlayersfromcoordinates($${
"client":{"device":9, "infoType":100, "lang":"ES"},
"form":{},
"feature":{},
"data":{"pointClickCoords":{"xcoord":419195.116315, "ycoord":4576615.43122},
    "visibleLayers":["ve_arc","ve_node","ve_connec", "ve_link", "ve_vnode"],
    "srid":25831,
    "zoomScale":500}}$$)
*/


DECLARE

--    Variables
    v_point geometry;
    v_sensibility float;
    v_sensibility_f float;
    v_ids json[];
    v_id varchar;
    v_layer text;
    v_sql text;
    v_sql2 text;
    v_iseditable boolean;
    v_return json;
    v_idname text;
    schemas_array text[];
    v_count int2=0;
    v_geometrytype text;
    api_version text;
    v_the_geom text;
    v_config_layer text;
    xxx text;
    x integer=0;
    y integer=1;
    fields_array json[];
    fields json;
    v_geometry json;
    v_all_geom json;

    
    v_xcoord float;
    v_ycoord float;
    v_visibleLayers text;
    v_zoomScale float;
    v_device integer;
    v_infotype integer;
    v_epsg integer;
    v_icon text;

    

BEGIN

    
--  Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;
    schemas_array := current_schemas(FALSE);

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_xcoord := ((p_data ->> 'data')::json->> 'pointClickCoords')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'pointClickCoords')::json->>'ycoord';
	v_visibleLayers := (p_data ->> 'data')::json->> 'visibleLayers';
	v_zoomScale := (p_data ->> 'data')::json->> 'zoomScale';
	v_epsg := (p_data ->> 'data')::json->> 'srid';



-- Sensibility factor
    IF v_device=1 OR v_device=2 THEN
        EXECUTE 'SELECT value::float FROM config_param_system WHERE parameter=''api_sensibility_factor_web'''
		INTO v_sensibility_f;
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomScale * 10 * v_sensibility_f);
		v_config_layer='config_web_layer';
		
    ELSIF  v_device=3 THEN
        EXECUTE 'SELECT value::float FROM config_param_system WHERE parameter=''api_sensibility_factor_mobile'''
		INTO v_sensibility_f;     
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomScale * 10 * v_sensibility_f);
		v_config_layer='config_web_layer';

    ELSIF  v_device=9 THEN
	EXECUTE 'SELECT value::float FROM config_param_system WHERE parameter=''api_sensibility_factor_web'''
		INTO v_sensibility_f;
		-- ESCALE 1:5000 as base sensibility
		v_sensibility = ((v_zoomScale/5000) * 10 * v_sensibility_f);
		v_config_layer='config_api_layer';


	END IF;

-- TODO:: REFORMAT v_visiblelayers

	v_visibleLayers = REPLACE (v_visibleLayers, '[', '{');
	v_visibleLayers = REPLACE (v_visibleLayers, ']', '}');
	raise notice '============== -> %',v_visibleLayers;

--   Make point
     SELECT ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_epsg) INTO v_point;

     v_sql := 'SELECT layer_id, 0 as orderby FROM  '||v_config_layer||' WHERE layer_id= '''' UNION 
              SELECT layer_id, orderby FROM  '||v_config_layer||' WHERE layer_id = any('''||v_visibleLayers||'''::text[]) ORDER BY orderby';

	raise notice 'v_sql -> %', v_sql;
    FOR v_layer IN EXECUTE v_sql 
    LOOP
	raise notice 'v_layer -> %', v_layer;
        v_count=v_count+1;
            --    Get id column
        EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
            INTO v_idname
            USING v_layer;
        --    For views it suposse pk is the first column
        IF v_idname IS NULL THEN
            EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		    AND t.relname = $1 
		    AND s.nspname = $2
		    ORDER BY a.attnum LIMIT 1'
		    INTO v_idname
		    USING v_layer, schemas_array[1];

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
	        USING v_layer, schemas_array[1];
	        raise notice 'v_the_geom -> %',v_the_geom;
	

        --  Indentify geometry type
        EXECUTE 'SELECT st_geometrytype ('||v_the_geom||') FROM '||v_layer||';' 
        INTO v_geometrytype;

	RAISE NOTICE 'Feature geometry: % ', v_geometry;
		RAISE NOTICE 'Feature v_geometrytype: % ', v_geometrytype;


	-- get icon
	IF v_geometrytype = 'ST_Point'::text OR v_geometrytype= 'ST_Multipoint'::text THEN
		v_icon='11';
	ELSIF v_geometrytype = 'ST_LineString'::text OR v_geometrytype= 'ST_MultiLineString'::text THEN
		v_icon='12';
        ELSIF v_geometrytype = 'ST_Polygon'::text OR v_geometrytype= 'ST_Multipolygon'::text THEN
		v_icon='13';
	END IF;

	raise notice 'v_icon %', v_icon;

	-- Get element
	IF v_geometrytype = 'ST_Polygon'::text OR v_geometrytype= 'ST_Multipolygon'::text THEN
            --  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)        
            EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
		    SELECT '||v_idname||' AS id, '||v_the_geom||' as the_geom, (SELECT St_AsText('||v_the_geom||') as geometry) FROM '||v_layer||' WHERE st_dwithin ($1, '||v_layer||'.'||v_the_geom||', $2) 
		    ORDER BY  ST_area('||v_layer||'.'||v_the_geom||') asc) a'
                    INTO v_ids
                    USING v_point, v_sensibility;
                
        ELSE
        raise notice 'v_point %',v_point;
        raise notice 'v_sensibility %',v_sensibility;
            --  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
            EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
		    SELECT '||v_idname||' AS id, '||v_the_geom||' as the_geom, (SELECT St_AsText('||v_the_geom||') as geometry) FROM '||v_layer||' WHERE st_dwithin ($1, '||v_layer||'.'||v_the_geom||', $2) 
		    ORDER BY  ST_Distance('||v_layer||'.'||v_the_geom||', $1) asc) a'
                    INTO v_ids
                    USING v_point, v_sensibility;
                    xxx:='SELECT array_agg(row_to_json(a)) FROM (
		    SELECT '||v_idname||' AS id, '||v_the_geom||' as the_geom FROM '||v_layer||' WHERE st_dwithin ($1, '||v_layer||'.'||v_the_geom||', $2) 
		    ORDER BY  ST_Distance('||v_layer||'.'||v_the_geom||', $1) asc) a';
                   
                    
		raise notice 'yyyy %',xxx;
        END IF;

       --     Get geometry (to feature response)
------------------------------------------
	IF v_the_geom IS NOT NULL THEN
		EXECUTE 'SELECT row_to_json(row) FROM (SELECT St_AsText('||v_the_geom||') FROM '||v_layer||' WHERE '||v_idname||' = ('||quote_nullable(v_ids)||'))row'
		INTO v_geometry;
	END IF;
	
	raise notice 'v_ids  %',v_ids;
        IF v_ids IS NOT NULL THEN
		fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'layerName', COALESCE(v_layer, '[]'));
		fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'ids', COALESCE(v_ids, '{}'));
		fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'icon', COALESCE(v_icon, '{}'));
		x = x+1;
        END IF;
        

    END LOOP;
    
raise notice 'fields_array <<<<<<<<<<<<<<<<<<<< %',fields_array;

	fields := array_to_json(fields_array);
	fields := COALESCE(fields, '[]');    

   

--    Return


   /* RETURN ('{"status":"Accepted"' ||
        ', "apiVersion":'|| api_version ||
        ', "fields":' || fields ||
        '}')::json;*/

--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
             ',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{"layersNames":' || fields ||'}}'||
	    '}')::json;

   

--    Exception handling
 --     RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
