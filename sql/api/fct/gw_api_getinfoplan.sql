/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2586

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_api_getinfoplan(p_data json)
  RETURNS json AS
$BODY$
/* EXAMPLE
SELECT SCHEMA_NAME.gw_api_getinfoplan($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"tabName":"plan"},
"feature":{"featureType":"arc", "tableName":"ve_arc_pipe", "idName":"arc_id", "id":"113854"},
"data":{}}$$)

SELECT SCHEMA_NAME.gw_api_getinfoplan($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"form":{"formName":"", "tabName":"plan"},
"feature":{"featureType":"node", "tableName":"ve_node_junction", "idName":"node_id", "id":"1001"},
"data":{}}$$)
*/

DECLARE
--    Variables
    fields_array json[];
    formTabs text;
    combo_json json;
    api_version json;
    aux_json json;
    fields json;
    count integer := 1;
    v_cost text;
    v_currency_symbol varchar;
    v_tabname varchar = 'plan';
    v_tablename varchar;
    v_device integer;


BEGIN


-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO api_version;

--  get system currency
    v_currency_symbol :=((SELECT value FROM config_param_system WHERE parameter='sys_currency')::json->>'symbol');
   

-- Create tabs array
    formTabs := '[';

-- Info plan
--------------		   
	-- get tablename
	IF ((p_data ->>'feature')::json->>'featureType')::text='arc' THEN
	      v_tablename := 'v_ui_plan_arc_cost';
	ELSIF ((p_data ->>'feature')::json->>'featureType')::text='node' THEN
		v_tablename := 'v_ui_plan_node_cost';
	END IF;

	-- get parameters
	 v_device := ((p_data ->>'client')::json->>'device')::integer;

	-- get fields
	SELECT gw_api_get_formfields('infoplan', 'info', v_tabname, v_tablename, ((p_data ->>'feature')::json->>'idName'), ((p_data ->>'feature')::json->>'id'), null, null,null, v_device)
		INTO fields_array;

--	Add resumen values
	FOREACH aux_json IN ARRAY fields_array
	LOOP
		IF (aux_json->>'widtget_context') = 'resumen' AND (aux_json->>'column_id')  = 'initial_cost' THEN 

			v_cost := (SELECT concat((sum(cost)::numeric(12,2)),' €') FROM v_ui_plan_arc_cost WHERE arc_id = (p_data ->>'feature')::json->>'id');
			fields_array[(aux_json->>'orderby')::INT] := gw_fct_json_object_set_key(fields_array[(aux_json->>'orderby')::INT], 'value', v_cost::TEXT);
			--RAISE NOTICE 'fields_array(orderby) %', fields_array[(aux_json->>'orderby')::INT];

		END IF;

	END LOOP;  

	RAISE NOTICE 'fields_array %', 	fields_array;


--     Convert to json
       fields := array_to_json(fields_array);
       --fields := ('{"fields":' || fields || '}')::json;
       formTabs := formTabs || fields::text;
       

--     Finish the construction of formtabs
       formTabs := formtabs ||']';
--     Check null
       formTabs := COALESCE(formTabs, '[]');    


--    Return
    RETURN ('{"status":"Accepted", "apiVersion":'||api_version||
             ',"body":{"message":{}'||
			',"form":'||(p_data ->>'form')||
			',"feature":'||(p_data ->>'feature')||
			',"data":{"fields":' || fields ||
				'}}'||
	    '}')::json;
      
--    Exception handling
--    EXCEPTION WHEN OTHERS THEN 
        --RETURN ('{"status":"Failed","SQLERR":' || to_json(SQLERRM) || ', "apiVersion":'|| api_version || ',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
