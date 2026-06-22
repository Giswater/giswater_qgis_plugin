/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

DO $$
BEGIN
    IF (SELECT value::boolean FROM config_param_system WHERE parameter = 'admin_cibs_schema') IS NOT TRUE THEN
        PERFORM gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP","rootViews":["v_hydrometer"],"batchId":1}}$$)::JSON;
        ALTER TABLE ext_hydrometer ALTER COLUMN wmeter_number TYPE text USING wmeter_number::text;
        PERFORM gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE","rootViews":["v_hydrometer"],"batchId":1}}$$)::JSON;
    END IF;
END $$;
