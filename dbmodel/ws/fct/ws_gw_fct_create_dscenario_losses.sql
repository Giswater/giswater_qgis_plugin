/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License AS published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_create_dscenario_losses(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE

-- fid: 403

SELECT SCHEMA_NAME.gw_fct_create_dscenario_losses($${"client":{}, "form":{}, "feature":{}, "data":{"parameters":{"name":"1test", "descript":"a"}}}$$);

*/

DECLARE
-- Input vars
v_dscenario_id INT;
v_dscenario_type TEXT = 'LOSSES';
v_emitter_coeff NUMERIC = 0;
v_name TEXT;
v_descript TEXT;
v_sector_id int;

-- aux/std vars
v_sql TEXT;

-- Return
v_function_id INT = 3560;
v_project_type TEXT = 'SCHEMA_NAME';
v_fid INT = 403;
v_version TEXT;
v_result JSON;
v_result_info JSON;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- NOTE: Get input params AND set init vars
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_dscenario_type :=  p_data -> 'data' -> 'parameters'->>'dscenarioType';
	v_name :=  p_data -> 'data' -> 'parameters'->>'name';
	v_descript :=  p_data -> 'data' -> 'parameters'->>'descript';
	v_sector_id :=  (p_data -> 'data' -> 'parameters'->>'sectorId')::INT;
	v_emitter_coeff :=  (p_data -> 'data' -> 'parameters'->>'emitterCoeff')::NUMERIC;

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"'||v_function_id||'", "fid":"'||v_fid||'", "tempTable":"t_", "is_header":true,"separator_id":"2022"}}$$)';

	-- NOTE: Execute process only if the dscenario name does not exists
	IF EXISTS (SELECT NAME FROM cat_dscenario WHERE NAME = v_name) THEN

		INSERT INTO t_audit_check_data (criticity, error_message)
		SELECT log_level, error_message FROM sys_message WHERE id = 4586;
		
	ELSE

		INSERT INTO cat_dscenario (name, descript, dscenario_type)
		VALUES (v_name, v_descript, v_dscenario_type)
		RETURNING dscenario_id INTO v_dscenario_id;

		-- NOTE: Only for junctions (emitter_coef * sum(length of arcs that reach each node))
		EXECUTE format (
		'INSERT INTO inp_dscenario_junction (dscenario_id, node_id, emitter_coeff)
		WITH mec AS (
		SELECT arc_id, st_length(the_geom) AS arc_len, node_1 AS node_id FROM arc WHERE state=1 AND sector_id = %s UNION
		SELECT arc_id, st_length(the_geom) AS arc_len, node_2 AS node_id FROM arc WHERE state=1 AND sector_id = %s
		)
		SELECT distinct %s, node_id, sum(arc_len)*%s FROM mec 
		JOIN inp_junction using (node_id)
		GROUP BY node_id',
		v_sector_id,
		v_sector_id,
		v_dscenario_id,
		v_emitter_coeff
		);

		INSERT INTO t_audit_check_data (criticity, error_message)
		SELECT log_level, error_message FROM sys_message WHERE id = 3674;

	end if;

	-- NOTE: Build return AND clean data
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message AS message FROM t_audit_check_data ORDER BY criticity DESC, id ASC) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');
	v_result_info := COALESCE(v_result_info, '{}');

	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, 
	"version":"'||v_version||'","body":{"form":{},"data":{"info":'||v_result_info||'}}}')::JSON;

END;
$function$
;
