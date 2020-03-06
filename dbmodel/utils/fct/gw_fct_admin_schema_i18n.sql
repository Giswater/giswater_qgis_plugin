/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2810

CREATE OR REPLACE FUNCTION ws_sample.gw_fct_admin_schema_i18n(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
set
SELECT ws_sample.gw_fct_admin_schema_i18n($${"data":{"table":"config_api_form_fields", "clause":"WHERE formname = 've_arc' AND column_id = 'arc_id'", "label":{"column":"label", "value":"test"}, "tooltip":{"column":"tooltip", "value":"test"}}}$$)
check 
SELECT * FROM ws_sample.config_api_form_fields WHERE formname = 've_arc' AND column_id = 'arc_id'
*/


DECLARE 
v_language varchar;
v_mode int2 = 0;  -- 0 alvays label and tooltips will be updated, 1 update only when null, 2 never will be updated
v_table text;
v_clause text;
v_label_col text;
v_label_val text;
v_tooltip_col text;
v_tooltip_val text;
v_modelabel text;
v_modetooltip text;
v_error_context text;
v_querytext text;

	
BEGIN 
	-- search path
	SET search_path = "ws_sample", public;

	-- get system parameters
	SELECT language INTO v_language FROM version LIMIT 1;
	SELECT value INTO v_mode FROM config_param_system WHERE parameter = 'i18n_update_mode';


	-- get input parameters
	v_table := (p_data ->> 'data')::json->> 'table';
	v_clause := (p_data ->> 'data')::json->> 'clause';
	v_label_col := ((p_data ->> 'data')::json->>'label')::json->>'column';
	v_label_val := ((p_data ->> 'data')::json->>'label')::json->>'value';
	v_tooltip_col := ((p_data ->> 'data')::json->>'tooltip')::json->>'column';
	v_tooltip_val := ((p_data ->> 'data')::json->>'tooltip')::json->>'value';

	-- vmodeclause
	IF v_mode = 0 THEN
		v_modelabel = ' ; ';
		v_modetooltip = ' ; ';
		
	ELSIF v_mode = 1 THEN
		v_modelabel = ' AND '||v_label_col||' IS NULL ';
		v_modetooltip = ' AND '||v_tooltip_col||' IS NULL ';
	END IF;


	IF  v_mode < 2 THEN
		-- querytext
		v_querytext = 'UPDATE '|| v_table ||' SET '|| v_label_col ||' = '|| quote_literal(v_label_val) ||' '|| v_clause ||' '|| v_modelabel;
		raise notice 'v_querytext %', v_querytext;
		EXECUTE v_querytext;

		v_querytext = 'UPDATE '|| v_table ||' SET '|| v_tooltip_col ||' = '|| quote_literal(v_tooltip_val) ||' '|| v_clause ||' '|| v_modetooltip;
		raise notice 'v_querytext %', v_querytext;
		EXECUTE v_querytext;
		
	END IF;

	-- Return
	RETURN ('{"status":"Accepted"}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
