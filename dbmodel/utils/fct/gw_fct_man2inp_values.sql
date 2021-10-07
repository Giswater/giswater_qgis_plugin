/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3032

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_man2inp_values(p_data json)
RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_man2inp_values('{"feature":{"type":"node", "childLayer":"ve_node_pr_reduc_valve", "id":"1001"}}');
*/

DECLARE 

v_automatic_man2inp_values json;
v_record json;
v_sourcetable text;
v_querytext text;   
v_node text;
v_feature_type text;
v_childlayer text;
v_project_type text;
v_id text;

BEGIN

	SET search_path = SCHEMA_NAME, public;
	
	-- get input parameters
	v_feature_type = lower((p_data->>'feature')::json->>'type');
	v_childlayer = (p_data->>'feature')::json->>'childLayer';
	v_id = (p_data->>'feature')::json->>'id';

	-- get version parameters
	v_project_type = (SELECT project_type FROM sys_version LIMIT 1);
	
	-- get config values
	v_automatic_man2inp_values = (SELECT value FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values');

	IF (v_automatic_man2inp_values->>'status')::boolean = true THEN

		-- getting values for querytext if exist
		SELECT v into v_record FROM (
		SELECT json_array_elements_text((value::json->>'values')::json) v, (json_array_elements_text((value::json->>'values')::json)::json)->>'sourceTable' t
		FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values' )a
		WHERE t = v_childlayer;

		IF v_record IS NOT NULL THEN

			-- building querytext
			v_querytext := (v_record::json->>'query');
			v_querytext := v_querytext ||' WHERE t.'||v_feature_type ||'_id = '||v_id||'::text
			 AND s.'||v_feature_type ||'_id = '||v_id||'::text';

			EXECUTE v_querytext;		
		END IF;

	END IF;
  
	RETURN;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;