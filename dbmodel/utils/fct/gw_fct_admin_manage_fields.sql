/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2700

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_fields();
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_fields(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_fields(p_data json) RETURNS text AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"arc", "column":"addvalue", "dataType":"varchar(16)", "isUtils":"True"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"arc", "column":"addvalue", "newName":"_addvalue_"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"arc", "column":"addvalue"}}$$)
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${"data":{"action":"CHANGETYPE","table":"arc", "column":"addvalue", "dataType":"varchar(16)}}$$)

*/

DECLARE

v_schemaname varchar = 'SCHEMA_NAME';
v_target_schemaname varchar;
v_table text;
v_target_table text;
v_action text;

v_column text;
v_datatype text;
v_isutils boolean;
v_newname text;
v_querytext text;
v_layers record;
v_max_layoutorder numeric;
v_widgettype text;
v_count integer;


BEGIN

	-- search path
	SET search_path = "SCHEMA_NAME", public;

	v_action = (p_data->>'data')::json->>'action';
	v_table = (p_data->>'data')::json->>'table';
	v_column = (p_data->>'data')::json->>'column';
	v_datatype = (p_data->>'data')::json->>'dataType';
	v_isutils = (p_data->>'data')::json->>'isUtils';
	v_newname = (p_data->>'data')::json->>'newName';



	-- Determine the target schema and table
	IF v_isutils IS TRUE AND (SELECT value::boolean FROM config_param_system WHERE parameter='admin_utils_schema') IS TRUE THEN
		v_target_schemaname := 'utils';
		v_target_table := replace(v_table, 'ext_', '');
	ELSE
		v_target_schemaname := v_schemaname;
		v_target_table := v_table;
	END IF;

	-- Check if the column does not exist in the target schema and table
	IF v_action = 'ADD' AND NOT EXISTS (
		SELECT 1
		FROM information_schema.columns
		WHERE table_schema = v_target_schemaname
		AND table_name = v_target_table
		AND column_name = v_column
	) THEN
		v_querytext := 'ALTER TABLE ' || quote_ident(v_target_schemaname) || '.' || quote_ident(v_target_table)
					|| ' ADD COLUMN ' || quote_ident(v_column) || ' ' || v_datatype;
		EXECUTE v_querytext;

		-- manage config_form_fields only if column has been added to parent tables
		IF v_table IN ('node', 'arc', 'connec', 'gully') THEN
			EXECUTE 'SELECT COUNT(*) 
			FROM config_typevalue 
			WHERE typevalue = ''datatype_typevalue'' 
			AND id ILIKE ''%'||v_datatype||'%'' 
			LIMIT 1'
			INTO v_count;

			IF v_count > 0 THEN
				IF v_datatype ILIKE '%boolean%' THEN
					v_widgettype = 'check';
				ELSE
					v_widgettype = 'text';
				END IF;
			ELSE
				v_datatype = 'text';
				v_widgettype = 'text';
			END IF;

			FOR v_layers IN SELECT parent_layer, child_layer FROM cat_feature WHERE feature_type = UPPER(v_table)
			LOOP
				-- v_edit_feature
				SELECT max(layoutorder)+1 into v_max_layoutorder from config_form_fields
				where formname = v_layers.parent_layer
				and formtype = 'form_feature' and tabname = 'tab_data' and layoutname = 'lyt_data_1' and layoutorder < 900;

				INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, iseditable, hidden)
				VALUES(v_layers.parent_layer, 'form_feature', 'tab_data', v_column, 'lyt_data_1', v_max_layoutorder, v_datatype, v_widgettype, v_column, v_column, NULL, false, true, false)
				ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;

				-- ve_feature_type
				SELECT max(layoutorder)+1 into v_max_layoutorder from config_form_fields
				where formname = v_layers.child_layer
				and formtype = 'form_feature' and tabname = 'tab_data' and layoutname = 'lyt_data_1' and layoutorder < 900;

				INSERT INTO config_form_fields (formname, formtype, tabname, columnname, layoutname, layoutorder, "datatype", widgettype, "label", tooltip, placeholder, ismandatory, iseditable, hidden)
				VALUES(v_layers.child_layer, 'form_feature', 'tab_data', v_column, 'lyt_data_1', v_max_layoutorder, v_datatype, v_widgettype, concat(upper(left(v_column, 1)), substring(v_column, 2)), v_column, NULL, false, true, false)
				ON CONFLICT (formname, formtype, tabname, columnname) DO NOTHING;
			END LOOP;
		END IF;


	ELSIF v_action='RENAME' AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column) IS NOT NULL
				AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_newname) IS NULL THEN

		v_querytext = 'ALTER TABLE '|| quote_ident(v_table) ||' RENAME COLUMN '||quote_ident(v_column)||' TO '||quote_ident(v_newname);
		EXECUTE v_querytext;

		-- manage config_form_fields
		if v_table in ('node', 'arc', 'connec', 'gully') then

			for v_layers in select distinct parent_layer, child_layer from cat_feature where feature_type = upper(v_table)
			loop

				execute '
				update config_form_fields 
				set	columnname = '||quote_literal(v_newname)||', tooltip = '||quote_literal(v_newname)||', label = '||quote_literal(concat(upper(left(v_newname, 1)), substring(v_newname, 2)))||' 
				where formname = '||quote_literal(v_layers.child_layer)||'
				and columnname = '||quote_literal(v_column)||'';

				execute '
				update config_form_fields 
				set	columnname = '||quote_literal(v_newname)||', tooltip = '||quote_literal(v_newname)||', label = '||quote_literal(concat(upper(left(v_newname, 1)), substring(v_newname, 2)))||' 
				where formname = '||quote_literal(v_layers.parent_layer)||'
				and columnname = '||quote_literal(v_column)||'';

			end loop;

		end if;

	ELSIF v_action='DROP' AND (SELECT column_name FROM information_schema.columns WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column) IS NOT NULL THEN

		v_querytext = 'ALTER TABLE '|| quote_ident(v_table) ||' DROP COLUMN '||quote_ident(v_column);
		EXECUTE v_querytext;

		if v_table in ('node', 'arc', 'connec', 'gully') then

			for v_layers in select parent_layer, child_layer from cat_feature where feature_type = upper(v_table)
			loop
				execute '
				DELETE FROM config_form_fields 
				WHERE formname = '||quote_literal(v_layers.parent_layer)||' AND columnname = '||quote_literal(v_column)||'';

				EXECUTE '
				DELETE FROM config_form_fields 
				WHERE formname = '||quote_literal(v_layers.child_layer)||' AND columnname = '||quote_literal(v_column)||'';

			end loop;

		end if;

	ELSIF v_action='CHANGETYPE' AND (SELECT column_name FROM information_schema.columns
		WHERE table_schema=v_schemaname and table_name = v_table AND column_name = v_column AND data_type!=v_datatype) IS NOT NULL THEN

		v_querytext = 'ALTER TABLE '|| quote_ident(v_table) ||' ALTER COLUMN '||quote_ident(v_column)||' TYPE '||v_datatype||' USING '||quote_ident(v_column)||'::'||v_datatype;
		EXECUTE v_querytext;

		-- manage config_form_fields
		if v_table in ('node', 'arc', 'connec', 'gully') then

			execute 'select count(*) from config_typevalue where typevalue = ''datatype_typevalue'' and id ilike ''%'||v_datatype||'%'' limit 1'
			into v_count;

			if v_count > 0 then

				if v_datatype ilike '%boolean%' then
					v_widgettype = 'check';

				else
					v_widgettype = 'text';

				end if;
			else
					v_datatype = 'text';
					v_widgettype = 'text';
			end if;


			for v_layers in select parent_layer, child_layer from cat_feature where feature_type = upper(v_table)
			loop
				execute '
				UPDATE config_form_fields 
				SET datatype = '||quote_literal(v_datatype)||' 
				WHERE formname = '||quote_literal(v_layers.parent_layer)||' AND columnname = '||quote_literal(v_column)||'';

				EXECUTE '
				UPDATE config_form_fields 
				SET datatype = '||quote_literal(v_datatype)||' 
				WHERE formname = '||quote_literal(v_layers.child_layer)||' AND columnname = '||quote_literal(v_column)||'';

			end loop;

		end if;

	ELSE
		v_querytext = 'Process not executed. Table has already been modified.';
	END IF;


	RETURN v_querytext;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;