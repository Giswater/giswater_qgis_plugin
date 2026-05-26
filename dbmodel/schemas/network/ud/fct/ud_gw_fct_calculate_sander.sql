/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3216

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_calculate_sander(p_data json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_calculate_sander(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_calculate_sander($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":"138"}}$$)

-- fid: 110

*/

DECLARE

v_version text;
v_result json;
v_result_info json;
v_result_line json;
v_id text;

v_array text;
v_error_context text;
v_count integer;
i integer = 1;
v_calc float;
v_valmin float;
v_sys_ymax float;
rec_arc record;
v_man_table text;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

   	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_id :=  ((p_data ->>'feature')::json->>'id')::text;

	SELECT sys_ymax, concat('man_',lower(sys_type)) INTO v_sys_ymax, v_man_table FROM ve_node WHERE node_id = v_id;

	IF (v_man_table='man_chamber' OR  v_man_table='man_manhole' OR  v_man_table='man_wjump') THEN

		FOR rec_arc IN (SELECT * FROM ve_arc WHERE node_1 = v_id AND state=1) LOOP

			v_calc = v_sys_ymax - rec_arc.sys_y1;

			IF i = 1 THEN
				v_valmin = v_calc;
			ELSIF v_valmin > v_calc THEN
				v_valmin = v_calc;
			END IF;

			i= i+1;
		END LOOP;

		IF v_valmin < 0 THEN
			v_valmin=0;
		END IF;

		IF v_valmin IS NOT NULL THEN
				EXECUTE 'UPDATE '||v_man_table||' SET sander_depth = '||v_valmin||' WHERE node_id = '||quote_literal(v_id)||';';
		END IF;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=110 order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}}}')::json, 3216, null, null, null);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
