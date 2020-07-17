/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

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
v_returnmanager json;
v_layermanager json;
v_return json;
v_layermanager_array text[];
v_layervisible json;
rec text;
v_result json;
v_json_array json[];
v_visible json;
v_layer_zoom text;
v_zoomed_exist boolean ;
BEGIN
	-- Search path
	SET search_path = 'SCHEMA_NAME', public;
	
	-- RETURN MANAGER	
	-- example for:
	--	categorized:	[{"layerName":"v_edit_arc","style":"categorized","field":"expl_id","width":2,"opacity":0.5,"values":[{"id":2,"color":[255,0,0]},{"id":1,"color":[0,2,250]}]}]
	-- example1: v_style: {["layer":"tablename1", "mode":"Disabled", "parameters": null], ["layer":"tablename2", "mode":"basicRGB", "parameters": [R,G,B, opacidad]], ["layer":"tablename3", "mode":"qml", "parameters": {"id":4}]}
	-- example2: v_style: {["layer":"temp_point", "mode":"Disabled", "parameters": null], ["layer":"temp_line", "mode":"BasicRGB", "parameters": [R,G,B, opacidad]], ["layer":"temp_pol", "mode":"qml", "parameters": {"id":4}]}
	v_returnmanager = (SELECT returnmanager FROM config_function where id = p_fnumber);
	v_returnmanager = gw_fct_json_object_set_key((v_returnmanager)::json, 'functionId', p_fnumber);
	v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'returnManager', v_returnmanager);
	p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);
	
	-- LAYER MANAGER
	
	IF ((p_data->>'body')::json)->>'layerManager' IS NULL THEN

		v_layermanager = (SELECT layermanager FROM config_function where id = p_fnumber);
		v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'functionId', p_fnumber);
		v_layervisible = v_layermanager->>'visible';		
		v_layermanager_array = (select array_agg(value) as list from  json_array_elements_text(v_layervisible));
		v_layer_zoom = (v_layermanager->>'zoom')::json->>'layer';
		v_zoomed_exist = false;
		FOREACH rec IN ARRAY (v_layermanager_array) LOOP
			IF v_layer_zoom = rec THEN v_zoomed_exist = true; END IF;
			
			EXECUTE 'SELECT jsonb_build_object ('''||rec||''',feature)
				FROM	(
				SELECT jsonb_build_object(
				''field_geom'', field_geom,
				''field_id'',field_id
				) AS feature
				FROM (SELECT field_geom, field_id from sys_table WHERE id = '''||rec||''') row) a;'
			INTO v_result;

			SELECT array_append(v_json_array, v_result) into v_json_array;
			v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'visible', v_json_array);			
		END LOOP;
		-- If the layer we are going to zoom is not already in the json, we add it
		IF v_zoomed_exist IS false THEN
			EXECUTE 'SELECT jsonb_build_object ('''||v_layer_zoom||''',feature)
				FROM	(
				SELECT jsonb_build_object(
				''field_geom'', field_geom,
				''field_id'',field_id
				) AS feature
				FROM (SELECT field_geom, field_id from sys_table WHERE id = '''||v_layer_zoom||''') row) a;'
			INTO v_result;
			
			SELECT array_append(v_json_array, v_result) into v_json_array;
			v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'visible', v_json_array);
		END IF;
	
		v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'layerManager', v_layermanager);
		p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);

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