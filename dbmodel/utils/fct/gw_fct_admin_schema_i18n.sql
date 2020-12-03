/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2810

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_schema_i18n(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
set
SELECT SCHEMA_NAME.gw_fct_admin_schema_i18n($${"data":{"table":"config_form_fields", "formname":"ve_arc", "clause":"WHERE formname = 've_arc' AND columnname = 'arc_id'",
"label":{"column":"label", "value":"test"}, "tooltip":{"column":"tooltip", "value":"test"}}}$$)
check 
SELECT * FROM SCHEMA_NAME.config_form_fields WHERE formname = 've_arc' AND columnname = 'arc_id'
*/


DECLARE 

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
v_parent_layer text;
v_clause_view text;
v_formname text;
v_man_type text;

rec_child_layer text;

BEGIN 
	-- search path
	SET search_path = "SCHEMA_NAME", public;

	IF v_table = 'config_form_fields' THEN
		-- get system parameters
		SELECT value INTO v_mode FROM config_param_system WHERE parameter = 'admin_i18n_update_mode';
	END IF;

	-- get input parameters
	v_table := (p_data ->> 'data')::json->> 'table';
	v_formname := (p_data ->> 'data')::json->> 'formname';
	v_clause := (p_data ->> 'data')::json->> 'clause';
	v_label_col := ((p_data ->> 'data')::json->>'label')::json->>'column';
	v_label_val := ((p_data ->> 'data')::json->>'label')::json->>'value';
	v_tooltip_col := ((p_data ->> 'data')::json->>'tooltip')::json->>'column';
	v_tooltip_val := ((p_data ->> 'data')::json->>'tooltip')::json->>'value';

	--select parent view
	IF v_table = 'config_form_fields' THEN
		IF v_formname = 've_node' THEN
			v_parent_layer = (quote_literal('ve_node'), quote_literal('v_edit_node'));
		ELSIF v_formname = 've_connec' THEN
			v_parent_layer = (quote_literal('ve_connec'), quote_literal('v_edit_connec'));
		ELSIF v_formname = 've_arc' THEN
			v_parent_layer = (quote_literal('ve_arc'), quote_literal('v_edit_arc'));
		ELSIF v_formname = 've_gully' THEN
			v_parent_layer = (quote_literal('ve_gully'), quote_literal('v_edit_gully'));
		ELSIF v_formname ILIKE 've_node_%' THEN
			v_man_type = upper(replace(v_formname,'ve_node_',''));
		ELSIF v_formname ILIKE 've_connec_%' THEN
			v_man_type = upper(replace(v_formname,'ve_connec_',''));
		ELSIF v_formname ILIKE 've_arc_%' THEN
			v_man_type = upper(replace(v_formname,'ve_arc_',''));
		ELSIF v_formname ILIKE 've_gully_%' THEN
			v_man_type = upper(replace(v_formname,'ve_gully_',''));
		END IF;
	END IF;

	-- vmodeclause
	IF v_mode = 0 THEN
		v_modelabel = ' ; ';
		v_modetooltip = ' ; ';
		
	ELSIF v_mode = 1 THEN
		v_modelabel = ' AND '||v_label_col||' IS NULL ';
		v_modetooltip = ' AND '||v_tooltip_col||' IS NULL ';
	END IF;


	IF  v_mode < 2 THEN
		IF v_label_val IS NOT NULL and v_label_val !='' THEN
			-- querytext
			v_querytext = 'UPDATE '|| v_table ||' SET '|| v_label_col ||' = '|| quote_literal(v_label_val) ||' '|| v_clause ||' '|| v_modelabel;
			EXECUTE v_querytext;
		END IF;

		IF v_tooltip_val IS NOT NULL and v_tooltip_val !='' THEN
			v_querytext = 'UPDATE '|| v_table ||' SET '|| v_tooltip_col ||' = '|| quote_literal(v_tooltip_val) ||' '|| v_clause ||' '|| v_modetooltip;
			EXECUTE v_querytext;
		END IF;

		--update values for child layers
		IF v_parent_layer IS NOT NULL THEN
			FOR rec_child_layer IN EXECUTE 'SELECT child_layer FROM cat_feature WHERE parent_layer IN '||v_parent_layer||'' 
			LOOP

				v_clause_view = replace(v_clause, v_formname, rec_child_layer);

				v_querytext = 'UPDATE '|| v_table ||' SET '|| v_label_col ||' = '|| quote_literal(v_label_val) ||' '|| v_clause_view ||' '|| v_modelabel;
				EXECUTE v_querytext;

				v_querytext = 'UPDATE '|| v_table ||' SET '|| v_tooltip_col ||' = '|| quote_literal(v_tooltip_val) ||' '|| v_clause_view ||' '|| v_modetooltip;
				EXECUTE v_querytext;

			END LOOP;
		ELSIF v_man_type IS NOT NULL THEN

			FOR rec_child_layer IN EXECUTE 'SELECT child_layer FROM cat_feature WHERE system_id = '||quote_literal(v_man_type)||';'
			LOOP
				v_clause_view = replace(v_clause, v_formname, rec_child_layer);

				v_querytext = 'UPDATE '|| v_table ||' SET '|| v_label_col ||' = '|| quote_literal(v_label_val) ||' '|| v_clause_view ||' '|| v_modelabel;
				EXECUTE v_querytext;

				v_querytext = 'UPDATE '|| v_table ||' SET '|| v_tooltip_col ||' = '|| quote_literal(v_tooltip_val) ||' '|| v_clause_view ||' '|| v_modetooltip;
				EXECUTE v_querytext;

			END LOOP;
		END IF;
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
