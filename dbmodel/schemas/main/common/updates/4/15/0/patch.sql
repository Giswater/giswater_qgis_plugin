/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DO $patch$
BEGIN
    IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_cibs_schema') IS NOT TRUE THEN
        PERFORM gw_fct_admin_manage_view_dependencies(
            json_build_object(
                'data', json_build_object(
                    'action', 'SAVE-DROP',
                    'rootViews', json_build_array('v_hydrometer'),
                    'batchId', 1
                )
            )
        );
        ALTER TABLE ext_hydrometer ALTER COLUMN wmeter_number TYPE text USING wmeter_number::text;
        CREATE OR REPLACE VIEW v_hydrometer AS SELECT * FROM ext_hydrometer;
        PERFORM gw_fct_admin_manage_view_dependencies(
            json_build_object(
                'data', json_build_object(
                    'action', 'RESTORE',
                    'rootViews', json_build_array('v_hydrometer'),
                    'batchId', 1
                )
            )
        );
    END IF;
END $patch$;

CREATE UNIQUE INDEX link_feature_id_state1_unique
ON link (feature_id, feature_type)
WHERE state = 1 AND feature_id IS NOT NULL;

INSERT INTO sys_message (id, error_message, hint_message, log_level, show_user, project_type, "source", message_type)
VALUES(4640, 'GeoJSON output requires a the_geom column in the resolved query for tableName %tableName%', 'Include the_geom in config_form_list.query_text', 2, true, 'utils', 'core', 'UI')
ON CONFLICT DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3566, 'gw_fct_build_filters_sql', 'utils', 'function', 'json, text', 'text', 'Build SQL AND clauses from filterFields json for list and feature queries', NULL, NULL, 'core', NULL)
ON CONFLICT DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3568, 'gw_fct_resolve_list_query', 'utils', 'function', 'text, integer', 'json', 'Resolve config_form_list query_text and metadata for a listname', NULL, NULL, 'core', NULL)
ON CONFLICT DO NOTHING;

INSERT INTO sys_function (id, function_name, project_type, function_type, input_params, return_type, descript, sys_role, sample_query, "source", function_alias)
VALUES(3570, 'gw_fct_build_canvas_filter_sql', 'utils', 'function', 'text, double precision, double precision, double precision, double precision, integer', 'text', 'Build SQL canvas extend filter for a geometry expression', NULL, NULL, 'core', NULL)
ON CONFLICT DO NOTHING;
