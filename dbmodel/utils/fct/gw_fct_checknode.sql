/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3206

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_checknode( p_data json)
  RETURNS json AS
$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_checknode($${
"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"test_user"},
"feature":{"id":["20607"]},
"data":{}}$$)


SELECT SCHEMA_NAME.gw_fct_checknode($${
"client":{"device":4, "infoType":1, "lang":"ES", "cur_user":"postgres"},
"feature":{},
"data":{ "coordinates":{"xcoord":419277.7306855297,"ycoord":4576625.674511955, "zoomRatio":3565.9967217571534}}}$$)

*/
DECLARE 

v_result_json json;
v_result json;
v_result_info text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_error_context text;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text;

v_cur_user text;
v_prev_cur_user text;
v_count_connec integer;
v_count_gully integer;
v_count_node integer;
v_length_arc numeric;
v_device integer;

v_node text;
v_xcoord double precision;
v_ycoord double precision;
v_epsg integer;
v_client_epsg integer;
v_point public.geometry;

v_sensibility_f float;
v_sensibility float;
v_zoomratio float;

v_activelayer text;
v_visiblelayer text;
v_config_layer text;
v_sql text;
v_debug_vars json;
v_debug json;
v_msgerr json;
v_layer record;
v_count int2=0;
v_querystring text;
v_idname text;
v_the_geom text;
v_field_state text;
v_id varchar;
v_flag boolean = false;
v_schemaname text;
v_geometry json;
v_sourcetable character varying;
column_type text;
v_featureinfo json;
BEGIN

	-- Search path
	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname := 'SCHEMA_NAME';
	
	v_cur_user := (p_data ->> 'client')::json->> 'cur_user';
	v_device := (p_data ->> 'client')::json->> 'device';
	v_xcoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'coordinates')::json->>'ycoord';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';
	v_zoomratio := ((p_data ->> 'data')::json->> 'coordinates')::json->>'zoomRatio';

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

	ELSIF  v_device IN (4, 5) THEN
		EXECUTE 'SELECT (value::json->>''desktop'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;

		--v_sensibility_f = 1;

		-- ESCALE 1:5000 as base sensibility
		v_sensibility = ((v_zoomratio/5000) * 10 * v_sensibility_f);
		v_config_layer='config_info_layer';

	END IF;

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;
	
	v_prev_cur_user = current_user;
	IF v_cur_user IS NOT NULL THEN
		EXECUTE 'SET ROLE "'||v_cur_user||'"';
	END IF;
	
	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	--Look for closest node using coordinates
	IF v_xcoord IS NOT NULL THEN 
		EXECUTE 'SELECT (value::json->>''web'')::float FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		v_sensibility = (v_zoomratio / 500 * v_sensibility_f);

		-- Make point
		SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;
		
		SELECT node_id INTO v_node FROM v_edit_node WHERE ST_DWithin(the_geom, v_point,v_sensibility) LIMIT 1;
		
		v_sourcetable = 'node';
	
		-- Get id column
			EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
			INTO v_idname
			USING v_sourcetable;
	
		-- For views it suposse pk is the first column
		IF v_idname ISNULL THEN
			EXECUTE '
			SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			ORDER BY a.attnum LIMIT 1'
			INTO v_idname
			USING v_sourcetable, v_schemaname;
		END IF;
	
		-- Get id column type
		EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
			JOIN pg_class t on a.attrelid = t.oid
			JOIN pg_namespace s on t.relnamespace = s.oid
			WHERE a.attnum > 0 
			AND NOT a.attisdropped
			AND a.attname = $3
			AND t.relname = $2 
			AND s.nspname = $1
			ORDER BY a.attnum'
				USING v_schemaname, v_sourcetable, v_idname
				INTO column_type;
		-- Get geometry_column
		
		EXECUTE 'SELECT attname FROM pg_attribute a        
		    JOIN pg_class t on a.attrelid = t.oid
		    JOIN pg_namespace s on t.relnamespace = s.oid
		    WHERE a.attnum > 0 
		    AND NOT a.attisdropped
		    AND t.relname = $1
		    AND s.nspname = $2
		    AND left (pg_catalog.format_type(a.atttypid, a.atttypmod), 8)=''geometry''
		    ORDER BY a.attnum
			LIMIT 1'
			INTO v_the_geom
			USING v_sourcetable, v_schemaname;
	
		-- Get geometry (to feature response)
		IF v_the_geom IS NOT NULL AND v_node IS NOT NULL THEN
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS x, ST_y(ST_centroid(ST_envelope(the_geom))) AS y, St_AsText('||quote_ident(v_the_geom)||') FROM '||quote_ident(v_sourcetable)||
			' WHERE '||quote_ident(v_idname)||' = CAST('||quote_nullable(v_node)||' AS '||(column_type)||'))row'
			INTO v_geometry;
		END IF;
	
		v_featureinfo := json_build_object('id',json_agg(v_node),'geometry', v_geometry);
		v_featureinfo := COALESCE(v_featureinfo, '{}');
	END IF;

	   RETURN ('{"status":"Accepted", "body":{"feature":'|| v_featureinfo ||'}' || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;