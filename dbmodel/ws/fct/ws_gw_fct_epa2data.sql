/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3180

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_epa2data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_epa2data(p_data json)  RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_epa2data($${"client":{"device":4, "infoType":1, "lang":"ES", "epsg":25831}, "data":{"resultId":"test"}}$$)
*/

DECLARE     

v_result_id text;
v_current_selector text;
v_error_context text;
v_version text;
v_projectype text;
BEGIN

		--  Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT giswater, project_type INTO v_version, v_projectype FROM sys_version ORDER BY id DESC LIMIT 1;

	--  Get system & user variables
	v_result_id = ((p_data ->>'data')::json->>'resultId')::text;

	SELECT result_id INTO v_current_selector FROM selector_rpt_main WHERE cur_user=current_user;

	DELETE FROM selector_rpt_main WHERE cur_user=current_user;
	INSERT INTO selector_rpt_main(result_id, cur_user) VALUES (v_result_id, current_user);

	UPDATE rpt_cat_result SET iscorporate=true WHERE result_id = v_result_id;

	INSERT INTO node_add (node_id, demand_max, demand_min, demand_avg, press_max, press_min, press_avg, head_max, head_min, head_avg, quality_max, quality_min, quality_avg, result_id)
	SELECT node_id, avg(demand_max)::numeric(12,2), avg(demand_min)::numeric(12,2), avg(demand_avg)::numeric(12,2), avg(press_max)::numeric(12,2), avg(press_min)::numeric(12,2), avg(press_avg)::numeric(12,2),
	avg(head_max)::numeric(12,2), avg(head_min)::numeric(12,2), avg(head_avg)::numeric(12,2), avg(quality_max)::numeric(12,2), avg(quality_min)::numeric(12,2), avg(quality_avg)::numeric(12,2), result_id FROM
	(SELECT split_part(node_id,'_',1) as node_id, demand_max, demand_min, demand_avg, press_max, press_min, press_avg, head_max, head_min, head_avg, quality_max, quality_min, quality_avg, result_id
	FROM v_rpt_node a WHERE result_id=v_result_id) a
	JOIN node USING (node_id)
	GROUP BY node_id, result_id
	ON CONFLICT (node_id) DO UPDATE SET 
	demand_max = EXCLUDED.demand_max, demand_min = EXCLUDED.demand_min, demand_avg = EXCLUDED.demand_avg, 
	press_max = EXCLUDED.press_max, press_min = EXCLUDED.press_min, press_avg = EXCLUDED.press_avg,
	head_max = EXCLUDED.head_max, head_min = EXCLUDED.head_min, head_avg = EXCLUDED.head_avg, 
	quality_max = EXCLUDED.quality_max, quality_min = EXCLUDED.quality_min, quality_avg=EXCLUDED.quality_avg, result_id=EXCLUDED.result_id;

	INSERT INTO arc_add (arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, result_id)
	SELECT arc_id, avg(flow_max)::numeric(12,2), avg(flow_min)::numeric(12,2), avg(flow_avg)::numeric(12,2), avg(vel_max)::numeric(12,2), avg(vel_min)::numeric(12,2), avg(vel_avg)::numeric(12,2), result_id FROM
	(SELECT split_part(arc_id, 'P',1) as arc_id, flow_max, flow_min, flow_avg, vel_max, vel_min, vel_avg, result_id FROM v_rpt_arc a WHERE result_id=v_result_id)a
	GROUP by arc_id, result_id
	ON CONFLICT (arc_id) DO UPDATE SET 
	flow_max = EXCLUDED.flow_max, flow_min = EXCLUDED.flow_min, flow_avg = EXCLUDED.flow_avg,
	vel_max = EXCLUDED.vel_max, vel_min = EXCLUDED.vel_min, vel_avg = EXCLUDED.vel_avg, result_id=EXCLUDED.result_id;

	INSERT INTO connec_add (connec_id, demand, press_max, press_min, press_avg, quality_max, quality_min, quality_avg, result_id)
	SELECT node_id, demand_avg, press_max::numeric(12,2), press_min::numeric(12,2), press_avg::numeric(12,2),
	quality_max::numeric(12,4), quality_min::numeric(12,4), quality_avg::numeric(12,4), result_id
	FROM v_rpt_node a 
	JOIN connec ON node_id = connec_id
	ON CONFLICT (connec_id) DO UPDATE SET 
	demand_max = EXCLUDED.demand_max, demand_min = EXCLUDED.demand_min, demand_avg = EXCLUDED.demand_avg, 
	press_max = EXCLUDED.press_max, press_min = EXCLUDED.press_min, press_avg = EXCLUDED.press_avg,
	head_max = EXCLUDED.head_max, head_min = EXCLUDED.head_min, head_avg = EXCLUDED.head_avg, 
	quality_max = EXCLUDED.quality_max, quality_min = EXCLUDED.quality_min, quality_avg=EXCLUDED.quality_avg, result_id=EXCLUDED.result_id;

	IF v_current_selector IS NOT NULL THEN
		DELETE FROM selector_rpt_main WHERE cur_user=current_user;
		INSERT INTO selector_rpt_main(result_id, cur_user) VALUES (v_current_selector, current_user);
	END IF;

  	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":{}'||
			'}}'||
	    '}')::json, 3180, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
		
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;