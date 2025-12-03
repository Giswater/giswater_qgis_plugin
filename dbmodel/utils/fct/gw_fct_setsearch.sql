/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2618

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setsearch (json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setsearch(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"addNetwork"}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "net_type":{"id":"ve_arc", "name":"Arcs"}, "searchType":"arc", "net_code":{"text":"3"}}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "searchType":"None", "net_type":{"id":"", "name":""}, "net_code":{"text":"e"}, "addSchema":"None"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"workcat"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "workcat_search":{"text":"w"}, "addSchema":"None"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"addNetwork"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "net_type":{"id":"", "name":""}, "net_code":{"text":"3"}, "addSchema":"ud"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "searchType":"None", "net_type":{"id":"", "name":""}, "net_code":{"text":"3"}, "addSchema":"ud"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "searchType":"None", "net_type":{"id":"", "name":""}, "net_code":{"text":"3"}, "addSchema":"None"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "searchType":"arc", "net_type":{"id":"ve_arc", "name":"Arcs"}, "net_code":{"text":"5"}, "addSchema":"None"}}$$);

SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"add_network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "net_type":{"id":"", "name":""}, "net_code":{"text":"3"}, "addSchema":"ud"}}$$);


 SELECT gw_fct_setsearch($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"tabName":"add_network"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "net_type":{"id":"", "name":""}, "net_code":{"text":"4"}, "addSchema":"ud"}}$$);

MAIN ISSUES
-----------
- basic_search_network is key issue to define variables on config_param_system to searh anything you want
- Second schema is avaliable to search

*/

DECLARE

v_response json;
v_name varchar;
v_idarg varchar;
v_textarg varchar;
v_tab varchar;
v_combo json;
v_edittext json;
v_version text;
v_projecttype character varying;
v_count integer;
v_querytext text;
v_searchtype text;
v_partial text;

--network
v_network_layername text;
v_network_idname text;
v_network_code text;
v_network_catalog text;
v_value text;
v_network_all json;

--muni
v_muni_layer varchar;
v_muni_id_field varchar;
v_muni_display_field varchar;
v_muni_geom_field varchar;

-- street
v_street_layer varchar;
v_street_id_field varchar;
v_street_search_field varchar;
v_street_display_field varchar;
v_street_muni_id_field varchar;
v_street_geom_field varchar;

-- address
v_address_layer varchar;
v_address_id_field varchar;
v_address_display_field varchar;
v_address_street_id_field varchar;
v_address_geom_id_field varchar;

--hydro
v_hydro_layer varchar;
v_hydro_id_field varchar;
v_hydro_feature_field varchar;
v_hydro_search_field_1 varchar;
v_hydro_search_field_2 varchar;
v_hydro_search_field_3 varchar;
v_hydro_parent_field varchar;

--workcat
v_workcat_layer varchar;
v_workcat_id_field varchar;
v_workcat_display_field varchar;
v_workcat_geom_field varchar;
v_filter_text varchar;

--visit
v_visit_layer varchar;
v_visit_id_field varchar;
v_visit_display_field varchar;
v_visit_geom_field varchar;

--psector
v_psector_layer varchar;
v_psector_id_field varchar;
v_psector_display_field varchar;
v_psector_parent_field varchar;
v_psector_geom_field varchar;

--exploitation
v_exploitation_layer varchar;
v_exploitation_id_field varchar;
v_exploitation_display_field varchar;
v_exploitation_geom_field varchar;

v_schemaname text;
v_addschema text;

v_hydro_contains text;

v_srid integer;
v_return json;
v_flag boolean = false;

