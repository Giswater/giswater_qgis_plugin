/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3032

CREATE OR REPLACE FUNCTION gw_trg_man2inp_values()
  RETURNS trigger AS
$BODY$
DECLARE 

v_automatic_man2inp_values json;
v_records json[];
v_record json;
v_sourcetable text;
v_querytext text;   
v_node text;

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- get values
	v_automatic_man2inp_values = (SELECT value FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values');
	v_sourcetable  = (SELECT child_layer FROM cat_feature f JOIN cat_node c ON c.nodetype_id = f.id WHERE c.id = NEW.nodecat_id);


	IF (v_automatic_man2inp_values->>'status')::boolean = true THEN

		-- getting variable
		v_automatic_man2inp_values := v_automatic_man2inp_values ->>'values';

		-- getting values for querytext if exist
		SELECT array_agg(v) into v_records FROM (
		SELECT json_array_elements_text((value::json->>'values')::json) v, (json_array_elements_text((value::json->>'values')::json)::json)->>'sourceTable' t
		FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values' )a
		WHERE t = v_sourcetable;

		IF v_records IS NOT NULL THEN

			v_node = NEW.node_id;

			FOREACH v_record IN ARRAY v_records
			LOOP
				-- building querytext
				v_querytext := (v_record::json->>'query');
				v_querytext := v_querytext ||' AND t.node_id = '||v_node||'::text';

				EXECUTE v_querytext;
			END LOOP;
			
		END IF;

	END IF;
  
	RETURN NEW;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;