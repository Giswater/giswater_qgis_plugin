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
v_addtoc json[];
v_value json;
v_layer text;
v_layers json;
v_return json;
v_style_type text;
v_style json;
v_version json;
v_layers_array text[];
v_temp_layer text;


BEGIN

	-- Search path
	SET search_path = 'SCHEMA_NAME', public;	
	
	v_layers = ((p_data ->>'data')::json->>'layers')::json;
	v_temp_layer = ((p_data ->>'data')::json->>'temp_layer')::text;
	v_style_type =((p_data ->>'data')::json->>'style_type')::text;
	v_layers_array = ARRAY(SELECT json_array_elements_text(v_layers::json)); 

	-- WHEN COME FROM config_function.layermanager
	IF v_layers IS NOT NULL THEN
		FOREACH v_layer IN ARRAY v_layers_array LOOP
			EXECUTE 'SELECT addtoc FROM sys_table WHERE id='||quote_literal(v_layer)||''
			INTO v_value; 
			IF v_value IS NULL THEN
				v_value=gw_fct_json_object_set_key((v_value)::json, 'error', 'Layer '||v_layer||' cannot be added, maybe it is a configuration problem, check the table sys_table or add it manually.');
				
			END IF;
			IF v_value->>'style' IS NOT NULL THEN
				EXECUTE 'SELECT stylevalue from sys_style WHERE idval ='||quote_literal(v_value->>'style')||''
				into v_style;
				IF v_style IS NOT NULL THEN			
					v_value=gw_fct_json_object_set_key((v_value)::json, 'style', v_style);			
				END IF;
			END IF;
			v_addtoc=array_append(v_addtoc,v_value);		
		END LOOP;		
		v_return = gw_fct_json_object_set_key((p_data->>'body')::json, 'layers', v_addtoc);
	END IF;

	
	-- WHEN COME FROM config_function.returnmanager
	IF v_temp_layer IS NOT NULL THEN
		EXECUTE '
			SELECT jsonb_build_object(
			''styletype'', row.styletype,
			''stylevalue'', row.stylevalue) 
			FROM (SELECT styletype, stylevalue from sys_style WHERE idval ='''||v_style_type||''') row ;'
			INTO v_style;

		IF v_style IS NOT NULL THEN			
			v_return=gw_fct_json_object_set_key((v_value)::json, 'style', v_style);			
		END IF;
	END IF;
    
        v_version := COALESCE(v_version, '{}');
        v_return := COALESCE(v_return, '{}');
	 
	-- Return
		RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Executed successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"addToc":'||v_return||'}'||
	    '}}')::json;
	    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;