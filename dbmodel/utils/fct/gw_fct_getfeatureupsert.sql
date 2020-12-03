/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2560


DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_featureupsert(character varying, character varying, public.geometry, integer, integer, character varying, boolean);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_get_featureupsert(character varying, character varying, public.geometry, integer, integer, character varying, boolean, text, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getfeatureupsert(
    p_table_id character varying,
    p_id character varying,
    p_reduced_geometry public.geometry,
    p_device integer,
    p_info_type integer,
    p_tg_op character varying,
    p_configtable boolean,
    p_idname text,
    p_columntype text)
  RETURNS json AS
$BODY$


/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_getformfields('ve_arc_pipe',	'form_feature',	'data',	've_arc_pipe',	'arc_id',	'2088','character varying(16)',	'UPDATE',	'1',	4,	'{}'::json )

SELECT SCHEMA_NAME.gw_fct_getconfig($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"formName":"config"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}}}$$);

SELECT SCHEMA_NAME.gw_fct_getinfofromcoordinates($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "toolBar":"basic", "rolePermissions":"None", "activeLayer":"", "visibleLayer":["v_edit_dma", "v_edit_dqa", "v_edit_connec", "v_edit_arc", "v_edit_presszone", "v_edit_node"], "addSchema":"None", "projecRole":"None", "coordinates":{"xcoord":418845.1255354889,"ycoord":4576886.012737853, "zoomRatio":709.3707873874217}}}$$);

arc with no nodes
SELECT SCHEMA_NAME.gw_fct_getfeatureupsert('ve_arc_pipe', null, '0102000020E764000002000000000000A083198641000000669A33C041000000E829D880410000D0AE90F0F341', 9, 100,'INSERT', true, 'arc_id', 'text')
arc with nodes
SELECT SCHEMA_NAME.gw_fct_getfeatureupsert('ve_arc_pipe', null, '0102000020E764000002000000998B3C512F881941B28315AA7F76514105968D7D748819419FDF72D781765141', 9, 100,'INSERT', true, 'arc_id', 'text')
SELECT SCHEMA_NAME.gw_fct_getfeatureupsert('ve_arc_pipe', '2001', null, 9, 100,'UPDATE', true)

PERFORM gw_fct_debug(concat('{"data":{"msg":"----> INPUT FOR gw_fct_getfeatureupsert: ", "variables":"',v_debug,'"}}')::json);
PERFORM gw_fct_debug(concat('{"data":{"msg":"<---- OUTPUT FOR gw_fct_getfeatureupsert: ", "variables":"',v_debug,'"}}')::json);
UPDATE config_param_user SET value =  'true' WHERE parameter = 'utils_debug_mode' and cur_user = current_user;

-- visit
SELECT SCHEMA_NAME.gw_fct_getfeatureupsert('v_edit_om_visit', '39', null, 4, 1, 'SELECT', false, 'id', 'integer')

-- dimensions
SELECT SCHEMA_NAME.gw_fct_getfeatureupsert('v_edit_dimensions', '39', null, 4, 1, 'UPDATE', false, 'id', 'integer')


*/

DECLARE

v_state_value integer;
v_fields json;
v_fields_array json[];
aux_json json;    
combo_json json;
schemas_array name[];
array_index integer DEFAULT 0;
field_value character varying;
v_version json;
v_selected_id text;
v_vdefault text;
v_numnodes integer;
v_feature_type text;
count_aux integer;
v_sector_id integer;
v_macrosector_id integer;
v_expl_id integer;
v_dma_id integer;
v_macrodma_id integer;
v_muni_id integer;
v_project_type varchar;
v_cat_feature_id varchar;
v_code int8;
v_node_proximity double precision;
v_node_proximity_control boolean;
v_connec_proximity double precision;
v_connec_proximity_control boolean;
v_gully_proximity double precision;
v_gully_proximity_control boolean;
v_arc_searchnodes double precision;
v_samenode_init_end_control boolean;
v_arc_searchnodes_control boolean;
v_tabname text = 'data';
v_formname text;
v_tablename text;
v_visit_tablename text;
v_topocontrol boolean = TRUE;
v_status boolean = true;
v_message text;
v_catfeature record;
v_codeautofill boolean=true;
v_values_array json;
v_record record;
v_gislength float;
v_catalog text;
v_dnom text;
v_pnom text;
v_geom1 text;
v_geom2 text;
v_shape text;
v_matcat_id text;
v_catalogtype varchar;
v_min double precision;
v_max double precision;
v_widgetcontrols json;
v_type text;
v_active_feature text;
v_promixity_buffer double precision;
v_sys_raster_dem boolean=false;
v_edit_insert_elevation_from_dem boolean=false;
v_noderecord1 record;
v_noderecord2 record;
v_input json;
v_presszone_id text;
v_widgetvalues json;
v_automatic_ccode boolean;
v_customercode text = null;
v_use_fire_code_seq boolean;
v_node1 text;
v_node2 text;
v_formtype text;
v_querytext text;
v_isdmaheader boolean = false; -- For those nodes that headers of mapzone
v_isdqaheader boolean = false; -- For those nodes that headers of mapzone
v_issectorheader boolean = false; -- For those nodes that headers of mapzone
v_ispresszoneheader boolean = false; -- For those nodes that headers of mapzone
v_grafdelimiter text;
v_mapzonetype text; -- Type of mapzone for that nodes that ar headers
v_ispresszoneborder boolean = false; -- For those arcs that are on the border of mapzones againts two presszones (one each node)
v_isdqaborder boolean = false; -- For those arcs that are on the border of mapzones againts two dqa (one each node)
v_isdmaborder boolean = false; -- For those arcs that are on the border of mapzones againts two dma (one each node)
v_issectorborder boolean = false; -- For those arcs that are on the border of mapzones againts two sectors (one each node)
v_dqa_id integer;
v_arc_insert_automatic_endpoint boolean;

