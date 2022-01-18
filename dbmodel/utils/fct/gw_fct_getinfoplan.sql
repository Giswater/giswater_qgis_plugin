/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2586

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_api_getinfoplan(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getinfoplan(p_data json)
  RETURNS json AS
$BODY$
/* EXAMPLE
SELECT SCHEMA_NAME.gw_fct_getinfoplan($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"tabName":"plan"},
"feature":{"featureType":"arc", "tableName":"ve_arc_pipe", "idName":"arc_id", "id":"113854"},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_fct_getinfoplan($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{"formName":"", "tabName":"plan"},
"feature":{"featureType":"node", "tableName":"ve_node_junction", "idName":"node_id", "id":"1001"},
"data":{}}$$)
*/

DECLARE

fields_array json[];
formTabs text;
combo_json json;
v_version json;
aux_json json;
fields json;
count integer := 1;
v_cost text;
v_dim text;
v_currency varchar;
v_tabname varchar = 'plan';
v_tablename varchar;
v_device integer;
v_totalcost text;

BEGIN

	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;

	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''admin_version'') row'
        INTO v_version;

	--  get system currency
	v_currency :=(SELECT value::json->>'symbol' FROM config_param_system WHERE parameter='admin_currency');
   
	-- Create tabs array
	formTabs := '[';

	-- Info plan
	-- get tablename
	IF ((p_data ->>'feature')::json->>'featureType')::text='arc' THEN
	      v_tablename := 'v_ui_plan_arc_cost';
	ELSIF ((p_data ->>'feature')::json->>'featureType')::text='node' THEN
		v_tablename := 'v_ui_plan_node_cost';
	END IF;

	-- get parameters
	 v_device := ((p_data ->>'client')::json->>'device')::integer;

	raise notice '1';
	
	-- get fields
	SELECT gw_fct_getformfields('infoplan', 'form_generic', v_tabname, v_tablename, ((p_data ->>'feature')::json->>'idName'), ((p_data ->>'feature')::json->>'id'), null, null,null, v_device, null)
		INTO fields_array;

	raise notice '2';
	
	-- Convert to json
	fields := array_to_json(fields_array);
    
	--fields := ('{"fields":' || fields || '}')::json;
	formTabs := formTabs || fields::text;
       
	-- Finish the construction of formtabs
	formTabs := formtabs ||']';	
	
	--  Check null
	formTabs := COALESCE(formTabs, '[]');    

	-- Return
    RETURN ('{"status":"Accepted", "version":'||v_version||
             ',"body":{"message":{}'||
			',"form":'||(p_data ->>'form')||
			',"feature":'||(p_data ->>'feature')||
			',"data":{"fields":' || fields ||
				'}}'||
	    '}')::json;
      
	-- Exception handling
	EXCEPTION WHEN OTHERS THEN 
    RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "version":'|| v_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
