/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2804

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_schema(p_data json)
  RETURNS void AS
$BODY$

/*EXAMPLE
SELECT gw_fct_admin_manage_schema($${"client":{"lang":"ES"}, "data":{"action":"REPAIRVIEWS","source":"SCHEMA_NAME", "target":"SCHEMA_NAME_2"}}$$);
*/

DECLARE 

v_action text;
v_source text;
v_target text;
v_view record;
v_view_list text[];
v_version text;
v_project_type text;

BEGIN

	v_target = ((p_data ->>'data')::json->>'target')::text; 

	-- search path
	EXECUTE 'SET search_path = '||v_target||', public';

	SELECT giswater, upper(project_type) INTO v_version, v_project_type FROM sys_version order by id desc limit 1;
	
	v_action = ((p_data ->>'data')::json->>'action')::text; 
	v_source = ((p_data ->>'data')::json->>'source')::text; 
	v_target = ((p_data ->>'data')::json->>'target')::text; 

	IF v_action = 'REPAIRVIEWS' THEN

		FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, '||quote_literal(v_source)||','||quote_literal(v_target)||') as definition FROM information_schema.VIEWS WHERE table_schema = '
					||quote_literal(v_source)||' and table_name not in (SELECT table_name FROM information_schema.VIEWS WHERE table_schema = '||quote_literal(v_target)||')'
		LOOP
			EXECUTE 'CREATE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;
		END LOOP;

		-- admin role permissions
		PERFORM gw_fct_admin_role_permissions();

	ELSIF v_action = 'RENAMESCHEMA' THEN

		IF v_project_type = 'WS' or v_project_type = 'UD' THEN

			FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, concat('||quote_literal(v_source)||',''.''),
			concat('||quote_literal(v_target)||',''.'')) as definition 
			FROM information_schema.VIEWS WHERE  table_schema = '||quote_literal(v_target)||' AND (table_name ILIKE ''v_anl_%'' OR 
			table_name ILIKE ''ext_%''  OR table_name ILIKE ''vu_%'' OR table_name ILIKE ''vi_%''  OR table_name ILIKE ''v_visit_%''
			 OR table_name ILIKE ''v_value_%'' OR table_name ILIKE ''v_state_%'')'
			LOOP
		
				EXECUTE 'CREATE OR REPLACE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;

				v_view_list:= array_append(v_view_list, quote_literal(v_view.table_name::text));
			END LOOP;

			FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, concat('||quote_literal(v_source)||',''.''),
			concat('||quote_literal(v_target)||',''.'')) as definition 
			FROM information_schema.VIEWS WHERE  table_schema = '||quote_literal(v_target)||' AND (table_name IN (''v_arc'', ''v_node'',''v_connec'',''v_gully'',
			''v_edit_arc'', ''v_edit_node'',''v_edit_connec'',''v_edit_gully''))'
			LOOP
			
				EXECUTE 'CREATE OR REPLACE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;

				v_view_list:= array_append(v_view_list, quote_literal(v_view.table_name::text));
			END LOOP;

			FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, concat('||quote_literal(v_source)||',''.''),
			concat('||quote_literal(v_target)||',''.'')) as definition 
			FROM information_schema.VIEWS WHERE  table_schema = '||quote_literal(v_target)||' AND (table_name ILIKE ''ve_%'' OR 
			table_name ILIKE ''v_edit%'' )'--OR table_name ILIKE ''ext_%'')'
			LOOP
		
				EXECUTE 'CREATE OR REPLACE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;
			
				v_view_list:= array_append(v_view_list, quote_literal(v_view.table_name::text));
			END LOOP;

			FOR v_view IN EXECUTE 'SELECT table_name, replace(view_definition, concat('||quote_literal(v_source)||',''.''),
			concat('||quote_literal(v_target)||',''.'')) as definition 
			FROM information_schema.VIEWS WHERE  table_schema = '||quote_literal(v_target)||' AND table_name NOT IN ('||array_to_string(v_view_list,',')||')' 
			LOOP

				EXECUTE 'CREATE OR REPLACE VIEW ' ||v_view.table_name || ' AS ' || v_view.definition;
			END LOOP;
		END IF;		
	END IF;

	RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;