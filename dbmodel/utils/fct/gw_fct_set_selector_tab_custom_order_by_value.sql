/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3524

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_set_selector_tab_custom_order_by_value(p_tabname text, p_value boolean)
  RETURNS json AS
$BODY$

/*

*/

DECLARE
	v_result json;
	v_version text;
BEGIN
	SET search_path= 'SCHEMA_NAME','public';		
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

    UPDATE config_param_user
    SET value =
        jsonb_set(
            value::jsonb,
            ARRAY[p_tabname, 'is_checked'],
            to_jsonb(p_value),
            false
        )::text
    WHERE parameter = 'custom_order_by'
      AND cur_user = current_user
      AND value::jsonb ? p_tabname
    RETURNING value::json INTO v_result;

	RETURN jsonb_build_object(
		'status', 'Accepted', 
		'message', jsonb_build_object(
			'level', 1, 
			'text', 'Process done successfully'
		), 
		'version', v_version, 
		'body', jsonb_build_object(
			'form', jsonb_build_object(), 
			'data', jsonb_build_object()
		)
	);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_errcontext = pg_exception_context;
	RETURN jsonb_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'version', v_version, 'SQLSTATE', SQLSTATE, 'MSGERR', (v_msgerr::json ->> 'MSGERR'));
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
