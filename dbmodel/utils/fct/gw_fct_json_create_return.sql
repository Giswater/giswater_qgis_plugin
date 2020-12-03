/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: 2976

-- Function: SCHEMA_NAME.gw_fct_json_create_return(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_json_create_return(json);


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_json_create_return(
    p_data json,
    p_fnumber integer)
  RETURNS json AS
$BODY$

DECLARE

v_actions json;
v_body json;
v_geom_field text;
v_json_array json[];
v_layer_zoom text;
v_layermanager json;
v_layermanager_array text[];
v_layervisible json;
v_pkey_field character varying;
v_rec text;
v_result json;
v_return json;
v_returnmanager json;
v_visible json;
v_zoomed_exist boolean ;

BEGIN
	-- Search path
	SET search_path = 'SCHEMA_NAME', public;
	
	-- RETURN MANAGER	
	v_returnmanager = (SELECT returnmanager FROM config_function where id = p_fnumber);
	IF v_returnmanager IS NOT NULL THEN
		v_returnmanager = gw_fct_json_object_set_key((v_returnmanager)::json, 'functionId', p_fnumber);
		v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'returnManager', v_returnmanager);
		p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);
		
	END IF;	

	
	-- LAYER MANAGER	
	IF ((p_data->>'body')::json)->>'layerManager' IS NULL THEN
		v_layer_zoom = (v_layermanager->>'zoom')::json->>'layer';
		v_layermanager = (SELECT layermanager FROM config_function where id = p_fnumber);
		IF v_layermanager IS NOT NULL THEN
			v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'functionId', p_fnumber);
			v_layervisible = v_layermanager->>'visible';
			v_layermanager_array = (select array_agg(value) as list from  json_array_elements_text(v_layervisible));
			
			v_zoomed_exist = false;			

			IF v_layermanager_array IS NOT NULL THEN
				FOREACH v_rec IN ARRAY (v_layermanager_array) LOOP
					IF v_layer_zoom = v_rec THEN v_zoomed_exist = true; END IF;
	                
					v_geom_field = (SELECT gw_fct_getgeomfield(v_rec));
					v_pkey_field = (SELECT gw_fct_getpkeyfield(v_rec));
					EXECUTE 'SELECT jsonb_build_object ('''||v_rec||''',feature)
						FROM	(
						SELECT jsonb_build_object(
						''geom_field'', '''||v_geom_field||''',
						''pkey_field'', '''||v_pkey_field||''',
						''style_id'', style, 
						''group_layer'', group_layer
						) AS feature
						FROM (SELECT style, group_layer from sys_table 
							LEFT JOIN config_table USING (id)
							WHERE id = '''||v_rec||'''
						) row) a;'
					INTO v_result;
					SELECT array_append(v_json_array, v_result) into v_json_array;
					v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'visible', v_json_array);
				END LOOP;
			END IF;
			-- If the layer we are going to zoom is not already in the json, we add it
			IF v_layer_zoom IS NOT NULL AND v_zoomed_exist IS false THEN
				v_geom_field = (SELECT gw_fct_getgeomfield(v_rec));
				v_pkey_field = (SELECT gw_fct_getpkeyfield(v_rec));
				EXECUTE 'SELECT jsonb_build_object ('''||v_rec||''',feature)
					FROM	(
					SELECT jsonb_build_object(
					''geom_field'', '''||v_geom_field||''',
					''pkey_field'', '''||v_pkey_field||''',
					''style_id'', style, 
					''group_layer'', group_layer
					) AS feature
					FROM (SELECT style, group_layer from sys_table 
						LEFT JOIN config_table USING (id)
						WHERE id = '''||v_rec||'''
					) row) a;'
				INTO v_result;

				SELECT array_append(v_json_array, v_result) into v_json_array;
				v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'visible', v_json_array);
			END IF;
			v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'layerManager', v_layermanager);
			p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);
		END IF;
	END IF;

	
	
	-- ACTIONS
	-- The name of the function must match the name of the function in python, and if the python function requires parameters, they must be called as required by that function.
	-- example how fill column actions :	[{"funcName":"test1","params":{"layerName":"v_edit_arc","qmlPath":"C:\\Users\\Nestor\\Desktop\\11111.qml"}},
	--					 {"funcName":"test2"}]
	v_actions = (SELECT actions FROM config_function where id = p_fnumber);
	v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'python_actions', v_actions);
	p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);
	
	-- Control nulls
	v_returnmanager := COALESCE(v_returnmanager, '{}');
	v_layermanager := COALESCE(v_layermanager, '{}');
	 	
		
	-- Return
	RETURN p_data;
	  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;