/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/
--FUNCTION CODE: 2976

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_json_create_return(json, integer);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_json_create_return(
    p_data json,
    p_fnumber integer,
    p_returnmanager json,
    p_layermanager json,
    p_actions json)
  RETURNS json AS
$BODY$

DECLARE

v_actions json;
v_body json;
v_geom_field text;
v_json_array json[];
v_layer_zoom text;
v_layermanager json;
v_layervisible_array text[];
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

	-- getting parameters
	IF (SELECT 1 FROM information_schema.columns WHERE table_schema='SCHEMA_NAME' AND table_name='config_function' AND column_name='returnmanager') = 1 THEN
		IF p_returnmanager IS NOT NULL THEN v_returnmanager = p_returnmanager; ELSE v_returnmanager = (SELECT returnmanager FROM config_function where id = p_fnumber); END IF;
	ELSE
		IF p_returnmanager IS NOT NULL THEN v_returnmanager = p_returnmanager; ELSE v_returnmanager = (SELECT style FROM config_function where id = p_fnumber); END IF;
	END IF;
	If p_layermanager IS NOT NULL THEN v_layermanager = p_layermanager; ELSE v_layermanager = (SELECT layermanager FROM config_function where id = p_fnumber); END IF;
	If p_actions IS NOT NULL THEN v_actions = p_actions; ELSE v_actions = (SELECT actions FROM config_function where id = p_fnumber); END IF;

	-- return manager
	IF v_returnmanager IS NOT NULL THEN
		v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'returnManager', v_returnmanager);
		p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);
	END IF;	
	
	-- layer manager
	IF v_layermanager IS NOT NULL THEN

		-- visible
		v_layervisible = v_layermanager->>'visible';
		v_layervisible_array = (select array_agg(value) as list from  json_array_elements_text(v_layervisible));
		IF v_layervisible_array IS NOT NULL THEN
			FOREACH v_rec IN ARRAY (v_layervisible_array) LOOP
				v_geom_field = (SELECT gw_fct_getgeomfield(v_rec));
				v_pkey_field = (SELECT gw_fct_getpkeyfield(v_rec));
				EXECUTE 'SELECT jsonb_build_object ('''||v_rec||''',feature)
					FROM	(
					SELECT jsonb_build_object(
					''geom_field'', '''||v_geom_field||''',
					''pkey_field'', '''||v_pkey_field||''',
					''style_id'', style, 
					''group_layer'', group_layer,
					''alias'', alias
					) AS feature
					FROM (SELECT style, group_layer, alias from sys_table 
						LEFT JOIN config_table USING (id)
						WHERE id = '''||v_rec||'''
					) row) a;'
				INTO v_result;
				SELECT array_append(v_json_array, v_result) into v_json_array;
				v_layermanager = gw_fct_json_object_set_key((v_layermanager)::json, 'visible', v_json_array);
			END LOOP;
		END IF;
			
		v_body = gw_fct_json_object_set_key((p_data->>'body')::json, 'layerManager', v_layermanager);
		p_data = gw_fct_json_object_set_key((p_data)::json, 'body', v_body);

		--zoom layer must be included on visible layer
	END IF;


	-- ACTIONS
	-- The name of the function must match the name of the function in python, and if the python function requires parameters, they must be called as required by that function.
	-- example how fill column actions :	[{"funcName":"test1","params":{"layerName":"ve_arc","qmlPath":"C:\\Users\\Nestor\\Desktop\\11111.qml"}},
	--					 {"funcName":"test2"}]
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