/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

-- FUNCTION CODE: 3352

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_get_epa_selector(json);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_get_epa_selector(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
/*EXAMPLE:

SELECT SCHEMA_NAME.gw_fct_get_epa_selector($${"client":{"device": 5, "lang": "es_ES", "cur_user": "bgeo", "tiled": "False", "infoType": 1},
"form":{"formName":"generic", "formType":"epa_selector"}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}}}$$);

*/
DECLARE
v_form text;
v_body jsonb:= '[]';
v_fieldsjson jsonb := '[]';
v_version text;
v_error_context text;
v_response json;
v_selected_result_show text;
v_selected_result_compare text;
v_selected_time_show text;
v_selected_time_compare text;
v_cur_user text;
BEGIN
    -- Set search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get API version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get current user
	v_cur_user = ((p_data ->>'client')::json->>'cur_user');

    -- Get fields from dialog
	v_body := (SELECT gw_fct_get_dialog(p_data)->'body');
    v_fieldsjson := v_body->'data'->'fields';
	v_form := v_body->>'form';

    -- Get selected values for each combo
	SELECT result_id INTO v_selected_result_show FROM selector_rpt_main WHERE cur_user = v_cur_user;
	SELECT result_id INTO v_selected_result_compare FROM selector_rpt_compare WHERE cur_user = v_cur_user;
	SELECT timestep INTO v_selected_time_show FROM selector_rpt_main_tstep WHERE cur_user = v_cur_user;
	SELECT timestep INTO v_selected_time_compare FROM selector_rpt_compare_tstep WHERE cur_user = v_cur_user;

	-- Update JSON fields with selectedId values for specific column names
    v_fieldsjson := (
        SELECT jsonb_agg(
            CASE
                WHEN field->>'columnname' = 'result_name_show' AND v_selected_result_show IS NOT NULL THEN
					jsonb_set(field, '{selectedId}', to_jsonb(v_selected_result_show))

                WHEN field->>'columnname' = 'result_name_compare' AND v_selected_result_compare IS NOT NULL THEN
					jsonb_set(field, '{selectedId}', to_jsonb(v_selected_result_compare))

				WHEN field->>'columnname' = 'time_show' AND v_selected_time_show IS NOT NULL THEN
					jsonb_set(field, '{selectedId}', to_jsonb(v_selected_time_show))

                WHEN field->>'columnname' = 'time_compare' AND v_selected_time_compare IS NOT NULL THEN
					jsonb_set(field, '{selectedId}', to_jsonb(v_selected_time_compare))
            ELSE
				field
            END
        )
        FROM jsonb_array_elements(v_fieldsjson) AS field
    );

	-- Return JSON
	RETURN gw_fct_json_create_return(('{
        "status": "Accepted",
        "version": "' || v_version || '",
        "body": {
			"form":' || v_form || ',
            "data": {
                "fields": ' || v_fieldsjson || '
            }
        }
    }')::json, 3352, null, null, null)::json;



EXCEPTION
    WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
        RETURN jsonb_build_object(
            'status', 'Failed',
            'NOSQLERR', SQLERRM,
            'SQLSTATE', SQLSTATE,
            'SQLCONTEXT', v_error_context
        );

END;

$function$
;
