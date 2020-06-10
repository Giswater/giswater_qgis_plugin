/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2870

DROP FUNCTION IF EXISTS ws_sample.gw_api_setselectors (json);
CREATE OR REPLACE FUNCTION ws_sample.gw_fct_setselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT ws_sample.gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{}, 
"data":{"addSchema":"ws_sample", "selectorType":"explfrommuni", "id":2, "value":true, "isAlone":true}}$$);
*/

DECLARE

v_version json;
v_selectortype text;
v_tablename text;
v_columnname text;
v_id integer;
v_value text;
v_muni integer;
v_isalone boolean;
v_parameter_selector json;
v_data json;
v_expl integer;
v_addschema text;

BEGIN

	-- Set search path to local schema
	SET search_path = "ws_sample", public;
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
	
	-- Get input parameters:
	v_selectortype := (p_data ->> 'data')::json->> 'selectorType';
	v_id := (p_data ->> 'data')::json->> 'id';
	v_value := (p_data ->> 'data')::json->> 'value';
	v_isalone := (p_data ->> 'data')::json->> 'isAlone';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_data = p_data->>'data';

	-- Get system parameters
	v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', v_selectortype));
		v_tablename = v_parameter_selector->>'selector';
		v_columnname = v_parameter_selector->>'selector_id'; 
	
	-- get expl from muni
	IF v_selectortype = 'explfrommuni' THEN
		v_expl = (SELECT expl_id FROM exploitation e, ext_municipality m WHERE st_dwithin(st_centroid(e.the_geom), m.the_geom, 0) AND muni_id = v_id);
		EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
		EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) VALUES('|| v_expl ||', '''|| current_user ||''')';	
	END IF;
	
	-- manage isalone
	IF v_isalone THEN
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
	END IF;

	-- manage value
	IF v_value THEN
		EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')';
	ELSE
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || ' = '|| v_id ||'';
	END IF;

/*
	-- todo: implement multi selection and manage additional schema
	-- manage add schema
	IF v_addschema IS NOT NULL THEN

		--force search path to the additional schema
		EXECUTE 'SET search_path = public, '||v_addschema;
		
		-- get municipality from exploitation (as mapping relation againts the add schema)
		v_muni = (SELECT muni_id FROM exploitation e, ext_municipality m WHERE st_dwithin(st_centroid(e.the_geom), m.the_geom, 0) AND expl_id = v_id);
		EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
		EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) VALUES('|| v_expl ||', '''|| current_user ||''')';	
		
		-- modify json to call again on the add schema
		v_data = gw_fct_json_object_set_key(p_data , 'id', v_muni::text);
		v_data = gw_fct_json_object_set_key(p_data ,' selectorType', 'explfrommuni'::text);
		v_data = gw_fct_json_object_delete_keys(p_data ,'id', 'addSchema'::text);
				
		-- trigger selector of additional schema		
		PERFORM gw_fct_setselectors(v_data);
		
		-- restore set search_path
		SET search_path = ws_sample, public;

	END IF;

*/
	-- Return
	RETURN ('{"status":"Accepted", "version":'||v_version||
			',"body":{"message":{"priority":1, "text":"This is a test message"}'||
			',"form":{"formName":"", "formLabel":"", "formText":""'||
			',"formActions":[]}'||
			',"feature":{}'||
			',"data":{"indexingLayers": {"mincut": ["v_om_mincut", "v_om_mincut_arc", "v_om_mincut_node", "v_om_mincut_connec", "v_om_mincut_valve"],
										 "exploitation": ["v_edit_arc", "v_edit_node", "v_edit_connec", "v_edit_gully", "v_edit_element"]
			}}}'||'}')::json;

	-- Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  