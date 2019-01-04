/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2560

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_get_featureupsert(
    p_table_id character varying,
    p_id character varying,
    p_reduced_geometry geometry,
    p_device integer,
    p_info_type integer,
    p_tg_op character varying,
    p_configtable boolean)
  RETURNS json AS
$BODY$
DECLARE

/*EXAMPLE
arc with no nodes
SELECT SCHEMA_NAME.gw_api_get_featureupsert('ve_arc_pipe', null, '0102000020E764000002000000000000A083198641000000669A33C041000000E829D880410000D0AE90F0F341', 9, 100,'INSERT', true)
arc with nodes
SELECT SCHEMA_NAME.gw_api_get_featureupsert('ve_arc_pipe', null, '0102000020E764000002000000998B3C512F881941B28315AA7F76514105968D7D748819419FDF72D781765141', 9, 100,'INSERT', true)
SELECT SCHEMA_NAME.gw_api_get_featureupsert('ve_arc_pipe', '2001', null, 9, 100,'UPDATE', true)
*/

	v_columntype character varying;
	v_fields json;
	v_fields_array json[];
	aux_json json;    
	combo_json json;
	schemas_array name[];
	array_index integer DEFAULT 0;
	field_value character varying;
	v_apiversion json;
	v_selected_id text;
	v_vdefault text;
	v_id int8;
	v_numnodes integer;
	v_node1 varchar;
	v_node2 varchar;
	v_idname text;
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
	v_values_array_json json[];
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
	
BEGIN

-- get basic parameters
-----------------------
     --  set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

     --  get schema name
    schemas_array := current_schemas(FALSE);

     --  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
	INTO v_apiversion;

     --  get project type
    SELECT wsoftware INTO v_project_type FROM version LIMIT 1;
    
     --  get config parameters   
    SELECT value INTO v_node_proximity FROM config_param_system WHERE parameter = 'node_proximity';
    SELECT value INTO v_node_proximity_control FROM config_param_system WHERE parameter = 'node_proximity_control';
    SELECT value INTO v_connec_proximity FROM config_param_system WHERE parameter = 'connec_proximity';
    SELECT value INTO v_connec_proximity_control FROM config_param_system WHERE parameter = 'connec_proximity_control';
    SELECT value INTO v_gully_proximity FROM config_param_system WHERE parameter = 'gully_proximity';
    SELECT value INTO v_gully_proximity_control FROM config_param_system WHERE parameter = 'gully_proximity_control';
    SELECT value INTO v_arc_searchnodes FROM config_param_system WHERE parameter = 'arc_searchnodes';
    SELECT value INTO v_samenode_init_end_control FROM config_param_system WHERE parameter = 'samenode_init_end_control';
    SELECT value INTO v_arc_searchnodes_control FROM config_param_system WHERE parameter = 'arc_searchnodes_control';
      
    -- get tablename and formname
    -- Common
     v_tablename = p_table_id;
     v_formname = p_table_id;

    -- Special case of visits
    SELECT tablename INTO v_visit_tablename FROM config_api_visit WHERE formname=p_table_id;
     IF v_visit_tablename IS NOT NULL THEN
	v_tablename = v_visit_tablename;
	v_formname = p_table_id;
     END IF;

--  get feature propierties
---------------------------
    SELECT * INTO v_catfeature FROM cat_feature WHERE child_layer = p_table_id;

    -- Get id column
    EXECUTE 'SELECT a.attname FROM pg_index i JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey) WHERE  i.indrelid = $1::regclass AND i.indisprimary'
        INTO v_idname
        USING v_tablename;
        
    -- For views it suposse pk is the first column
    IF v_idname ISNULL THEN
        EXECUTE 'SELECT a.attname FROM pg_attribute a   JOIN pg_class t on a.attrelid = t.oid  JOIN pg_namespace s on t.relnamespace = s.oid WHERE a.attnum > 0   AND NOT a.attisdropped
		AND t.relname = $1 
		AND s.nspname = $2
		ORDER BY a.attnum LIMIT 1'
		INTO v_idname
		USING v_tablename, schemas_array[1];
    END IF;

    -- get id column type
    EXECUTE 'SELECT pg_catalog.format_type(a.atttypid, a.atttypmod) FROM pg_attribute a
	    JOIN pg_class t on a.attrelid = t.oid
	    JOIN pg_namespace s on t.relnamespace = s.oid
	    WHERE a.attnum > 0 
	    AND NOT a.attisdropped
	    AND a.attname = $3
	    AND t.relname = $2 
	    AND s.nspname = $1
	    ORDER BY a.attnum'
            USING schemas_array[1], v_tablename, v_idname
            INTO v_columntype;

