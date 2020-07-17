/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- Function: SCHEMA_NAME.gw_fct_getstyle(json)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_getstyle(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_getstyle(p_data json)
  RETURNS json AS
$BODY$

/*
 SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},  "function_id":"2431"}}$$);
SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "layers":[ "v_edit_arc",  "v_edit_connec","v_edit_node"], "function_id":"2431"}}$$);

SELECT SCHEMA_NAME.gw_fct_getstyle($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "temp_layer":"point", "function_id":"2670"}}$$);

*/
 
DECLARE

v_value json;
v_layer text;
v_layers json;
v_return json;
v_result json;
v_style_type text;
v_version json;
v_layers_array text[];
v_temp_layer text;
--v_style text;
v_json_array json[];
BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;
	
	v_layers = ((p_data ->>'data')::json->>'layers')::json;
	v_temp_layer = ((p_data ->>'data')::json->>'temp_layer')::text;
	v_style_type =((p_data ->>'data')::json->>'style_type')::text;
	v_layers_array = (select array_agg(value) as list from  json_array_elements_text(v_layers));
	-- WHEN COME FROM config_function.layermanager
	IF v_layers IS NOT NULL THEN
		FOREACH v_layer IN ARRAY v_layers_array LOOP
			EXECUTE 'SELECT jsonb_build_object ('''||v_layer||''',feature)
					FROM	(
				SELECT jsonb_build_object(				
				''stylevalue'',stylevalue
				) AS feature
				FROM (SELECT stylevalue FROM sys_style 
				JOIN config_table ON config_table.style::text = sys_style.id::text
				AND config_table.id = '||quote_literal(v_layer)||') row) a;'
				INTO v_result;
					
			SELECT array_append(v_json_array, v_result) into v_json_array;			
			
		END LOOP;		
		v_return = gw_fct_json_object_set_key((p_data->>'body')::json, 'layers', v_json_array);

	END IF;
	RAISE NOTICE 'p_data-->%',p_data;
	
	-- WHEN COME FROM config_function.returnmanager
	/*
	IF v_temp_layer IS NOT NULL THEN

		EXECUTE '
			SELECT jsonb_build_object(
			''styletype'', row.styletype,
			''stylevalue'', row.stylevalue
			) 
			FROM (SELECT styletype, stylevalue from sys_style WHERE idval ='''||v_style_type||''') row ;'
			INTO v_style;

		IF v_style IS NOT NULL THEN			
			v_return=gw_fct_json_object_set_key((v_value)::json, 'style', v_style);			
		END IF;

	END IF;
	*/
    
    	v_version := COALESCE(v_version, '{}');
	v_return := COALESCE(v_return, '{}');
	 
	-- Return
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Executed successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}'||
		     ',"styles":'||v_return||''||
	    '}}')::json;
	    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;