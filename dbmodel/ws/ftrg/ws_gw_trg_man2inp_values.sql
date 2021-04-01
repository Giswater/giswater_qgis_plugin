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
v_record json;
v_sourcetable text;
v_targettable text;
v_sourcecol text;
v_targetcol text;
v_querytext text;    

BEGIN

	EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	
	-- get values
	v_automatic_man2inp_values = (SELECT value FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values');
	v_sourcetable  = (SELECT child_layer FROM cat_feature f JOIN cat_node c ON c.nodetype_id = f.id WHERE c.id = NEW.nodecat_id);
	
	IF v_automatic_man2inp_values->>'status' THEN

		-- getting variable
		v_automatic_man2inp_values := v_automatic_man2inp_values ->>'values';

		-- getting values for querytext if exist
		SELECT v into v_record FROM (
		SELECT json_array_elements_text((value::json->>'values')::json) v, ((json_array_elements_text((value::json->>'values')::json)::json)->>'source')::json->>'table' t
		FROM config_param_system WHERE parameter = 'epa_automatic_man2inp_values' )a
		WHERE t = v_sourcetable;

		IF v_record IS NOT NULL THEN 

			-- building querytext
			v_sourcetable := (v_record::json->>'source')::json->>'table';
			v_targettable := (v_record::json->>'target')::json->>'table';
			v_sourcecol := (v_record->>'source')::json->>'column';
			v_targetcol := (v_record->>'target')::json->>'column';
			v_querytext = ' UPDATE '||v_targettable||' t SET '||v_targetcol||' = '||v_sourcecol||' FROM '||v_sourcetable||' s WHERE t.node_id = s.node_id';
			EXECUTE v_querytext;
			
		END IF;

	END IF;
  
	RETURN NEW;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;