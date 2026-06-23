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
