/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE 3342:

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_set_current(json);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_set_toggle_current(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_toggle_current(p_data JSON)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_set_toggle_current($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "type":"netscenario", "id": "5"}}$$);

SELECT SCHEMA_NAME.gw_fct_set_toggle_current($${"client":{"device":4, "lang":"en_US", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "type": "psector", "id": "1"}}$$);

*/

DECLARE
    v_project_type TEXT;
    v_version TEXT;
    v_type TEXT;
    v_id TEXT;

    v_type_name TEXT;
    v_type_id INT;
    result JSON;
    query TEXT;
    parameter_name TEXT;

BEGIN

    -- Set the search path
    SET search_path = "SCHEMA_NAME", public;

    v_type :=  ((p_data->>'data')::json)->>'type'::text;
   	v_id := ((p_data->>'data')::json)->>'id'::text;

    IF v_type IS NULL OR v_type = '' THEN
        EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4330", "function":"3342","parameters":{"parameter":"type"}, "is_process":true}}$$);';
    END IF;

    -- Get project type and version info
    SELECT project_type, giswater INTO v_project_type, v_version
    FROM sys_version
    ORDER BY id DESC
    LIMIT 1;

    -- Determine the parameter name based on the provided type
    CASE v_type
        WHEN 'netscenario' THEN
            parameter_name := 'plan_netscenario_current';

        WHEN 'psector' THEN
            parameter_name := 'plan_psector_current';

        WHEN 'hydrology' THEN
            parameter_name := 'inp_options_hydrology_current';

        WHEN 'dwf' THEN
            parameter_name := 'inp_options_dwfscenario_current';

        WHEN 'workspace' THEN
            parameter_name := 'utils_workspace_current';

        ELSE
            EXECUTE 'SELECT gw_fct_getmessage($${"data":{"message":"4332", "function":"3342","parameters":{"parameter":"type"}, "is_process":true}}$$);';
    END CASE;

    -- Upsert logic for config_param_user: insert if not exists, otherwise update
    IF v_id IS NOT NULL THEN
        PERFORM 1 FROM config_param_user WHERE cur_user = current_user AND parameter = parameter_name;
        IF FOUND THEN
            -- Check current value
            IF (SELECT value FROM config_param_user WHERE cur_user = current_user AND parameter = parameter_name) = v_id THEN
                -- If same, toggle to NULL
                UPDATE config_param_user
                SET value = NULL
                WHERE cur_user = current_user AND parameter = parameter_name;
            ELSE
                -- If different, update to new value
                UPDATE config_param_user
                SET value = v_id
                WHERE cur_user = current_user AND parameter = parameter_name;
            END IF;
        ELSE
            -- Insert new if not exists
            INSERT INTO config_param_user (parameter, value, cur_user)
            VALUES (parameter_name, v_id, current_user);
        END IF;
    END IF;

    -- Determine the query based on the provided type
    CASE v_type
        WHEN 'netscenario' THEN
		    query := 'SELECT t1.netscenario_id, t1.name FROM plan_netscenario AS t1 '
		          || 'INNER JOIN config_param_user AS t2 ON t1.netscenario_id::text = t2.value '
		          || 'WHERE t2.parameter = ''plan_netscenario_current'' AND t2.cur_user = current_user';
		    EXECUTE query INTO v_type_id, v_type_name;
		    result := json_build_object('netscenario_id', v_type_id, 'name', v_type_name);

        WHEN 'psector' THEN
            query := 'SELECT t1.psector_id, t1.name FROM plan_psector AS t1 '
                  || 'INNER JOIN config_param_user AS t2 ON t1.psector_id::text = t2.value '
                  || 'WHERE t2.parameter = ''plan_psector_current'' AND t2.cur_user = current_user';
            EXECUTE query INTO v_type_id, v_type_name;
            result := json_build_object('psector_id', v_type_id, 'name', v_type_name);

        WHEN 'hydrology' THEN
            query := 'SELECT t1.hydrology_id, t1.name FROM cat_hydrology AS t1 '
                  || 'INNER JOIN config_param_user AS t2 ON t1.hydrology_id::text = t2.value '
                  || 'WHERE t2.parameter = ''inp_options_hydrology_current'' AND t2.cur_user = current_user';
            EXECUTE query INTO v_type_id, v_type_name;
            result := json_build_object('hydrology_id', v_type_id, 'name', v_type_name);

        WHEN 'dwf' THEN
            query := 'SELECT t1.id, t1.idval FROM cat_dwf AS t1 '
                  || 'INNER JOIN config_param_user AS t2 ON t1.id::text = t2.value '
                  || 'WHERE t2.parameter = ''inp_options_dwfscenario_current'' AND t2.cur_user = current_user';
            EXECUTE query INTO v_type_id, v_type_name;
            result := json_build_object('dwf_id', v_type_id, 'name', v_type_name);

        WHEN 'workspace' THEN
            query := 'SELECT t1.id, t1.name FROM cat_workspace AS t1 '
                  || 'INNER JOIN config_param_user AS t2 ON t1.id::text = t2.value '
                  || 'WHERE t2.parameter = ''utils_workspace_current'' AND t2.cur_user = current_user';
            EXECUTE query INTO v_type_id, v_type_name;
            result := json_build_object('dwf_id', v_type_id, 'name', v_type_name);
    END CASE;

    -- Return JSON response
    RETURN (
        '{"status":"Accepted", "message":{"level":1, "text":"Change done successfully"}, "version":"' || v_version || '"' ||
        ',"body":{"form":{}' ||
        ',"feature":{}' ||
        ',"data":' || result::text || '}}'
    )::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