--  Starting control process
----------------------------
	IF p_tg_op = 'INSERT' THEN 

		-- urn_id assingment
		v_id = (SELECT nextval('urn_id_seq'));
		IF v_catfeature.code_autofill IS TRUE THEN
			v_code=v_id;
		END IF;

		-- topology control (enabled without state topocontrol. Does not make sense to activate this because in this phase of workflow
		IF v_topocontrol IS TRUE THEN 
	
			IF v_catfeature.type ='NODE' THEN
			
				v_numnodes := (SELECT COUNT(*) FROM node WHERE ST_DWithin(p_reduced_geometry, node.the_geom, v_node_proximity) AND node.node_id != p_id AND node.state!=0);		
				IF (v_numnodes >1) AND (v_node_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1096]:',error_message, v_id,'. ',hint_message) FROM audit_cat_error WHERE id=1096);
					v_status = false;
				END IF;
			ELSIF v_catfeature.type ='ARC' THEN
			
				SELECT node_id INTO v_node1 FROM v_edit_node WHERE ST_DWithin(ST_startpoint(p_reduced_geometry), v_edit_node.the_geom, v_arc_searchnodes)
				ORDER BY ST_Distance(v_edit_node.the_geom, ST_startpoint(p_reduced_geometry)) LIMIT 1;
	
				SELECT node_id INTO v_node2 FROM v_edit_node WHERE ST_DWithin(ST_endpoint(p_reduced_geometry), v_edit_node.the_geom, v_arc_searchnodes)
				ORDER BY ST_Distance(v_edit_node.the_geom, ST_endpoint(p_reduced_geometry)) LIMIT 1;
	
				IF (v_node1 IS NOT NULL) AND (v_node2 IS NOT NULL) THEN

					-- Control of same node initial and final
					IF (v_node1 = v_node2) AND (v_samenode_init_end_control IS TRUE) THEN
						v_message = (SELECT concat('Error[1041]:',error_message, v_node1,'. ',hint_message) FROM audit_cat_error WHERE id=1041);
						v_status = false;
					END IF;
				--Error, no existing nodes
				ELSIF ((v_node1 IS NULL) OR (v_node2 IS NULL)) AND (v_arc_searchnodes_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1043]:',error_message, '[node_1]:',v_node1,'[node_2]:',v_node2,'. ',hint_message) FROM audit_cat_error WHERE id=1043);
					v_status = false;
				END IF;
	
				--getting gis length
				v_gislength = (SELECT st_length(p_reduced_geometry))::float;
				
			ELSIF v_catfeature.type ='CONNEC' THEN 
				v_numnodes := (SELECT COUNT(*) FROM connec WHERE ST_DWithin(p_reduced_geometry, connec.the_geom, v_connec_proximity) AND connec.connec_id != p_id AND connec.state!=0);		
				IF (v_numnodes >1) AND (v_connec_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1044]:',error_message, v_id,'. ',hint_message) FROM audit_cat_error WHERE id=1044);
					v_status = false;
				END IF;
				
			ELSIF v_catfeature.type ='GULLY' THEN
				v_numnodes := (SELECT COUNT(*) FROM gully WHERE ST_DWithin(p_reduced_geometry, gully.the_geom, v_gully_proximity) AND gully.gully_id != p_id AND gully.state!=0);		
				IF (v_numnodes >1) AND (v_gully_proximity_control IS TRUE) THEN
					v_message = (SELECT concat('Error[1045]:',error_message, v_id,'. ',hint_message) FROM audit_cat_error WHERE id=1045);
					v_status = false;
				END IF;
			END IF;
		END IF;
			
		-- map zones controls
		-- Sector ID
		SELECT count(*) into count_aux FROM sector WHERE ST_DWithin(p_reduced_geometry, sector.the_geom,0.001);
		IF count_aux = 1 THEN
			v_sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(p_reduced_geometry, sector.the_geom,0.001) LIMIT 1);
		ELSIF count_aux > 1 THEN
			v_sector_id =(SELECT sector_id FROM v_edit_node WHERE ST_DWithin(p_reduced_geometry, v_edit_node.the_geom, promixity_buffer_aux) 
			order by ST_Distance (p_the_geom, v_edit_node.the_geom) LIMIT 1);
		END IF;	
	
		-- Macrosector
		v_macrosector_id := (SELECT macrosector_id FROM sector WHERE sector_id=v_sector_id);
	
		-- Dma ID
		SELECT count(*) into count_aux FROM dma WHERE ST_DWithin(p_reduced_geometry, dma.the_geom,0.001);
		IF count_aux = 1 THEN
			v_dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(p_reduced_geometry, dma.the_geom,0.001) LIMIT 1);
		ELSIF count_aux > 1 THEN
			v_dma_id =(SELECT dma_id FROM v_edit_node WHERE ST_DWithin(p_reduced_geometry, v_edit_node.the_geom, promixity_buffer_aux) 
			order by ST_Distance (p_the_geom, v_edit_node.the_geom) LIMIT 1);
		END IF;
	
		-- Macrodma
		v_macrodma_id := (SELECT macrodma_id FROM dma WHERE dma_id=v_dma_id);
					
		-- Exploitation
		v_expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(p_reduced_geometry, exploitation.the_geom,0.001) LIMIT 1);
	
		-- Municipality 
		v_muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(p_reduced_geometry, ext_municipality.the_geom,0.001) LIMIT 1); 
	
	END IF;
	
