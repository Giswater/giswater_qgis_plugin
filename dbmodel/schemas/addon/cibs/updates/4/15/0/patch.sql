/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

SET search_path = cibs, public, pg_catalog;

DO $$
DECLARE
    rec_schema text;
    v_parent_schemas jsonb;
BEGIN
    SELECT addparam -> 'parent_schemas'
    INTO v_parent_schemas
    FROM cibs.sys_version
    ORDER BY id DESC
    LIMIT 1;

    IF v_parent_schemas IS NOT NULL THEN
        FOR rec_schema IN
            SELECT jsonb_array_elements_text(v_parent_schemas)
        LOOP
            CONTINUE WHEN to_regclass(format('%I.v_hydrometer', rec_schema)) IS NULL;

            EXECUTE format(
                'SELECT %I.gw_fct_admin_manage_view_dependencies($${"data":{"action":"SAVE-DROP","rootViews":["v_hydrometer"],"batchId":1}}$$)::JSON',
                rec_schema
            );
        END LOOP;
    END IF;

    ALTER TABLE cibs.hydrometer ALTER COLUMN wmeter_number TYPE text USING wmeter_number::text;

    IF v_parent_schemas IS NOT NULL THEN
        FOR rec_schema IN
            SELECT jsonb_array_elements_text(v_parent_schemas)
        LOOP
            CONTINUE WHEN to_regclass(format('%I.v_hydrometer', rec_schema)) IS NULL;

            EXECUTE format(
                'SELECT %I.gw_fct_admin_manage_view_dependencies($${"data":{"action":"RESTORE","rootViews":["v_hydrometer"],"batchId":1}}$$)::JSON',
                rec_schema
            );
        END LOOP;
    END IF;
END $$;