v_tablename text;
v_geometry json;
v_executepk text;
v_id text;
v_section text;
v_json_value json;
v_result text;
v_filter_key text;
v_filter_value text;
v_exec_func text;
v_table_name text;
v_search_add text;
v_device integer;
v_xcoord float;
v_ycoord float;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';

	-- Set api version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get project type
	SELECT project_type INTO v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT epsg INTO v_srid FROM sys_version ORDER BY id DESC LIMIT 1;


	-- Get tab
	v_tab := ((p_data->>'form')::json)->>'tabName';
	v_searchtype := (p_data->>'data')::json->>'searchType';
	v_addschema := (p_data->>'data')::json->>'addSchema';
	v_hydro_contains := (p_data->>'data')::json->>'hydro_contains';
	
	v_section := ((p_data->>'data')::json)->>'section';
	v_value := (p_data->>'data')::json->>'value';
	v_filter_key := (p_data->>'data')::json->>'filterKey';
	v_filter_value := (p_data->>'data')::json->>'filterValue';
	v_exec_func := (p_data->>'data')::json->>'execFunc';
	v_table_name := (p_data->>'data')::json->>'tableName';
	v_search_add = ((p_data ->>'data')::json->>'searchAdd');
	v_device = ((p_data ->>'client')::json->>'device');
	
   
   	if v_device = 5 then
		if v_filter_value = 'undefined' then
		v_filter_value = v_value;
		end if;

		if v_section ilike 'basic_search_v2_tab_network%' then
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS xcoord, ST_y(ST_centroid(ST_envelope(the_geom))) AS ycoord, St_AsText(the_geom) FROM '||quote_ident(v_table_name)||
			' WHERE '||quote_ident(v_filter_key)||' = ('||quote_nullable(v_filter_value)||'))row'
			INTO v_geometry;
		elsif v_section = 'basic_search_v2_tab_address' and v_search_add = 'true' then

			EXECUTE 'SELECT row_to_json(row) FROM (SELECT st_x (a.the_geom) as xcoord, st_y (a.the_geom) as  ycoord, St_AsText(a.the_geom) FROM v_ext_streetaxis s join ext_municipality m using(muni_id) join v_ext_address a on s.id = a.streetaxis_id
			 WHERE concat(s.name, '', '', m.name, '', '', a.postnumber) = ('||quote_nullable(v_filter_value)||'))row'
			INTO v_geometry;

		elsif v_section = 'basic_search_v2_tab_address' then
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS xcoord, ST_y(ST_centroid(ST_envelope(the_geom))) AS ycoord, St_AsText(the_geom) FROM v_ext_streetaxis '||
			' s WHERE '||v_filter_key||' = ('||quote_nullable(v_filter_value)||'))row'
			INTO v_geometry;
		elsif v_section = 'basic_search_v2_tab_psector' then
			EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS xcoord, ST_y(ST_centroid(ST_envelope(the_geom))) AS ycoord, St_AsText(the_geom) FROM '||quote_ident(v_table_name)||
			' WHERE '||quote_ident(v_filter_key)||' = ('||quote_nullable(v_filter_value)||'))row'
			INTO v_geometry;
		elsif v_section = 'basic_search_v2_tab_hydrometer' then
			EXECUTE 'SELECT feature_id FROM '||quote_ident(v_table_name)||
			' WHERE '||quote_ident(v_filter_key)||' = ('||quote_nullable(v_filter_value)||')'
			INTO v_result;

			EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS xcoord, ST_y(ST_centroid(ST_envelope(the_geom))) AS ycoord, St_AsText(the_geom) FROM ve_connec
			WHERE connec_id = ('||quote_nullable(v_result)||'))row'
			INTO v_geometry;

			if v_geometry is null then
				EXECUTE 'SELECT row_to_json(row) FROM (SELECT ST_x(ST_centroid(ST_envelope(the_geom))) AS xcoord, ST_y(ST_centroid(ST_envelope(the_geom))) AS ycoord, St_AsText(the_geom) FROM ve_node
				WHERE node_id = ('||quote_nullable(v_result)||'))row'
				INTO v_geometry;
			end if;
		elsif v_section = 'basic_search_v2_tab_workcat' then

			execute 'SELECT row_to_json(row) FROM (SELECT 
				CASE
				WHEN st_geometrytype(st_concavehull(st_simplify(d.the_geom, 1), 0.99::double precision)) = ''ST_Polygon''::text 
				THEN st_astext(st_buffer(st_concavehull(st_simplify(d.the_geom, 1), 0.99::double precision), 10::double precision)::geometry(Polygon, '||v_srid||'))
				ELSE st_astext(st_expand(st_buffer(d.the_geom, 10::double precision), 1::double precision)::geometry(Polygon, '||v_srid||'))
				END AS st_astext
				FROM (SELECT st_collect(a.the_geom) AS the_geom, a.workcat_id FROM (  SELECT node.workcat_id, node.the_geom FROM node WHERE node.state = 1
						UNION
						 SELECT arc.workcat_id, arc.the_geom FROM arc WHERE arc.state = 1
						UNION
						 SELECT connec.workcat_id, connec.the_geom FROM connec WHERE connec.state = 1
						UNION
						 SELECT element.workcat_id, element.the_geom FROM element WHERE element.state = 1
						UNION
						  SELECT node.workcat_id_end AS workcat_id,node.the_geom FROM node WHERE node.state = 0
						UNION
						  SELECT arc.workcat_id_end AS workcat_id, arc.the_geom FROM arc WHERE arc.state = 0
						UNION
						 SELECT connec.workcat_id_end AS workcat_id,connec.the_geom FROM connec WHERE connec.state = 0
						UNION  
						 SELECT element.workcat_id_end AS workcat_id, element.the_geom FROM element WHERE element.state = 0) a GROUP BY a.workcat_id ) d 
			
				JOIN cat_work AS b ON d.workcat_id = b.id WHERE b.id::text ILIKE '||quote_nullable(v_filter_value)||' LIMIT 10 )row'
			into v_geometry;
		elsif v_section = 'basic_search_v2_tab_coordinates' then
			v_xcoord = split_part(v_value,',',1);
			v_ycoord = split_part(v_value,',',2);

			EXECUTE 'SELECT row_to_json(row) FROM (SELECT '||v_xcoord||' as xcoord, '||v_ycoord||' as ycoord, St_AsText(ST_Point('||v_xcoord||','||v_ycoord||')))row'
			INTO v_geometry;

		end if;
		
		v_response = gw_fct_json_object_set_key (v_response, 'geometry', v_geometry);
		v_response = gw_fct_json_object_set_key (v_response, 'execFunc', v_exec_func);
		v_response = gw_fct_json_object_set_key (v_response, 'funcTable', v_table_name);
		v_response = gw_fct_json_object_set_key (v_response, 'funcValue', v_filter_value);

		-- Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted"' || ', "version":'|| v_version ||
			', "data":' || v_response ||      
			'}')::json, 2618, null, null, null);
		
	ELSE

		-- profilactic control of schema name
		IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null'
			THEN v_addschema = null; 
		ELSE
			IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
				"data":{"message":"3132", "function":"2618","parameters":null, "is_process":true}}$$)';
				-- todo: send message to response
			END IF;
		END IF;
		
		-- looking for additional schema 
		IF v_addschema IS NOT NULL AND v_addschema != v_schemaname AND v_tab = 'add_network' THEN
		
			EXECUTE 'SET search_path = '||v_addschema||', public';
			SELECT gw_fct_setsearch(p_data) INTO v_return;
			SET search_path = 'SCHEMA_NAME', public;
			RETURN v_return;
		END IF;

		-- Network tab
		--------------
		IF v_tab = 'network' OR v_tab = 'add_network' THEN

			-- profilactic control of nulls
			IF v_searchtype is null OR v_searchtype = 'None' THEN v_searchtype = 'all'; end if;

			-- get values from database config variable
			v_value = (SELECT value FROM config_param_system WHERE value::json->>'search_type' = v_searchtype and parameter like '%basic_search_network%');
		
			v_network_layername = v_value::json->>'sys_table_id';
			v_network_idname = v_value::json->>'sys_id_field';
			v_network_code = v_value::json->>'sys_search_field';
			v_network_catalog = v_value::json->>'cat_field';

			IF v_value IS NULL THEN v_value ='all'; END IF;
					
			-- get values from init json
			v_combo := ((p_data->>'data')::json)->>'net_type';
			v_idarg := v_combo->>'id';
			v_name := v_combo->>'name';
			v_edittext := ((p_data->>'data')::json)->>'net_code';
			v_textarg := concat('%', v_edittext->>'text' ,'%');

			-- built first part of query
			IF v_searchtype = 'all' THEN -- feature search is for the whole system
				FOR v_network_all IN SELECT value FROM config_param_system WHERE parameter like '%basic_search_network_%' 
				LOOP
					IF  v_network_all->>'search_type' IS NOT NULL THEN
						v_partial = concat('SELECT ',v_network_all->>'sys_id_field',' AS sys_id, ', v_network_all->>'sys_search_field','::text AS search_field, ', v_network_all->>'cat_field',' AS cat_id,', 
							quote_literal(v_network_all->>'sys_id_field')::text,' AS sys_idname,',quote_literal(v_network_all->>'search_type')::text,' AS search_type, ',
							quote_literal(v_network_all->>'sys_table_id')::text,'::text AS sys_table_id 
							FROM ', v_network_all->>'sys_table_id');
							
						-- concat different querytext
						v_querytext = concat(v_partial, ' UNION ' , v_querytext);
					END IF;
				END LOOP;

				-- remove last 'UNION' when there is no next loop to union nothing...
				v_querytext = reverse(substring(reverse (v_querytext),7,9999));
			ELSE
				-- buid querytext
				v_querytext= concat('SELECT ',v_network_idname,' AS sys_id, ', v_network_code,'::text AS search_field, ', v_network_catalog,' AS cat_id,', 
						quote_literal(v_network_idname)::text,' AS sys_idname,',quote_literal(v_searchtype)::text,' AS search_type, ',
						quote_literal(v_network_layername)::text,'::text AS sys_table_id 
						FROM ', v_network_layername);
			END IF;			 

			-- built second part of query
			IF v_idarg = '' THEN 

				-- Get values for type combo
				EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT sys_id, sys_table_id, 
				CONCAT (search_field, '' : '', cat_id) AS display_name, sys_idname
				FROM ('||(v_querytext)||')b
				WHERE CONCAT (search_field, '' : '', cat_id) ILIKE ' || quote_literal(v_textarg) || ' 
				ORDER BY length(search_field::text) asc LIMIT 10) a'
				INTO v_response;
			ELSE 
				-- Get values type combo    
				EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (SELECT sys_id, sys_table_id, 
				CONCAT (search_field, '' : '', cat_id) AS display_name, sys_idname, '||quote_literal(v_searchtype)::text||'  as search_type
				FROM ('||(v_querytext)||')b
				WHERE CONCAT (search_field, '' : '', cat_id) ILIKE ' || quote_literal(v_textarg) || ' AND sys_table_id = '||quote_literal(v_idarg)||'
				ORDER BY length(search_field::text) asc LIMIT 10) a'
				INTO v_response;
			END IF;



		-- address
		ELSIF v_tab = 'address' THEN

			-- Parameters of the municipality layer
			SELECT ((value::json)->>'sys_table_id') INTO v_muni_layer FROM config_param_system WHERE parameter='basic_search_muni';
			SELECT ((value::json)->>'sys_id_field') INTO v_muni_id_field FROM config_param_system WHERE parameter='basic_search_muni';
			SELECT ((value::json)->>'sys_search_field') INTO v_muni_display_field FROM config_param_system WHERE parameter='basic_search_muni';
			SELECT ((value::json)->>'sys_geom_field') INTO v_muni_geom_field FROM config_param_system WHERE parameter='basic_search_muni';

			-- Parameters of the street layer
			SELECT ((value::json)->>'sys_table_id') INTO v_street_layer FROM config_param_system WHERE parameter='basic_search_street';
			SELECT ((value::json)->>'sys_id_field') INTO v_street_id_field FROM config_param_system WHERE parameter='basic_search_street';
			SELECT ((value::json)->>'sys_search_field') INTO v_street_search_field FROM config_param_system WHERE parameter='basic_search_street';
			SELECT ((value::json)->>'sys_display_field') INTO v_street_display_field FROM config_param_system WHERE parameter='basic_search_street';
			SELECT ((value::json)->>'sys_parent_field') INTO v_street_muni_id_field FROM config_param_system WHERE parameter='basic_search_street';
			SELECT ((value::json)->>'sys_geom_field') INTO v_street_geom_field FROM config_param_system WHERE parameter='basic_search_street';

			--Text to search
			v_combo := ((p_data->>'data')::json)->>'add_muni';
			v_idarg := v_combo->>'id';
			v_name := v_combo->>'name';
			v_edittext := ((p_data->>'data')::json)->>'add_street';
			v_textarg := concat('%', v_edittext->>'text' ,'%');

			-- Fix municipality vdefault
			DELETE FROM config_param_user WHERE parameter='basic_search_municipality_vdefault' AND cur_user=current_user;
			INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('basic_search_municipality_vdefault',v_idarg, current_user);

			-- Get street
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) 
				FROM (SELECT '||quote_ident(v_street_layer)||'.'||quote_ident(v_street_id_field)||' as id,'||quote_ident(v_street_layer)||'.'||quote_ident(v_street_display_field)||' as display_name, 
				st_astext(st_envelope('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_geom_field)||'))
				FROM '||quote_ident(v_street_layer)||'
				JOIN '||quote_ident(v_muni_layer)||' ON '||quote_ident(v_muni_layer)||'.'||quote_ident(v_muni_id_field)||' = '||quote_ident(v_street_layer)||'.'||quote_ident(v_street_muni_id_field) ||'
				WHERE lower(unaccent('||quote_ident(v_muni_layer)||'.'||quote_ident(v_muni_display_field)||')) = lower(unaccent('||quote_literal(v_name)||'))
				AND lower(unaccent('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_display_field)||')) ILIKE lower(unaccent('||quote_literal(v_textarg)||')) ORDER BY
				'||quote_ident(v_street_layer)||'.'||quote_ident(v_street_display_field)||' LIMIT 10 )a'
				INTO v_response;
			
			-- if textarg mismatch, try use levenshtein function to show similar results
			IF v_response IS NULL THEN
				v_textarg := v_edittext->>'text';
				EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) 
					FROM (WITH q AS (SELECT lower(unaccent('||quote_literal(v_textarg)||')) AS qsn)
					SELECT levenshtein(lower('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_search_field)||'),lower(qsn)) AS leven,
					levenshtein(lower('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_search_field)||'),lower(qsn))::DECIMAL/greatest(length('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_search_field)||'),length(qsn)) as ratio,
					'||quote_ident(v_street_layer)||'.'||quote_ident(v_street_id_field)||' as id,'||quote_ident(v_street_layer)||'.'||quote_ident(v_street_display_field)||' as display_name,
					st_astext(st_envelope('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_geom_field)||'))
					FROM q, '||quote_ident(v_street_layer)||'
					JOIN '||quote_ident(v_muni_layer)||' ON '||quote_ident(v_muni_layer)||'.'||quote_ident(v_muni_id_field)||' = '||quote_ident(v_street_layer)||'.'||quote_ident(v_street_muni_id_field) ||'
					WHERE lower(unaccent('||quote_ident(v_muni_layer)||'.'||quote_ident(v_muni_display_field)||')) = lower(unaccent('||quote_literal(v_name)||'))
					AND levenshtein(lower('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_search_field)||'),lower(qsn))::DECIMAL/greatest(length('||quote_ident(v_street_layer)||'.'||quote_ident(v_street_search_field)||'),length(qsn))< 0.6 ORDER BY ratio LIMIT 10)a'
				INTO v_response;

			END IF;

		-- Hydro tab
		ELSIF v_tab = 'hydro' THEN

			-- Parameters of the hydro layer
			SELECT ((value::json)->>'sys_table_id') INTO v_hydro_layer FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_id_field') INTO v_hydro_id_field FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_feature_id') INTO v_hydro_feature_field FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_search_field_1') INTO v_hydro_search_field_1 FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_search_field_2') INTO v_hydro_search_field_2 FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_search_field_3') INTO v_hydro_search_field_3 FROM config_param_system WHERE parameter='basic_search_hydrometer';
			SELECT ((value::json)->>'sys_parent_field') INTO v_exploitation_display_field FROM config_param_system WHERE parameter='basic_search_hydrometer';

			-- Text to search
			v_combo := ((p_data->>'data')::json)->>'hydro_expl';
			v_idarg := v_combo->>'id';
			v_name := v_combo->>'name';
			v_edittext := ((p_data->>'data')::json)->>'hydro_search';
			IF v_hydro_contains = 'True' THEN
				v_textarg := concat('%', v_edittext->>'text' ,'%');
			ELSE
				v_textarg := concat(v_edittext->>'text' ,'%');
			END IF;
			

			-- Fix exploitation vdefault
			DELETE FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user;
			INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('basic_search_exploitation_vdefault',v_idarg, current_user);

			-- Get hydrometer 
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) FROM (
				SELECT '||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_id_field)||' AS sys_id, COALESCE(ST_X(connec.the_geom), ST_X(node.the_geom)) AS sys_x, COALESCE(ST_Y(connec.the_geom), ST_Y(node.the_geom)) AS sys_y,
				concat ('||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_1)||','' - '',
				'||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_2)||','' - '',
				'||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_3)||')
				 AS display_name, '||quote_literal(v_hydro_layer)||' AS sys_table_id, '||quote_literal(v_hydro_id_field)||' AS sys_idname, '||quote_ident(v_hydro_feature_field)||' AS sys_feature_type_id,
				CASE WHEN '||quote_ident(v_hydro_feature_field)||' IN (SELECT connec_id FROM connec) THEN ''ve_connec'' ELSE ''ve_node'' END AS sys_feature
				FROM '||quote_ident(v_hydro_layer)||'
				LEFT JOIN connec ON (connec.connec_id = '||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_feature_field)||')
				LEFT JOIN node ON (node.node_id = '||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_feature_field)||')
				WHERE '||quote_ident(v_hydro_layer)||'.'||quote_ident(v_exploitation_display_field)||' = '||quote_literal(v_name)||'
						AND concat ('||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_1)||','' - '',
						'||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_2)||','' - '',
						'||quote_ident(v_hydro_layer)||'.'||quote_ident(v_hydro_search_field_3)||')
						ILIKE '||quote_literal(v_textarg)||' order by length('||quote_ident(v_hydro_search_field_1)||') asc
						LIMIT 10) a'
				INTO v_response; 
		-- Workcat tab
		ELSIF v_tab = 'workcat' THEN

			-- Parameters of the workcat layer
			SELECT ((value::json)->>'sys_table_id') INTO v_workcat_layer FROM config_param_system WHERE parameter='basic_search_workcat';
			SELECT ((value::json)->>'sys_id_field') INTO v_workcat_id_field FROM config_param_system WHERE parameter='basic_search_workcat';
			SELECT ((value::json)->>'sys_search_field') INTO v_workcat_display_field FROM config_param_system WHERE parameter='basic_search_workcat';
			SELECT ((value::json)->>'sys_geom_field') INTO v_workcat_geom_field FROM config_param_system WHERE parameter='basic_search_workcat';
			SELECT ((value::json)->>'filter_text') INTO v_filter_text FROM config_param_system WHERE parameter='basic_search_workcat';
			IF v_filter_text is null then v_filter_text = ''; end if;
			
				-- Text to search
			v_edittext := ((p_data->>'data')::json)->>'workcat_search';
			v_textarg := concat('%', v_edittext->>'text' ,'%');

			v_querytext = ' SELECT node.workcat_id, node.the_geom FROM node WHERE node.state = 1
						UNION
						 SELECT arc.workcat_id, arc.the_geom FROM arc WHERE arc.state = 1
						UNION
						 SELECT connec.workcat_id, connec.the_geom FROM connec WHERE connec.state = 1
						UNION
						 SELECT element.workcat_id, element.the_geom FROM element WHERE element.state = 1
						UNION
						  SELECT node.workcat_id_end AS workcat_id,node.the_geom FROM node WHERE node.state = 0
						UNION
						  SELECT arc.workcat_id_end AS workcat_id, arc.the_geom FROM arc WHERE arc.state = 0
						UNION
						 SELECT connec.workcat_id_end AS workcat_id,connec.the_geom FROM connec WHERE connec.state = 0
						UNION  
						 SELECT element.workcat_id_end AS workcat_id, element.the_geom FROM element WHERE element.state = 0';

				IF v_projecttype = 'UD' THEN
				v_querytext = concat (v_querytext, ' UNION SELECT gully.workcat_id,gully.the_geom FROM gully WHERE gully.state = 1 
						UNION SELECT gully.workcat_id,gully.the_geom FROM gully WHERE gully.state = 0');
				END IF;

			--  Search in the workcat
			
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(c))) 
				FROM (SELECT b.'||quote_ident(v_workcat_display_field)||' as display_name, '
				||quote_literal(v_workcat_layer)||' AS sys_table_id ,'
				'b.'||quote_ident((v_workcat_id_field))||' AS sys_id, '
				||quote_literal(v_workcat_layer)||' AS sys_idname,'
				||quote_literal(v_filter_text)||' AS filter_text,
				CASE
				WHEN st_geometrytype(st_concavehull(d.the_geom, 0.99::double precision)) = ''ST_Polygon''::text THEN st_astext(st_buffer(st_concavehull(d.the_geom, 0.99::double precision), 10::double precision)::geometry(Polygon, '||v_srid||'))
				ELSE st_astext(st_expand(st_buffer(d.the_geom, 10::double precision), 1::double precision)::geometry(Polygon, '||v_srid||'))
				END AS sys_geometry

				FROM (SELECT st_collect(a.the_geom) AS the_geom, a.workcat_id FROM ( '||v_querytext||') a GROUP BY a.workcat_id ) d 

				JOIN '||quote_ident(v_workcat_layer)||' AS b ON d.workcat_id = b.'||quote_ident(v_workcat_id_field)||

				' WHERE b.'||quote_ident(v_workcat_display_field)||'::text ILIKE '||quote_literal(v_textarg)||' LIMIT 10 ) c'
				INTO v_response;
				
		-- Visit tab
		ELSIF v_tab = 'visit' THEN

			-- Parameters of the workcat layer
			SELECT ((value::json)->>'sys_table_id') INTO v_visit_layer FROM config_param_system WHERE parameter='basic_search_visit';
			SELECT ((value::json)->>'sys_id_field') INTO v_visit_id_field FROM config_param_system WHERE parameter='basic_search_visit';
			SELECT ((value::json)->>'sys_search_field') INTO v_visit_display_field FROM config_param_system WHERE parameter='basic_search_visit';
			SELECT ((value::json)->>'sys_geom_field') INTO v_visit_geom_field FROM config_param_system WHERE parameter='basic_search_visit';
			
			-- Text to search
			v_edittext := ((p_data->>'data')::json)->>'visit_search';
			v_textarg := concat('%', v_edittext->>'text' ,'%');

			--  Search in the visit
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) 
				FROM (SELECT '||quote_ident(v_visit_display_field)||'::text as display_name, '||quote_literal(v_visit_layer)||' AS sys_table_id , 
				'||quote_ident((v_visit_id_field))||' AS sys_id, '||quote_literal(v_visit_layer)||' AS sys_idname, st_astext(the_geom) as sys_geometry
				FROM '||v_visit_layer||'  
				WHERE '||quote_ident(v_visit_display_field)||'::text ILIKE '||quote_literal(v_textarg)||' LIMIT 10 )a'
				INTO v_response;
				
		-- Psector tab
		ELSIF v_tab = 'psector' THEN

				-- Parameters of the exploitation layer
			SELECT ((value::json)->>'sys_table_id') INTO v_exploitation_layer FROM config_param_system WHERE parameter='basic_search_exploitation';
			SELECT ((value::json)->>'sys_id_field') INTO v_exploitation_id_field FROM config_param_system WHERE parameter='basic_search_exploitation';
			SELECT ((value::json)->>'sys_search_field') INTO v_exploitation_display_field FROM config_param_system WHERE parameter='basic_search_exploitation';
			SELECT ((value::json)->>'sys_geom_field') INTO v_exploitation_geom_field FROM config_param_system WHERE parameter='basic_search_exploitation';
		 
				-- Parameters of the psector layer
			SELECT ((value::json)->>'sys_table_id') INTO v_psector_layer FROM config_param_system WHERE parameter='basic_search_psector';
			SELECT ((value::json)->>'sys_id_field') INTO v_psector_id_field FROM config_param_system WHERE parameter='basic_search_psector';
			SELECT ((value::json)->>'sys_search_field') INTO v_psector_display_field FROM config_param_system WHERE parameter='basic_search_psector';
			SELECT ((value::json)->>'sys_parent_field') INTO v_psector_parent_field FROM config_param_system WHERE parameter='basic_search_psector';
			SELECT ((value::json)->>'sys_geom_field') INTO v_psector_geom_field FROM config_param_system WHERE parameter='basic_search_psector';
			
			--Text to search
			v_combo := ((p_data->>'data')::json)->>'psector_expl';
			v_idarg := v_combo->>'id';
			v_name := v_combo->>'name';
			v_edittext := ((p_data->>'data')::json)->>'psector_search';
			v_textarg := concat('%', v_edittext->>'text' ,'%');

			-- Fix exploitation vdefault
			DELETE FROM config_param_user WHERE parameter='basic_search_exploitation_vdefault' AND cur_user=current_user;
			INSERT INTO config_param_user (parameter, value, cur_user) VALUES ('basic_search_exploitation_vdefault',v_idarg, current_user);

			-- Get psector (improved version)
			EXECUTE 'SELECT array_to_json(array_agg(row_to_json(a))) 
				FROM (SELECT '||quote_ident(v_psector_layer)||'.'||quote_ident(v_psector_display_field)||' as display_name, '||quote_literal(v_psector_layer)||' AS sys_table_id , 
				'||quote_ident(v_psector_layer)||'.'||quote_ident((v_psector_id_field))||' AS sys_id, '||quote_literal(v_psector_layer)||' AS sys_idname , st_astext(st_envelope('||quote_ident(v_psector_layer)||'.the_geom)) AS sys_geometry
				FROM '||quote_ident(v_psector_layer)||'  
				JOIN '||quote_ident(v_exploitation_layer)||' ON '||quote_ident(v_exploitation_layer)||'.'||quote_ident(v_exploitation_id_field)||' = '||quote_ident(v_psector_layer)||'.'||quote_ident(v_psector_parent_field)||'
				WHERE '||quote_ident(v_exploitation_layer)||'.'||quote_ident(v_exploitation_display_field)||' = '||quote_literal(v_name)||'
				AND '||quote_ident(v_psector_layer)||'.'||quote_ident(v_psector_display_field)||' ILIKE '||quote_literal(v_textarg)||' LIMIT 10 )a'
				INTO v_response;	
		END IF;

		-- Control NULL's
		v_response := COALESCE(v_response, '{}');

		-- Return
		RETURN gw_fct_json_create_return(('{"status":"Accepted"' || ', "version":'|| v_version ||
			', "data":' || v_response ||      
			'}')::json, 2618, null, null, null);
			
	end if;
	
	-- exception handling
	EXCEPTION WHEN OTHERS THEN 
	RETURN json_build_object('status', 'Failed','NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE)::json;

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