BEGIN

	-- get basic parameters
	-----------------------
	--  set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get schema name
	schemas_array := current_schemas(FALSE);

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
	iNTO v_version;

	--  get project type
	SELECT project_type INTO v_project_type FROM sys_version LIMIT 1;
	
	--  get system parameters   
	SELECT ((value::json)->>'activated') INTO v_node_proximity_control FROM config_param_system WHERE parameter='edit_node_proximity';
	SELECT ((value::json)->>'value') INTO v_node_proximity FROM config_param_system WHERE parameter='edit_node_proximity';
	SELECT ((value::json)->>'activated') INTO v_connec_proximity_control FROM config_param_system WHERE parameter='edit_connec_proximity';
	SELECT ((value::json)->>'value') INTO v_connec_proximity FROM config_param_system WHERE parameter='edit_connec_proximity';
	SELECT ((value::json)->>'activated') INTO v_gully_proximity_control FROM config_param_system WHERE parameter='edit_gully_proximity';
	SELECT ((value::json)->>'value') INTO v_gully_proximity FROM config_param_system WHERE parameter='edit_gully_proximity';
	SELECT ((value::json)->>'activated') INTO v_arc_searchnodes_control FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='edit_arc_searchnodes';
	SELECT value INTO v_samenode_init_end_control FROM config_param_system WHERE parameter = 'edit_arc_samenode_control';
	SELECT value INTO v_promixity_buffer FROM config_param_system WHERE parameter='edit_feature_buffer_on_mapzone';
	SELECT value INTO v_use_fire_code_seq FROM config_param_system WHERE parameter='edit_hydrant_use_firecode_seq';
	SELECT ((value::json)->>'status') INTO v_automatic_ccode FROM config_param_system WHERE parameter='edit_connec_autofill_ccode';
	SELECT (value)::boolean INTO v_sys_raster_dem FROM config_param_system WHERE parameter='admin_raster_dem';

	-- get user parameters
	SELECT (value)::boolean INTO v_edit_insert_elevation_from_dem FROM config_param_user WHERE parameter='edit_insert_elevation_from_dem' AND cur_user = current_user;
	SELECT (value)::boolean INTO v_arc_insert_automatic_endpoint FROM config_param_user WHERE parameter='edit_arc_insert_automatic_endpoint' AND cur_user = current_user;

	-- get tablename and formname
	-- Common
	v_tablename = p_table_id;
	v_formname = p_table_id;

	-- Special case of visits
	SELECT tablename INTO v_visit_tablename FROM config_visit_class WHERE formname=p_table_id;
	IF v_visit_tablename IS NOT NULL THEN v_tablename = v_visit_tablename; v_formname = p_table_id;	END IF;

	--  get feature propierties
	---------------------------
	v_active_feature = 'SELECT cat_feature.* FROM cat_feature WHERE active IS TRUE
	AND (child_layer = '''|| p_table_id ||''' OR parent_layer = ''' || p_table_id || ''') ORDER BY cat_feature.id';

	EXECUTE v_active_feature INTO v_catfeature;

	-- profilactic control when is not feature
	IF v_catfeature.feature_type IS NULL THEN
		v_catfeature.feature_type = '';
	END IF;

	--  Starting control process
	----------------------------
	IF p_tg_op = 'INSERT' THEN 

		-- urn_id assingment
		IF p_id IS NULL THEN
			p_id = (SELECT nextval('urn_id_seq'));
		END IF;

		IF v_catfeature.code_autofill IS TRUE THEN
			v_code=p_id;
		END IF;

		-- customer code only for connec
		IF v_automatic_ccode IS TRUE THEN	
			v_customercode = p_id;
		END IF;

		-- topology control (enabled without state topocontrol. Does not make sense to activate this because in this phase of workflow
		IF v_topocontrol IS TRUE THEN 
	
			IF upper(v_catfeature.feature_type) ='NODE' THEN
			
				v_numnodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(p_reduced_geometry, node.the_geom, v_node_proximity) AND node.node_id != p_id AND node.state!=0);		
				IF (v_numnodes >1) AND (v_node_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1096]:',error_message, p_id,'. ',hint_message) FROM sys_message WHERE id=1096);
					v_status = false;
				END IF;
				
			ELSIF upper(v_catfeature.feature_type) ='ARC' THEN
			
				SELECT * INTO v_noderecord1 FROM v_edit_node WHERE ST_DWithin(ST_startpoint(p_reduced_geometry), v_edit_node.the_geom, v_arc_searchnodes)
				ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(p_reduced_geometry)) LIMIT 1;
	
				SELECT * INTO v_noderecord2 FROM v_edit_node WHERE ST_DWithin(ST_endpoint(p_reduced_geometry), v_edit_node.the_geom, v_arc_searchnodes)
				ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(p_reduced_geometry)) LIMIT 1;
	
				IF (v_noderecord1.node_id IS NOT NULL) AND (v_noderecord2.node_id IS NOT NULL) THEN

					-- Control of same node initial and final
					IF (v_noderecord1.node_id = v_noderecord2.node_id) AND (v_samenode_init_end_control IS TRUE) THEN
						v_message = (SELECT concat('Error[1040]:',error_message, v_noderecord1.node_id,'. ',hint_message) FROM sys_message WHERE id=1040);
						v_status = false;
					END IF;

					-- getting presszone by heritage from nodes
					IF v_project_type = 'WS' THEN
						IF v_noderecord1.presszone_id = v_noderecord2.presszone_id THEN
							v_presszone_id = v_noderecord1.presszone_id;
						ELSIF v_noderecord1.presszone_id = 0::text THEN
							v_presszone_id = v_noderecord2.presszone_id;
						ELSIF v_noderecord2.presszone_id = 0::text THEN
							v_presszone_id = v_noderecord1.presszone_id;
						ELSIF v_noderecord1.presszone_id::text != v_noderecord2.presszone_id::text THEN
							v_presszone_id = v_noderecord1.presszone_id;
							v_ispresszoneborder = true;						
						END IF;
					END IF;

					-- getting sector_id by heritage from nodes
					IF v_noderecord1.sector_id = v_noderecord2.sector_id THEN
						v_sector_id = v_noderecord1.sector_id;
					ELSIF v_noderecord1.sector_id = 0 THEN
						v_sector_id = v_noderecord2.sector_id;
					ELSIF v_noderecord2.sector_id = 0 THEN
						v_sector_id = v_noderecord1.sector_id;
					ELSIF v_noderecord1.presszone_id::text != v_noderecord2.presszone_id::text THEN
						v_issectorborder = v_noderecord1.presszone_id;
						v_sector_id = true;	
					END IF;

					-- getting dma_id by heritage from nodes
					IF v_noderecord1.dma_id = v_noderecord2.dma_id THEN
						v_dma_id = v_noderecord1.dma_id;
					ELSIF v_noderecord1.dma_id = 0 THEN
						v_dma_id = v_noderecord2.dma_id;
					ELSIF v_noderecord2.dma_id = 0 THEN
						v_dma_id = v_noderecord1.dma_id;
					ELSIF v_noderecord1.dma_id::text != v_noderecord2.dma_id::text THEN
						v_dma_id = v_noderecord1.dma_id;
						v_isdmaborder = true;	
					END IF;

					IF v_project_type = 'WS' THEN
						-- getting dqa_id by heritage from nodes
						IF v_noderecord1.dqa_id = v_noderecord2.dqa_id THEN
							v_dqa_id = v_noderecord1.dqa_id;
						ELSIF v_noderecord1.dqa_id = 0 THEN
							v_dqa_id = v_noderecord2.dqa_id;
						ELSIF v_noderecord2.dqa_id = 0 THEN
							v_dqa_id = v_noderecord1.dqa_id;
						ELSIF v_noderecord1.dqa_id::text != v_noderecord2.dqa_id::text THEN
							v_dqa_id = v_noderecord1.dqa_id;
							v_isdqaborder = true;	
						END IF;
					END IF;

					-- getting expl_id by heritage from nodes
					IF v_noderecord1.expl_id = v_noderecord2.expl_id THEN
						v_expl_id = v_noderecord1.expl_id;
					ELSIF v_noderecord1.expl_id = 0 THEN
						v_expl_id = v_noderecord2.expl_id;
					ELSIF v_noderecord2.expl_id = 0 THEN
						v_expl_id = v_noderecord1.expl_id;
					ELSIF v_noderecord1.expl_id::text != v_noderecord2.expl_id::text THEN
						v_expl_id = v_noderecord1.expl_id;
					END IF;

					-- getting node values in case of arcs (insert)
					v_node1 = v_noderecord1.node_id;
					v_node2 = v_noderecord2.node_id; 
					
				--Error, no existing nodes
				ELSIF ((v_noderecord1.node_id IS NULL) OR (v_noderecord2.node_id IS NULL)) AND (v_arc_searchnodes_control IS TRUE) THEN

					-- if only dosenot exits node 2 and insert_automatic_endpoint
					IF ((v_noderecord1.node_id IS NOT NULL) AND (v_noderecord2.node_id IS NULL)) AND v_arc_insert_automatic_endpoint THEN

					ELSE
						v_message = (SELECT concat('Error[1042]:',error_message, '[node_1]:',v_noderecord1.node_id,'[node_2]:',v_noderecord2.node_id,'. ',hint_message) 
						FROM sys_message WHERE id=1042);
						v_status = false;
					END IF;
				END IF;
	
				--getting 1st approach of gis length
				v_gislength = (SELECT st_length(p_reduced_geometry))::float;		
				
			ELSIF upper(v_catfeature.feature_type) ='CONNEC' THEN 
				v_numnodes := (SELECT COUNT(*) FROM connec WHERE ST_DWithin(p_reduced_geometry, connec.the_geom, v_connec_proximity) AND connec.connec_id != p_id AND connec.state!=0);		
				IF (v_numnodes >1) AND (v_connec_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1044]:',error_message, p_id,'. ',hint_message) FROM sys_message WHERE id=1044);
					v_status = false;
				END IF;
				
			ELSIF upper(v_catfeature.feature_type) ='GULLY' THEN
				v_numnodes := (SELECT COUNT(*) FROM gully WHERE ST_DWithin(p_reduced_geometry, gully.the_geom, v_gully_proximity) AND gully.gully_id != p_id AND gully.state!=0);		
				IF (v_numnodes >1) AND (v_gully_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1045]:',error_message, p_id,'. ',hint_message) FROM sys_message WHERE id=1045);
					v_status = false;
				END IF;
			END IF;
		END IF;

		-- get vdefaults user's mapzones only for nodes (for arcs is disabled because values are taken using heritage from nodes. For connect also because they takes from arc)
		IF upper(v_catfeature.feature_type) = 'NODE' THEN
			SELECT value INTO v_sector_id FROM config_param_user WHERE parameter = 'edit_sector_vdefault' and cur_user = current_user;
			SELECT value INTO v_dma_id FROM config_param_user WHERE parameter = 'edit_dma_vdefault' and cur_user = current_user;
			SELECT value INTO v_expl_id FROM config_param_user WHERE parameter = 'edit_exploitation_vdefault' and cur_user = current_user;
			SELECT value INTO v_muni_id FROM config_param_user WHERE parameter = 'edit_municipality_vdefault' and cur_user = current_user;
			SELECT value INTO v_presszone_id FROM config_param_user WHERE parameter = 'edit_presszone_vdefault' and cur_user = current_user;
		END IF;
				
		-- Presszone
		IF v_project_type = 'WS' AND v_presszone_id IS NULL THEN
			SELECT count(*) into count_aux FROM presszone WHERE ST_DWithin(p_reduced_geometry, presszone.the_geom,0.001);
			IF count_aux = 1 THEN
				v_presszone_id = (SELECT presszone_id FROM presszone WHERE ST_DWithin(p_reduced_geometry, presszone.the_geom,0.001) LIMIT 1);
			ELSE
				v_presszone_id =(SELECT presszone_id FROM v_edit_arc WHERE ST_DWithin(p_reduced_geometry, v_edit_arc.the_geom, v_promixity_buffer)
				order by ST_Distance (p_reduced_geometry, v_edit_arc.the_geom) LIMIT 1);
			END IF;
		END IF;
			
		-- Sector ID
		IF v_sector_id IS NULL THEN
			SELECT count(*) into count_aux FROM sector WHERE ST_DWithin(p_reduced_geometry, sector.the_geom,0.001);
			IF count_aux = 1 THEN
				v_sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(p_reduced_geometry, sector.the_geom,0.001) LIMIT 1);
			ELSE
				v_sector_id =(SELECT sector_id FROM v_edit_arc WHERE ST_DWithin(p_reduced_geometry, v_edit_arc.the_geom, v_promixity_buffer) 
				order by ST_Distance (p_reduced_geometry, v_edit_arc.the_geom) LIMIT 1);
			END IF;
		END IF;
	
		-- Dma ID
		IF v_dma_id IS NULL THEN
			SELECT count(*) into count_aux FROM dma WHERE ST_DWithin(p_reduced_geometry, dma.the_geom,0.001);
			IF count_aux = 1 THEN
				v_dma_id = (SELECT dma_id FROM dma WHERE ST_DWithin(p_reduced_geometry, dma.the_geom,0.001) LIMIT 1);
			ELSE
				v_dma_id =(SELECT dma_id FROM v_edit_arc WHERE ST_DWithin(p_reduced_geometry, v_edit_arc.the_geom, v_promixity_buffer) 
				order by ST_Distance (p_reduced_geometry, v_edit_arc.the_geom) LIMIT 1);
			END IF;
		END IF;

		-- Expl ID
		IF v_expl_id IS NULL THEN
			SELECT count(*) into count_aux FROM exploitation WHERE ST_DWithin(p_reduced_geometry, exploitation.the_geom,0.001);
			IF count_aux = 1 THEN
				v_expl_id = (SELECT expl_id FROM exploitation WHERE ST_DWithin(p_reduced_geometry, exploitation.the_geom,0.001)  AND active=true LIMIT 1);
			ELSE
				v_expl_id =(SELECT expl_id FROM v_edit_arc WHERE ST_DWithin(p_reduced_geometry, v_edit_arc.the_geom, v_promixity_buffer)
				order by ST_Distance (p_reduced_geometry, v_edit_arc.the_geom) LIMIT 1);
			END IF;
		END IF;
	
		-- Macrodma
		v_macrodma_id := (SELECT macrodma_id FROM dma WHERE dma_id=v_dma_id);
					
		-- Macrosector
		v_macrosector_id := (SELECT macrosector_id FROM sector WHERE sector_id=v_sector_id);
	
		-- Municipality 
		v_muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(p_reduced_geometry, ext_municipality.the_geom,0.001) LIMIT 1); 

	ELSIF p_tg_op ='UPDATE' OR p_tg_op ='SELECT' THEN

		-- getting values from feature
		EXECUTE 'SELECT (row_to_json(a)) FROM 
			(SELECT * FROM '||p_table_id||' WHERE '||quote_ident(p_idname)||' = CAST($1 AS '||(p_columntype)||'))a'
			INTO v_values_array
			USING p_id;		
			-- getting node values in case of arcs (update)
			v_node1 := (v_values_array->>'node_1');
			v_node2 := (v_values_array->>'node_2');	
	END IF;

	-- building the form widgets
	----------------------------
	IF  p_configtable is TRUE THEN 
	
		PERFORM gw_fct_debug(concat('{"data":{"msg":"--> Configuration fields are defined on layoutorder table <--", "variables":""}}')::json);

		-- Call the function of feature fields generation
		v_formtype = 'form_feature';	
		v_querytext = 'SELECT gw_fct_getformfields( '||quote_literal(v_formname)||','||quote_literal(v_formtype)||','||quote_literal(v_tabname)||','||quote_literal(v_tablename)||','||quote_literal(p_idname)||','||
		quote_literal(p_id)||','||quote_literal(p_columntype)||','||quote_literal(p_tg_op)||','||'''text'''||','||p_device||','''||COALESCE(v_values_array, '{}')||''' )'; 	

		RAISE NOTICE 'v_querytext %', v_querytext;
		
		SELECT gw_fct_getformfields(v_formname , v_formtype , v_tabname , v_tablename , p_idname , p_id , p_columntype, p_tg_op, NULL, p_device , v_values_array)
		INTO v_fields_array;
			
	ELSE	
		PERFORM gw_fct_debug(concat('{"data":{"msg":"--> Configuration fields are NOT defined on layoutorder table. System values are used <--", "variables":""}}')::json);
	
		-- Get fields
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
			(SELECT a.attname as label, a.attname as columnname, 
			concat('||quote_literal(v_tabname)||',''_'',a.attname) AS widgetname,
			(case when a.atttypid=16 then ''check'' else ''text'' end ) as widgettype, 
			(case when a.atttypid=16 then ''boolean'' else ''string'' end ) as "datatype", 
			''::TEXT AS tooltip, 
			''::TEXT as placeholder, 
			false AS iseditable,
			row_number()over() AS orderby, 
			null as stylesheet, 
			row_number()over() AS layoutorder, 
			FALSE AS isparent, 
			null AS widgetfunction, 
			null AS linkedaction, 
			FALSE AS isautoupdate,
			''lyt_data_1'' AS layoutname, 
			null as widgetcontrols,
			FALSE as hidden
			FROM pg_attribute a
			JOIN pg_class t on a.attrelid = t.oid
			JOIN pg_namespace s on t.relnamespace = s.oid
			WHERE a.attnum > 0 
			AND NOT a.attisdropped
			AND t.relname = $1 
			AND s.nspname = $2
			AND a.attname !=''the_geom''
			AND a.attname !=''geom''
			ORDER BY a.attnum) a'
				INTO v_fields_array
				USING v_tablename, schemas_array[1]; 
	END IF;

	-- Getting node header
	IF v_project_type = 'WS' THEN
		v_grafdelimiter = (SELECT graf_delimiter FROM cat_feature JOIN cat_feature_node USING (id) WHERE child_layer = p_table_id);
		IF v_grafdelimiter = 'PRESSZONE' THEN
			v_ispresszoneheader = true;
			v_mapzonetype = lower(v_grafdelimiter);
		ELSIF v_grafdelimiter = 'DMA' THEN
			v_isdmaheader = true;
			v_mapzonetype = lower(v_grafdelimiter);
		ELSIF v_grafdelimiter = 'DQA' THEN
			v_isdqaheader = true;
			v_mapzonetype = lower(v_grafdelimiter);
		ELSIF v_grafdelimiter = 'SECTOR' THEN
			v_issectorheader = true;
			v_mapzonetype = lower(v_grafdelimiter);
		END IF;
	END IF;
	
	-- Filling the form widgets with values
	---------------------------------------
	-- getting values on insert from vdefault values
	IF p_tg_op ='INSERT' THEN 
	
		-- getting vdefault values
		EXECUTE 'SELECT to_json(array_agg(row_to_json(a)))::text FROM (SELECT sys_param_user.id as parameter, feature_field_id as param, value::text AS vdef FROM sys_param_user 
			JOIN config_param_user ON sys_param_user.id=parameter WHERE cur_user=current_user AND feature_field_id IS NOT NULL AND 
			config_param_user.parameter NOT IN (''edit_workcat_end_vdefault'', ''edit_enddate_vdefault''))a'
			INTO v_values_array;

		-- getting propierties from feature catalog value
		SELECT (a->>'vdef'), (a->>'param') INTO v_catalog, v_catalogtype FROM json_array_elements(v_values_array) AS a 
			WHERE (a->>'param') = 'arccat_id' OR (a->>'param') = 'nodecat_id' OR (a->>'param') = 'connecat_id' OR (a->>'param') = 'gratecat_id';

		IF v_project_type ='WS' AND v_catfeature.feature_type != '' THEN 
			EXECUTE 'SELECT pnom::integer, dnom::integer, matcat_id FROM cat_'||lower(v_catfeature.feature_type)||' WHERE id=$1'
				USING v_catalog
				INTO v_pnom, v_dnom, v_matcat_id;
				
		ELSIF v_project_type ='UD' AND v_catfeature.feature_type != '' THEN 
			IF (v_catfeature.feature_type) ='GULLY' THEN
				EXECUTE 'SELECT matcat_id FROM cat_grate WHERE id=$1'
					USING v_catalog
					INTO v_matcat_id;
			ELSE
				EXECUTE 'SELECT shape, geom1, geom2, matcat_id FROM cat_'||lower(v_catfeature.feature_type)||' WHERE id=$1'
					USING v_catalog
					INTO v_shape, v_geom1, v_geom2, v_matcat_id;
			END IF;
		END IF;					
	END IF;
	
	v_node1 = COALESCE (v_node1, '');
	v_node2 = COALESCE (v_node2, '');
	
	-- gettingf minvalue & maxvalues for widgetcontrols
	IF v_project_type = 'UD' THEN

		v_input = '{"client":{"device":4,"infoType":1,"lang":"es"}, "feature":{"featureType":"'||v_catfeature.feature_type||'", "id":"'||p_id||'"}, "data":{"tgOp":"'||
		p_tg_op||'", "node1":"'||v_node1||'", "node2":"'||v_node2||'"}}';
		SELECT gw_fct_getwidgetvalues (v_input) INTO v_widgetvalues;
		
	END IF;	

	IF p_tg_op != 'LAYER' THEN 
		
		-- looping the array setting values and widgetcontrols
		FOREACH aux_json IN ARRAY v_fields_array 
		LOOP          
			array_index := array_index + 1;

			IF p_tg_op='INSERT' THEN 

				CASE (aux_json->>'columnname')
				
				-- special values
				WHEN quote_ident(p_idname) THEN
					field_value = p_id;
				WHEN concat(lower(v_catfeature.feature_type),'_type') THEN 
					EXECUTE 'SELECT id FROM cat_feature WHERE child_layer = ''' || p_table_id ||''' LIMIT 1' INTO field_value;
				WHEN 'code' THEN 
					field_value = v_code;
				WHEN 'customer_code' THEN 
					field_value = v_customercode;
				WHEN 'node_1' THEN 
					field_value = v_noderecord1.node_id;
				WHEN 'node_2' THEN 
					field_value = v_noderecord2.node_id;
				WHEN 'gis_length' THEN 
					field_value = v_gislength;
				WHEN 'epa_type' THEN 
					EXECUTE 'SELECT epa_default FROM cat_feature_'||(v_catfeature.feature_type)||' WHERE id = $1'INTO field_value USING v_catfeature.id;
				WHEN 'fire_code' THEN
					IF v_use_fire_code_seq THEN	
						field_value = nextval ('man_hydrant_fire_code_seq'::regclass);
					END IF;

				-- dynamic mapzones
				WHEN 'presszone_id' THEN
					field_value = v_presszone_id;			
				WHEN 'sector_id' THEN 
					field_value = v_sector_id;
				WHEN 'dma_id' THEN 
					field_value = v_dma_id;
				WHEN 'dqa_id' THEN 
					field_value = v_dqa_id;
	
				-- static mapzones	
				WHEN 'macrosector_id' THEN 
					field_value = v_macrosector_id;
				WHEN 'macrodma_id' THEN 
					field_value = v_macrodma_id;
				WHEN 'expl_id' THEN 
					field_value = v_expl_id;
				WHEN 'muni_id' THEN 
					field_value = v_muni_id;

				-- elevation from raster
				WHEN 'elevation', 'top_elev' THEN 
					IF v_sys_raster_dem AND v_edit_insert_elevation_from_dem THEN
						field_value = (SELECT ST_Value(rast,1, p_reduced_geometry, true) FROM v_ext_raster_dem WHERE 
						id = (SELECT id FROM v_ext_raster_dem WHERE st_dwithin (envelope, p_reduced_geometry, 1) LIMIT 1))::numeric (12,3);
					ELSE
						field_value = null;
					END IF;
								
				-- catalog values
				WHEN 'cat_dnom' THEN
					field_value = v_dnom;
				WHEN 'cat_pnom' THEN
					field_value = v_pnom;
				WHEN 'cat_geom1' THEN
					field_value = v_geom1;
				WHEN 'cat_geom2' THEN
					field_value = v_geom2;
				WHEN 'cat_shape' THEN
					field_value = v_shape;
				WHEN 'matcat_id' THEN	
					field_value = v_matcat_id;
				WHEN concat(lower(v_catfeature.feature_type),'cat_id') THEN	
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a
					 WHERE a->>'parameter' = concat('feat_', lower(v_catfeature.id), '_vdefault');
				WHEN 'connecat_id' THEN    
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a
					WHERE a->>'parameter' = concat('feat_', lower(v_catfeature.id), '_vdefault');


				-- *_type
				WHEN 'fluid_type' THEN	
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a 
					WHERE ((a->>'param') = (aux_json->>'columnname') AND a->>'parameter' = concat('edit_', lower(v_catfeature.feature_type), '_fluid_vdefault'));
				WHEN 'function_type' THEN	
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a 
					WHERE ((a->>'param') = (aux_json->>'columnname') AND a->>'parameter' = concat('edit_', lower(v_catfeature.feature_type), '_function_vdefault'));
				WHEN 'location_type' THEN	
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a 
					WHERE ((a->>'param') = (aux_json->>'columnname') AND a->>'parameter' = concat('edit_', lower(v_catfeature.feature_type), '_location_vdefault'));
				WHEN 'category_type' THEN	
					SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a 
					WHERE ((a->>'param') = (aux_json->>'columnname') AND a->>'parameter' = concat('edit_', lower(v_catfeature.feature_type), '_category_vdefault'));
					
				-- state type
				WHEN 'state_type' THEN
					-- getting parent value
					SELECT (a->>'vdef') INTO v_state_value FROM json_array_elements(v_values_array) AS a WHERE (a->>'param') = 'state';

					-- prevent possible null values for state vdefault
					IF v_state_value IS NULL THEN 
						v_state_value=1;
					END IF;

					v_querytext = 'SELECT value::text FROM sys_param_user JOIN config_param_user ON sys_param_user.id=parameter 
					WHERE cur_user=current_user AND parameter = concat(''edit_statetype_'','||v_state_value||',''_vdefault'')';
					
					EXECUTE v_querytext INTO field_value;
							
				-- rest (including addfields)
				ELSE SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a WHERE (a->>'param') = (aux_json->>'columnname'); 
				END CASE;
			
				--specific values for ud
				IF v_project_type = 'UD' THEN

					CASE (aux_json->>'columnname')		
					WHEN 'sys_y1' THEN
						field_value =v_noderecord1.sys_ymax;
					WHEN 'sys_elev1' THEN
						field_value =v_noderecord1.sys_elev;
					WHEN 'sys_y2' THEN
						field_value =v_noderecord2.sys_ymax;
					WHEN 'sys_elev2' THEN
						field_value =v_noderecord2.sys_elev;	
					WHEN 'gratecat_id' THEN
						SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a 	WHERE (a->>'param') = 'gratecat_id';
					ELSE
					END CASE;
				END IF;

				-- force enabled for arc mapzone borders
				IF 	(v_ispresszoneborder AND (aux_json->>'columnname') = 'presszone_name') OR
					(v_isdmaborder AND (aux_json->>'columnname') = 'dma_name') OR
					(v_isdqaborder AND (aux_json->>'columnname') = 'dqa_name') OR 
					(v_issectorborder AND (aux_json->>'columnname') = 'sector_name') THEN
						v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'iseditable', 'true'::boolean);	
				END IF;
				
			ELSIF  p_tg_op ='UPDATE' OR p_tg_op ='SELECT' THEN 
				field_value := (v_values_array->>(aux_json->>'columnname'));
			END IF;
		
			-- setting values
			IF (aux_json->>'widgettype')='combo' THEN 
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'selectedId', COALESCE(field_value, ''));
			ELSE 
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', COALESCE(field_value, ''));
			END IF;	
			
			-- setting widgetcontrols
			IF (aux_json->>'datatype')='double' OR (aux_json->>'datatype')='integer' OR (aux_json->>'datatype')='numeric' THEN 
				v_widgetcontrols = gw_fct_json_object_set_key ((aux_json->>'widgetcontrols')::json, 'maxMinValues' ,(v_widgetvalues->>(aux_json->>'columnname'))::json);
				v_fields_array[array_index] := gw_fct_json_object_set_key (v_fields_array[array_index], 'widgetcontrols', v_widgetcontrols);
			END IF;
			
			-- force enabled widget of mapzones for nodes headers (insert or update)
			IF 	(v_isdmaheader AND (aux_json->>'columnname'='dma_name')) OR 
				(v_isdqaheader AND (aux_json->>'columnname'='dqa_name')) OR 
				(v_issectorheader AND (aux_json->>'columnname'='sector_name')) OR 
				(v_ispresszoneheader AND (aux_json->>'columnname'='presszone_name')) THEN
					v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'iseditable', 'true'::boolean);
			END IF;
		END LOOP;  
	END IF;
	
	-- Convert to json
	v_fields := array_to_json(v_fields_array);

	raise notice 'v_fields %', v_fields;

	-- Control NULL's
	v_version := COALESCE(v_version, '[]');
	v_fields := COALESCE(v_fields, '[]');    
	v_message := COALESCE(v_message, '[]');    
    
	-- Return
	IF v_status IS TRUE THEN
		RETURN v_fields;
	ELSE 
		RETURN ('{"status":"Failed" '||
			',"message":{"level":2, "text":"'||v_message||'"}'||
			',"apiVersion":'||v_version||
			',"body":{'||
				'"form":{}'||
				',"feature":{}'||
				',"data":{}'||
				'}'||
			'}')::json;
	END IF;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;