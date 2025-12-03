/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2590

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_getlayersfromcoordinates(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getlayersfromcoordinates(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE:
SELECT SCHEMA_NAME.gw_fct_getlayersfromcoordinates($${
"client":{"device":4, "infoType":1, "lang":"ES", "epsg":SRID_VALUE},
"form":{},
"feature":{},
"data":{"pointClickCoords":{"xcoord":419195.116315, "ycoord":4576615.43122},
    "visibleLayers":["ve_arc","ve_node","ve_connec", "ve_link", "ve_vnode"],
    "epsg":SRID_VALUE,
    "zoomScale":500}}$$)
*/

DECLARE

v_point public.geometry;
v_sensibility float;
v_sensibility_f float;
v_ids json[];
v_ids_item json;
v_id text;
v_featuretype text;
v_layer text;
v_sql text;
v_sql2 text;
v_iseditable boolean;
v_return json;
v_idname text;
schemas_array text[];
v_count int2=0;
v_geometrytype text;
v_version text;
v_the_geom text;
v_config_layer text;
x integer=0;
y integer=1;
fields_array json[];
fields json;
v_geometry json;
v_all_geom json;
v_parenttype text;

v_xcoord float;
v_ycoord float;
v_visibleLayers text;
v_zoomScale float;
v_device integer;
v_infotype integer;
v_epsg integer;
v_icon text;
v_client_epsg integer;
v_project_type text;

v_valve_id text;
v_valve_text text;
v_valve_tablename text;
v_closed_valve bool;
v_netscenario_valve bool=false;
v_valve_id_netscenario text;
v_valve_text_netscenario text;
v_valve_tablename_netscenario text;
v_closed_valve_netscenario bool;
v_netscenario_id int;
v_valve_value_netscenario bool;
v_valve_epa_type text;
v_feature_type text;


BEGIN

	--  Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	schemas_array := current_schemas(FALSE);

	--  get api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get project type
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_xcoord := ((p_data ->> 'data')::json->> 'pointClickCoords')::json->>'xcoord';
	v_ycoord := ((p_data ->> 'data')::json->> 'pointClickCoords')::json->>'ycoord';
	v_visibleLayers := (p_data ->> 'data')::json->> 'visibleLayers';
	v_zoomScale := (p_data ->> 'data')::json->> 'zoomScale';
	v_epsg := (SELECT epsg FROM sys_version ORDER BY id DESC LIMIT 1);
	v_client_epsg := (p_data ->> 'client')::json->> 'epsg';

	IF v_client_epsg IS NULL THEN v_client_epsg = v_epsg; END IF;

	-- Sensibility factor
	IF v_device = 1 OR v_device = 2 THEN
		EXECUTE 'SELECT value::json->>''mobile'' FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomScale * 10 * v_sensibility_f);

	ELSIF  v_device = 3 THEN
		EXECUTE 'SELECT value::json->>''web'' FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		-- 10 pixels of base sensibility
		v_sensibility = (v_zoomScale * 10 * v_sensibility_f);

	ELSIF  v_device IN (4, 5) THEN
		EXECUTE 'SELECT value::json->>''desktop'' FROM config_param_system WHERE parameter=''basic_info_sensibility_factor'''
		INTO v_sensibility_f;
		-- ESCALE 1:5000 as base sensibility
		v_sensibility = ((v_zoomScale/5000) * 10 * v_sensibility_f);

	END IF;

	v_config_layer='config_info_layer';

	-- TODO:: REFORMAT v_visiblelayers
	v_visibleLayers = REPLACE (v_visibleLayers, '[', '{');
	v_visibleLayers = REPLACE (v_visibleLayers, ']', '}');

	--   Make point
	SELECT ST_Transform(ST_SetSRID(ST_MakePoint(v_xcoord,v_ycoord),v_client_epsg),v_epsg) INTO v_point;

	FOREACH v_layer IN ARRAY v_visibleLayers::text[]
	LOOP
		IF v_layer = 've_plan_netscenario_valve' THEN v_netscenario_valve = true; END IF;

	END LOOP;


	v_sql := 'SELECT layer_id, 0 as orderby FROM  '||quote_ident(v_config_layer)||' WHERE layer_id= '''' UNION 
              SELECT layer_id, orderby FROM  '||quote_ident(v_config_layer)||' WHERE layer_id = any('||quote_literal(v_visibleLayers)||'::text[]) ORDER BY orderby';

	FOR v_layer IN EXECUTE v_sql
	LOOP
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

			--  Indentify geometry type
			EXECUTE 'SELECT st_geometrytype ('||quote_ident(v_the_geom)||') FROM '||quote_ident(v_layer)||';'
			INTO v_geometrytype;

		-- get icon
		IF v_geometrytype = 'ST_Point'::text OR v_geometrytype= 'ST_Multipoint'::text THEN
			v_icon='11';
		ELSIF v_geometrytype = 'ST_LineString'::text OR v_geometrytype= 'ST_MultiLineString'::text THEN
			v_icon='12';
			ELSIF v_geometrytype = 'ST_Polygon'::text OR v_geometrytype= 'ST_Multipolygon'::text THEN
			v_icon='13';
		END IF;

		-- Get element
		IF v_geometrytype IN ('ST_Polygon'::text, 'ST_Multipolygon'::text, 'ST_MultiPolygon'::text) THEN
				--  Get element from active layer, using the area of the elements to order possible multiselection (minor as first)
				EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
				SELECT '||quote_ident(v_idname)||' AS id, '||quote_ident(v_the_geom)||' as the_geom, (SELECT St_AsText('||quote_ident(v_the_geom)||') as geometry) 
				FROM '||quote_ident(v_layer)||' WHERE st_dwithin ($1, '||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $2) 
				ORDER BY  ST_area('||v_layer||'.'||v_the_geom||') asc) a'
						INTO v_ids
						USING v_point, v_sensibility;
			ELSE

				--  Get element's parent type in order to be able to find featuretype'
				EXECUTE 'SELECT lower(feature_type) FROM 
				(SELECT parent_layer as layer, feature_type FROM cat_feature UNION SELECT child_layer as layer ,feature_type FROM cat_feature) a WHERE
				layer =  '||quote_literal(v_layer)||';'
				INTO v_parenttype;

				--  Get element from active layer, using the distance from the clicked point to order possible multiselection (minor as first)
				IF v_parenttype IS NOT NULL and v_parenttype != 'link' THEN
					IF v_parenttype IN ('node', 'arc', 'connec', 'gully') THEN
						v_feature_type := substring(v_layer from 4 for length(v_layer) - 1);
						EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
							SELECT '||quote_ident(v_idname)||' AS id, '||quote_ident(v_idname)||' AS label, '||quote_ident(v_the_geom)||' as the_geom, 
							(SELECT St_AsText('||quote_ident(v_the_geom)||') as geometry),
							(
								SELECT array_agg(row_to_json(psector))
								FROM (
									SELECT px.psector_id, p.name, p.active
									FROM plan_psector_x_'||v_feature_type||' AS px
									JOIN plan_psector p ON p.psector_id = px.psector_id
									WHERE px.'||quote_ident(v_idname)||' = '||quote_ident(v_layer)||'.'||quote_ident(v_idname)||'
										AND px.state = 1 AND p.status NOT IN (5, 6, 7)
								) AS psector
							) AS plan_psector_data
							FROM '||quote_ident(v_layer)||' WHERE st_dwithin ($1, '||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $2) 
							ORDER BY  ST_Distance('||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $1) asc) a'
							INTO v_ids
							USING v_point, v_sensibility;
					ELSE
						EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
							SELECT '||quote_ident(v_idname)||' AS id, '||quote_ident(v_idname)||' AS label, '||quote_ident(v_the_geom)||' as the_geom, 
							(SELECT St_AsText('||quote_ident(v_the_geom)||') as geometry)
							FROM '||quote_ident(v_layer)||' WHERE st_dwithin ($1, '||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $2) 
							ORDER BY  ST_Distance('||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $1) asc) a'
							INTO v_ids
							USING v_point, v_sensibility;
					END IF;

                    -- Get closest valve if there is one
                    IF v_project_type = 'WS' AND v_ids IS NOT NULL THEN
                        FOREACH v_ids_item IN ARRAY v_ids
                        LOOP
                            v_id := v_ids_item->>'id';
                            v_sql2 = 'SELECT '||v_parenttype||'_type FROM '||quote_ident(v_layer)||' WHERE '||v_idname||' = '''||v_id||'''';
                            EXECUTE v_sql2 INTO v_featuretype;
                            IF (SELECT feature_class FROM cat_feature WHERE id = v_featuretype) = 'VALVE' AND v_valve_text IS NULL THEN
	                            EXECUTE 'SELECT child_layer FROM cat_feature WHERE id = '''||v_featuretype||'''' INTO v_valve_tablename;
                                v_valve_id := v_id;
                                EXECUTE 'SELECT closed_valve FROM '||quote_ident(v_layer)||' WHERE '||v_idname||' = '''||v_id||'''
								AND EXISTS (SELECT 1 FROM man_valve WHERE node_id = '||v_id||' AND to_arc IS NULL)
								AND EXISTS (SELECT 1 FROM cat_feature_node WHERE '||v_parenttype||'_type = cat_feature_node.id AND ''MINSECTOR'' = ANY(graph_delimiter))' INTO v_closed_valve;
                                IF v_closed_valve IS TRUE THEN
                                    v_valve_text := 'Open valve ('||v_id||')';
                                ELSIF v_closed_valve IS FALSE THEN
                                    v_valve_text := 'Close valve ('||v_id||')';
                                END IF;

                                IF v_netscenario_valve IS TRUE THEN
									SELECT value::integer INTO v_netscenario_id FROM config_param_user WHERE cur_user=current_user AND parameter = 'plan_netscenario_current';

									v_valve_tablename_netscenario := 've_plan_netscenario_valve';
									v_valve_id_netscenario := v_id;
									EXECUTE 'SELECT closed FROM '||quote_ident(v_valve_tablename_netscenario)||' WHERE netscenario_id = '||v_netscenario_id||' AND '||v_idname||' = '''||v_id||'''' INTO v_closed_valve_netscenario;

									IF v_closed_valve_netscenario IS True OR (v_closed_valve_netscenario ISNULL AND v_closed_valve IS TRUE) THEN
										v_valve_text_netscenario := 'Open valve in netscenario '||v_netscenario_id||' ('||v_id||')';
									ELSE
										v_valve_text_netscenario := 'Close valve in netscenario '||v_netscenario_id||' ('||v_id||')';
									END IF;
                                END IF;
                            END IF;
                        END LOOP;
                    END IF;
				ELSE
					IF v_parenttype IS NOT NULL AND v_parenttype = 'link' THEN
						EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
							SELECT '||quote_ident(v_idname)||' AS id, '||quote_ident(v_idname)||' AS label, '||quote_ident(v_the_geom)||' as the_geom, 
							(SELECT St_AsText('||quote_ident(v_the_geom)||') as geometry),
							(
								SELECT array_agg(row_to_json(psector))
								FROM (
									SELECT px.psector_id, p.name, p.active
									FROM plan_psector_x_connec AS px
										JOIN plan_psector p ON p.psector_id = px.psector_id
									WHERE px.link_id = ve_link.link_id
										AND px.state = 1 AND p.status NOT IN (5, 6, 7)
								) AS psector
							) AS plan_psector_data
							FROM '||quote_ident(v_layer)||' WHERE st_dwithin ($1, '||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $2) 
							ORDER BY  ST_Distance('||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $1) asc) a'
							INTO v_ids
							USING v_point, v_sensibility;
					ELSE
						EXECUTE 'SELECT array_agg(row_to_json(a)) FROM (
						SELECT '||quote_ident(v_idname)||' AS id, '||quote_ident(v_idname)||' AS label, '||quote_ident(v_the_geom)||' as the_geom, 
						(SELECT St_AsText('||quote_ident(v_the_geom)||') as geometry)
						FROM '||quote_ident(v_layer)||' WHERE st_dwithin ($1, '||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $2) 
						ORDER BY  ST_Distance('||quote_ident(v_layer)||'.'||quote_ident(v_the_geom)||', $1) asc) a'
						INTO v_ids
						USING v_point, v_sensibility;
					END IF;
					
				END IF;

			END IF;

		IF v_ids IS NOT NULL THEN
			fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'layerName', COALESCE(v_layer, '[]'));
			fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'ids', COALESCE(v_ids, '{}'));
			fields_array[(x)::INT] := gw_fct_json_object_set_key(fields_array[(x)::INT], 'icon', COALESCE(v_icon, '{}'));
			x = x+1;
		END IF;
	END LOOP;

	IF v_valve_text IS NOT NULL THEN
		v_valve_text := ', "valve": {"id": "'||v_valve_id||'", "text": "'||v_valve_text||
						'", "tableName":"'||v_valve_tablename||'", "value": "'||(NOT v_closed_valve)||'"}';
	END IF;

	IF v_valve_text_netscenario IS NOT NULL THEN
		v_valve_id_netscenario := COALESCE(v_valve_id_netscenario, '');
		v_netscenario_id := COALESCE(v_netscenario_id, -1);
		v_valve_tablename_netscenario := COALESCE(v_valve_tablename_netscenario, '');

		IF v_closed_valve_netscenario IS NULL THEN
			v_closed_valve_netscenario := v_closed_valve;
		END IF;

		v_valve_text_netscenario := ', "valve_netscenario": {"id": "'||v_valve_id_netscenario||'", "netscenario_id": "'||v_netscenario_id||'", "text": "'||v_valve_text_netscenario||
						'", "tableName":"'||v_valve_tablename_netscenario||'", "value": "'||(NOT v_closed_valve_netscenario)||'"}';

	END IF;

	fields := array_to_json(fields_array);
	fields := COALESCE(fields, '[]');
	v_valve_text := COALESCE(v_valve_text, '');
	v_valve_text_netscenario := COALESCE(v_valve_text_netscenario, '');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{"level":1, "text":"Process done successfully"}'||
			',"form":{}'||
			',"feature":{}'||
			',"data":{"layersNames":' || fields ||''|| v_valve_text ||''|| v_valve_text_netscenario ||'}}'||
	    '}')::json, 2590, null, null, null);

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
