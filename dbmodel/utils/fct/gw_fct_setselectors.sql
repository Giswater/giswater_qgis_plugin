/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2870

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_setselectors (json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setselectors(p_data json)
  RETURNS json AS
$BODY$

/*example
SELECT gw_fct_setselectors($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "selectorType":"None", "tabName":"tab_exploitation", "id":"1", "checkAll":"True", "addSchema":"None"}}$$);
*/

DECLARE

v_version json;
v_tabname text;
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
v_error_context text;
v_selectortype text;
v_layermanager json;
v_schemaname text;
v_return json;
v_table text;
v_tableid text;
v_checkall boolean;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	v_schemaname = 'SCHEMA_NAME';
	
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
		INTO v_version;
	
	-- Get input parameters:
	v_tabname := (p_data ->> 'data')::json->> 'tabName';
	v_selectortype := (p_data ->> 'data')::json->> 'selectorType';
	v_id := (p_data ->> 'data')::json->> 'id';
	v_value := (p_data ->> 'data')::json->> 'value';
	v_isalone := (p_data ->> 'data')::json->> 'isAlone';
	v_checkall := (p_data ->> 'data')::json->> 'checkAll';
	v_addschema := (p_data ->> 'data')::json->> 'addSchema';
	v_data = p_data->>'data';

	-- profilactic control of selector type
	IF lower(v_selectortype) = 'none' OR v_selectortype = '' OR lower(v_selectortype) ='null' THEN v_selectortype = 'selector_basic'; END IF;

	-- profilactic control of schema name
	IF lower(v_addschema) = 'none' OR v_addschema = '' OR lower(v_addschema) ='null'
		THEN v_addschema = null; 
	ELSE
		IF (select schemaname from pg_tables WHERE schemaname = v_addschema LIMIT 1) IS NULL THEN
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
            "data":{"message":"3132", "function":"2870","debug_msg":null}}$$)';
			-- todo: send message to response
		END IF;
	END IF;

	-- looking for additional schema 
	IF v_addschema IS NOT NULL AND v_addschema != v_schemaname THEN
		EXECUTE 'SET search_path = '||v_addschema||', public';
		PERFORM gw_fct_setselectors(p_data);
		SET search_path = 'SCHEMA_NAME', public;
	END IF;

	-- Get system parameters
	v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = concat('basic_selector_', v_tabname));
	v_tablename = v_parameter_selector->>'selector';
	v_columnname = v_parameter_selector->>'selector_id'; 
	v_table = v_parameter_selector->>'table';
	v_tableid = v_parameter_selector->>'table_id';	
	v_layermanager = v_parameter_selector->>'layermanager'; 

	-- get expl from muni
	IF v_selectortype = 'explfrommuni' THEN

		-- getting specifics parameters
		v_parameter_selector = (SELECT value::json FROM config_param_system WHERE parameter = 'basic_selector_explfrommuni');
		v_tablename = v_parameter_selector->>'selector';
		v_columnname = v_parameter_selector->>'selector_id'; 

		v_expl = (SELECT expl_id FROM exploitation e, ext_municipality m WHERE st_dwithin(st_centroid(e.the_geom), m.the_geom, 0) AND muni_id::text = v_id::text limit 1);
		EXECUTE 'DELETE FROM selector_expl WHERE cur_user = current_user';
		EXECUTE 'INSERT INTO selector_expl (expl_id, cur_user) VALUES('|| v_expl ||', '''|| current_user ||''')';	
	END IF;

	-- manage isalone
	IF v_isalone THEN
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE cur_user = current_user';
	END IF;

	-- manage value
	IF v_value THEN
		EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) VALUES('|| v_id ||', '''|| current_user ||''')ON CONFLICT DO NOTHING';
	ELSE
		EXECUTE 'DELETE FROM ' || v_tablename || ' WHERE ' || v_columnname || ' = '|| v_id ||'';
	END IF;

	-- manage check all
	IF v_checkall THEN
		EXECUTE 'INSERT INTO ' || v_tablename || ' ('|| v_columnname ||', cur_user) SELECT '||v_tableid||', current_user FROM '||v_table||' ON CONFLICT DO NOTHING';
	END IF;

	-- control nulls
	v_layermanager = COALESCE (v_layermanager, '{}');

	-- Return
	v_return = concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{"currentTab":"', v_tabname,'"}, "feature":{}, "data":{"selectorType":"',v_selectortype,'"}, "layermanager":'||v_layermanager||'}');
	RETURN gw_fct_getselectors(v_return);
	
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  