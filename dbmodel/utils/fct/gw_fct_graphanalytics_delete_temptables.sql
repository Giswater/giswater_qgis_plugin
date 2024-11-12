/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or any later version.
This version of Giswater is provided by Giswater Association
*/

-- FUNCTION CODE: 3332

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_graphanalytics_delete_temptables(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_graphanalytics_delete_temptables(p_data json)
RETURNS json AS
$BODY$

/*
SELECT gw_fct_graphanalytics_delete_temptables('{"data":{"fct_name":"MINSECTOR"}}');
*/

DECLARE

	v_version TEXT;
    v_project_type TEXT;
    v_fct_name TEXT;

BEGIN

	-- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Select configuration values
    SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;

    -- Get variables from input JSON
    v_fct_name = (SELECT (p_data::json->>'data')::json->>'fct_name'); -- Get the function name

    -- Drop temporary layers
    DROP TABLE IF EXISTS temp_pgr_node;
    DROP TABLE IF EXISTS temp_pgr_arc;
    DROP TABLE IF EXISTS temp_pgr_connec;
    DROP TABLE IF EXISTS temp_pgr_link;
    DROP TABLE IF EXISTS temp_pgr_connectedcomponents;
    DROP TABLE IF EXISTS temp_pgr_drivingdistance;

    -- Drop temporary layers depending on the project type
    IF v_project_type = 'UD' THEN
        DROP TABLE IF EXISTS temp_pgr_gully;
    END IF;

    -- Drop other additional temporary tables
    DROP TABLE IF EXISTS temp_audit_check_data;

    -- For specific functions
    IF v_fct_name = 'MINSECTOR' THEN
 	    DROP TABLE IF EXISTS temp_pgr_minsector;
        DROP TABLE IF EXISTS temp_minsector;
    END IF;

    RETURN jsonb_build_object(
        'status', 'Accepted',
        'message', jsonb_build_object(
            'level', 1,
            'text', 'The temporary tables have been deleted successfully.'
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

    EXCEPTION WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'status', 'Failed',
        'message', jsonb_build_object(
            'level', 3,
            'text', 'An error occurred while deleting temporary tables: ' || SQLERRM
        ),
        'version', v_version,
        'body', jsonb_build_object(
            'form', jsonb_build_object(),
            'data', jsonb_build_object()
        )
    );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100