-- building the form widgets
----------------------------
	IF  p_configtable is TRUE THEN 
		raise notice 'Configuration fields are defined on config_api_layer_field';
		
		-- Call the function of feature fields generation
		SELECT gw_api_get_formfields( v_formname, 'feature', v_tabname, v_tablename, v_idname, p_id, v_columntype, p_tg_op, null,p_device) INTO v_fields_array; 
		
	ELSE
		raise notice 'Configuration fields are NOT defined on config_api_layer_field. System values will be used';
	
		-- Get fields
		EXECUTE 'SELECT array_agg(row_to_json(a)) FROM 
			(SELECT a.attname as label, a.attname as column_id, concat('||quote_literal(v_tabname)||',''_'',a.attname) AS widgetname,
			''text'' as widgettype, ''string'' as "datatype", ''::TEXT AS tooltip, ''::TEXT as placeholder, true AS iseditable, false as isclickable,
			row_number()over() AS orderby,
			3 AS layout_id, 
			row_number()over() AS layout_order, 
			FALSE AS dv_parent_id, FALSE AS isparent, FALSE AS button_function, ''::TEXT AS dv_querytext, ''::TEXT AS dv_querytext_filterc, FALSE AS action_function, FALSE AS isautoupdate
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
	
-- Filling the form widgets with values
---------------------------------------
	-- getting values on insert from vdefault values
	IF p_tg_op ='INSERT' THEN 
	
		-- getting vdefault values
		EXECUTE 'SELECT to_json(array_agg(row_to_json(a)))::text FROM (SELECT feature_field_id as param, value::text AS vdef FROM audit_cat_param_user 
			JOIN config_param_user ON audit_cat_param_user.id=parameter WHERE cur_user=current_user AND feature_field_id IS NOT NULL)a'
			INTO v_values_array;

		-- getting propierties from feature catalog value
		SELECT (a->>'vdef'), (a->>'param') INTO v_catalog, v_catalogtype FROM json_array_elements(v_values_array) AS a 
			WHERE (a->>'param') = 'arccat_id' OR (a->>'param') = 'nodecat_id' OR (a->>'param') = 'connecat_id' OR (a->>'param') = 'gratecat_id';

		IF v_project_type ='WS' THEN 
			EXECUTE 'SELECT pn, dn, matcat_id FROM cat_'||lower(v_catfeature.type)||' WHERE id=$1'
				USING v_catalog
				INTO v_pnom, v_dnom, v_matcat_id;
		ELSIF v_projecttype ='UD' THEN 
			IF v_catfeature.type ='GULLY' THEN
				EXECUTE 'SELECT matcat_id FROM cat_'||lower(v_catfeature.type)||' WHERE id=$1'
					USING v_catalog
					INTO v_matcat_id;
			ELSE
				EXECUTE 'SELECT shape, geom1, geom2, matcat_id FROM cat_'||lower(v_catfeature.type)||' WHERE id=$1'
					USING v_catalog
					INTO v_shape, v_geom1, v_geom2, v_matcat_id;
			END IF;
		END IF;
		
	-- getting values on insert from feature
	ELSIF p_tg_op ='UPDATE' THEN	
		EXECUTE 'SELECT (row_to_json(a)) FROM 
			(SELECT * FROM '||p_table_id||' WHERE '||v_idname||' = CAST($1 AS '||v_columntype||'))a'
			INTO v_values_array
			USING p_id;
	END IF;

	-- setting values
	FOREACH aux_json IN ARRAY v_fields_array 
        LOOP          
		array_index := array_index + 1;

		-- setting the values
		IF p_tg_op='INSERT' THEN 
			-- special values
			IF (aux_json->>'column_id') = quote_ident(v_idname) THEN
				field_value = v_id;
			ELSIF (aux_json->>'column_id') = concat(lower(v_catfeature.type),'_type') THEN
				field_value = v_catfeature.type;
			ELSIF (aux_json->>'column_id') = 'code' THEN
				field_value = v_code;
			ELSIF (aux_json->>'column_id') = 'node_1' THEN
				field_value = v_node1;
			ELSIF (aux_json->>'column_id') = 'node_2' THEN
				field_value = v_node2;
			ELSIF (aux_json->>'column_id') = 'gis_length' THEN
				field_value = v_gislength;
			ELSIF  (aux_json->>'column_id')='epa_type' THEN
				EXECUTE 'SELECT epa_default FROM '||(v_catfeature.type)||'_type WHERE id = $1'
					INTO field_value
					USING v_catfeature.system_id;
			-- mapzones values
			ELSIF (aux_json->>'column_id') = 'sector_id' THEN
				field_value = v_sector_id;
			ELSIF (aux_json->>'column_id') = 'macrosector_id' THEN
				field_value = v_macrosector_id;
			ELSIF (aux_json->>'column_id') = 'dma_id' THEN
				field_value = v_dma_id;
			ELSIF (aux_json->>'column_id') = 'macrodma_id' THEN
				field_value = v_macrodma_id;
			ELSIF (aux_json->>'column_id') = 'expl_id' THEN
				field_value = v_expl_id;
			ELSIF (aux_json->>'column_id') = 'muni_id' THEN
				field_value = v_muni_id;
			-- catalog values
			ELSIF (aux_json->>'column_id')='cat_dnom' THEN
				field_value = v_dnom;
			ELSIF (aux_json->>'column_id')='cat_pnom' THEN
				field_value = v_pnom;
			ELSIF (aux_json->>'column_id')='cat_geom1' THEN
				field_value = v_geom1;
			ELSIF (aux_json->>'column_id')='cat_geom2' THEN
				field_value = v_geom2;
			ELSIF (aux_json->>'column_id')='cat_geom2' THEN
				field_value = v_shape;
			ELSIF (aux_json->>'column_id')='matcat_id' THEN	
				field_value = v_matcat_id;
			-- rest of vaules
			ELSE
				SELECT (a->>'vdef') INTO field_value FROM json_array_elements(v_values_array) AS a WHERE (a->>'param') = (aux_json->>'column_id');
			END IF;
				
		ELSIF  p_tg_op ='UPDATE' THEN 
				field_value := (v_values_array->>(aux_json->>'column_id'));
		END IF;

		-- setting the array
		IF (aux_json->>'widgettype')='combo' THEN 
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'selectedId', COALESCE(field_value, ''));
		ELSE 
				v_fields_array[array_index] := gw_fct_json_object_set_key(v_fields_array[array_index], 'value', COALESCE(field_value, ''));
		END IF;
	
        END LOOP;  
   
--    Convert to json
    v_fields := array_to_json(v_fields_array);

--    Control NULL's
      v_apiversion := COALESCE(v_apiversion, '[]');
      v_fields := COALESCE(v_fields, '[]');    
    
--    Return
      IF v_status IS TRUE THEN
		RETURN v_fields;
      ELSE 
		RETURN ('{"status":"Failed" '||
			',"message":{"priority":2, "text":"'||v_message||'"}'||
			',"apiVersion":'||v_apiversion||
			',"body":{'||
				'"form":{}'||
				',"feature":{}'||
				',"data":{}'||
				'}'||
			'}')::json;
      END IF;
		
--    Exception handling
 --   EXCEPTION WHEN OTHERS THEN 
   --     RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
