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
v_response json;
v_body jsonb := '{}'::jsonb;
v_fieldsjson jsonb := '[]';
v_version text;
v_error_context text;
v_form text;
v_cur_user text;
v_selected_result_show text;
v_selected_result_compare text;
v_selected_selector_date text;
v_selected_compare_date text;
v_selected_compare_time text;
v_selected_selector_time text;
v_selected_value text;
v_child text;
v_childs text[];
v_combo_values text[];
v_selector_date_list text[];
v_compare_date_list text[];
v_selector_time_list text[];
v_compare_time_list text[];
v_isnullvalue bool;
BEGIN
    -- Set search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get API version
    SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Get current user
	v_cur_user = ((p_data ->>'client')::json->>'cur_user');

	IF (p_data -> 'feature' -> 'childs') IS NULL THEN
	    -- Get all fields from dialog
		v_body := (SELECT gw_fct_get_dialog(p_data)->'body');
		v_fieldsjson := v_body->'data'->'fields';
		v_form := v_body->>'form';

	    -- Get selected values for each combo
		SELECT result_id INTO v_selected_result_show FROM selector_rpt_main WHERE cur_user = v_cur_user;
		SELECT result_id INTO v_selected_result_compare FROM selector_rpt_compare WHERE cur_user = v_cur_user;
		SELECT resultdate, resulttime INTO v_selected_selector_date, v_selected_selector_time FROM selector_rpt_main_tstep WHERE cur_user = v_cur_user;
		SELECT resultdate, resulttime INTO v_selected_compare_date, v_selected_compare_time FROM selector_rpt_compare_tstep WHERE cur_user = v_cur_user;

		-- Get list values for combo childs
		SELECT array_agg(distinct resultdate) INTO v_selector_date_list FROM rpt_arc WHERE result_id = COALESCE(v_selected_result_show, result_id);
		SELECT array_agg(distinct resultdate) INTO v_compare_date_list FROM rpt_arc WHERE result_id = v_selected_result_compare;
		SELECT array_agg(distinct resulttime) INTO v_selector_time_list FROM rpt_arc  WHERE resultdate = COALESCE(v_selected_selector_date, v_selector_date_list[1]);
		SELECT array_agg(distinct resulttime) INTO v_compare_time_list  FROM rpt_arc  WHERE resultdate = v_selected_compare_date;

		-- Update JSON fields with selectedId values for specific column names
	    v_fieldsjson := (
	        SELECT jsonb_agg(
	            CASE
	                WHEN field->>'columnname' = 'result_name_show' AND v_selected_result_show IS NOT NULL THEN
						jsonb_set(field, '{selectedId}', to_jsonb(v_selected_result_show))

	                WHEN field->>'columnname' = 'result_name_compare' AND v_selected_result_compare IS NOT NULL THEN
						jsonb_set(field, '{selectedId}', to_jsonb(v_selected_result_compare))

					WHEN field->>'columnname' = 'selector_date' AND v_selector_date_list IS NOT NULL THEN
		                jsonb_set(
		                    jsonb_set(
		                        jsonb_set(field, '{comboIds}', to_jsonb(v_selector_date_list)),
		                        '{comboNames}', to_jsonb(v_selector_date_list)
		                    ),
		                    '{selectedId}', to_jsonb(COALESCE(v_selected_selector_date, v_selector_date_list[1]))
		                )

					WHEN field->>'columnname' = 'selector_time' AND v_selector_time_list IS NOT NULL THEN
						jsonb_set(
		                    jsonb_set(
		                        jsonb_set(field, '{comboIds}', to_jsonb(v_selector_time_list)),
		                        '{comboNames}', to_jsonb(v_selector_time_list)
		                    ),
		                    '{selectedId}', to_jsonb(COALESCE(v_selected_selector_time, v_selector_time_list[1]))
		                )

					WHEN field->>'columnname' = 'compare_date' AND v_compare_date_list IS NOT NULL THEN
						jsonb_set(
		                    jsonb_set(
		                        jsonb_set(field, '{comboIds}', to_jsonb(v_compare_date_list)),
		                        '{comboNames}', to_jsonb(v_compare_date_list)
		                    ),
		                    '{selectedId}', to_jsonb(COALESCE(v_selected_compare_date, v_compare_date_list[1]))
		                )

					WHEN field->>'columnname' = 'compare_time' AND v_compare_time_list IS NOT NULL THEN
						jsonb_set(
		                    jsonb_set(
		                        jsonb_set(field, '{comboIds}', to_jsonb(v_compare_time_list)),
		                        '{comboNames}', to_jsonb(v_compare_time_list)
		                    ),
		                    '{selectedId}', to_jsonb(COALESCE(v_selected_compare_time, v_compare_time_list[1]))
		                )
	            ELSE
					field
	            END
	        )
	        FROM jsonb_array_elements(v_fieldsjson) AS field
	    );

	    v_response = ('{
	        "status": "Accepted",
	        "version": "' || v_version || '",
	        "body": {
				"form":' || v_form || ',
	            "data": {
	                "fields": ' || v_fieldsjson || '
	            }
	        }
	    }')::JSON;

	ELSE
		-- Get parameters from input
		v_selected_result_show = ((p_data ->>'form')::json->>'tab_result_result_name_show');
		v_selected_result_compare = ((p_data ->>'form')::json->>'tab_result_result_name_compare');
		v_selected_selector_date = ((p_data ->>'form')::json->>'tab_time_selector_date');
		v_selected_compare_date = ((p_data ->>'form')::json->>'tab_time_compare_date');

		v_childs = ARRAY(SELECT jsonb_array_elements_text((p_data -> 'feature' -> 'childs')::jsonb));

		FOREACH v_child IN ARRAY v_childs
		LOOP
			CASE v_child
				WHEN 'selector_date' THEN
					SELECT  array_agg(distinct resultdate) into v_combo_values FROM rpt_arc  WHERE result_id = v_selected_result_show;
					SELECT resultdate INTO v_selected_value FROM selector_rpt_main_tstep WHERE cur_user = v_cur_user;
				WHEN 'selector_time' THEN
					SELECT array_agg(distinct resulttime) into v_combo_values FROM rpt_arc  WHERE result_id = v_selected_result_show AND resultdate = COALESCE(v_selected_value, v_selected_selector_date);
					SELECT resulttime FROM selector_rpt_main_tstep INTO v_selected_value WHERE cur_user = v_cur_user;
				WHEN 'compare_date' THEN
					SELECT array_agg(distinct resultdate) into v_combo_values FROM rpt_arc  WHERE result_id = v_selected_result_compare;
					SELECT resultdate INTO v_selected_value FROM selector_rpt_compare_tstep WHERE cur_user = v_cur_user;
				WHEN 'compare_time' THEN
					SELECT array_agg(distinct resulttime) into v_combo_values FROM rpt_arc  WHERE result_id = v_selected_result_compare AND resultdate = COALESCE(v_selected_value, v_selected_compare_date);
					SELECT resulttime FROM selector_rpt_compare_tstep INTO v_selected_value WHERE cur_user = v_cur_user;
				ELSE
					v_combo_values = NULL;
			END CASE;

			-- Get isNullValue field
			SELECT dv_isnullvalue::BOOLEAN INTO v_isnullvalue FROM config_form_fields WHERE formname = 'generic'
			AND formtype = 'epa_selector' AND columnname = v_child LIMIT 1;

			IF v_isnullvalue IS TRUE THEN
				v_combo_values := array_prepend('', v_combo_values);
	        END IF;

			-- Check if the previous value selected is not in the combo list
			IF v_selected_value IS NULL OR v_selected_value NOT IN (SELECT UNNEST(v_combo_values)) THEN
				v_selected_value := v_combo_values[1];
			END IF;

			-- JSON body
		    v_body := v_body || jsonb_build_object(
		        v_child,
		        jsonb_build_object(
		            'values', COALESCE(v_combo_values, ARRAY[]::TEXT[]),
		            'selectedValue', COALESCE(v_selected_value, '')
		        )
		    );

		END LOOP;

		v_response = jsonb_build_object(
	        'status', 'Accepted',
	        'version', v_version,
	        'body', v_body
	    )::json;

	END IF;

	-- Return JSON
	RETURN gw_fct_json_create_return((v_response)::json, 3352, null, null, null)::json;

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
