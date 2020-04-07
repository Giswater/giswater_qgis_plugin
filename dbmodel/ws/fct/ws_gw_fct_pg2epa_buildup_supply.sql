/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2774

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_fast_buildup(p_result text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_buildup_supply(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa_buildup_supply('t1')
*/

DECLARE
v_roughness float = 0;
v_record record;
v_x float;
v_y float;
v_geom_point public.geometry;
v_geom_line public.geometry;
v_srid int2;
v_statuspg text;
v_statusps text;
v_statusprv text;
v_forcestatuspg text;
v_forcestatusps text;
v_forcestatusprv text;
v_nullbuffer float;
v_cerobuffer float;
v_n2nlength float;
v_querytext text;
v_diameter float;
v_switch2junction text;
v_defaultcurve1 text;
v_defaultcurve2 text;
v_pressureprv float;
v_pressurepsv float;
v_statuspsv text;
v_forcestatuspsv text;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
	SELECT epsg INTO v_srid FROM version LIMIT 1;

	-- get user variables
	SELECT (value::json->>'tank')::json->>'distVirtualReservoir' INTO v_n2nlength FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pressGroup')::json->>'status' INTO v_statuspg FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pressGroup')::json->>'forceStatus' INTO v_forcestatuspg FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pumpStation')::json->>'status' INTO v_statusps FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pumpStation')::json->>'forceStatus' INTO v_forcestatusps FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'PRV')::json->>'status' INTO v_statusprv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'PRV')::json->>'forceStatus' INTO v_forcestatusprv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT ((value::json->>'PRV')::json->>'pressure')::float INTO v_pressureprv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'PSV')::json->>'status' INTO v_statuspsv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'PSV')::json->>'forceStatus' INTO v_forcestatuspsv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT ((value::json->>'PSV')::json->>'pressure')::float INTO v_pressurepsv FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'reservoir')::json->>'switch2Junction' INTO v_switch2junction FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pressGroup')::json->>'defaultCurve' INTO v_defaultcurve1 FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	SELECT (value::json->>'pumpStation')::json->>'defaultCurve' INTO v_defaultcurve2 FROM config_param_user WHERE parameter = 'inp_options_buildup_supply' AND cur_user=current_user;
	
	RAISE NOTICE 'switch to junction an specific list of RESERVOIRS';
	UPDATE rpt_inp_node SET epa_type = 'JUNCTION' WHERE node_id IN (select node_id FROM v_edit_node
	JOIN (select unnest((replace (replace((v_switch2junction::text),'[','{'),']','}'))::text[]) as type)a ON a.type = node_type) AND result_id = p_result;

	RAISE NOTICE 'setting pump curves (pump_type = 1) where curve_id is null';
	UPDATE rpt_inp_arc SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', v_defaultcurve1) WHERE addparam::json->>'curve_id'='' AND addparam::json->>'pump_type'='1' AND result_id = p_result ;

	RAISE NOTICE 'setting pump curves (pump_type = 2) where curve_id is null';
	UPDATE rpt_inp_arc SET addparam = gw_fct_json_object_set_key(addparam::json, 'curve_id', v_defaultcurve2) WHERE addparam::json->>'curve_id'='' AND addparam::json->>'pump_type'='2' AND result_id = p_result ;

	RAISE NOTICE 'setting pressure for PRV valves';
	UPDATE rpt_inp_arc SET addparam = gw_fct_json_object_set_key (addparam::json, 'pressure', v_pressureprv) 
	WHERE epa_type = 'VALVE' AND addparam::json->>'valv_type' IN ('PRV') AND addparam::json->>'pressure'='' AND result_id  = p_result;

	RAISE NOTICE 'setting pressure for PSV valves';
	UPDATE rpt_inp_arc SET addparam = gw_fct_json_object_set_key (addparam::json, 'pressure', v_pressurepsv) 
	WHERE epa_type = 'VALVE' AND addparam::json->>'valv_type' IN ('PSV') AND addparam::json->>'pressure'='' AND result_id  = p_result;

	RAISE NOTICE 'setting curve for BINODE2ARC-PRV valves';
	UPDATE rpt_inp_arc SET addparam = gw_fct_json_object_set_key (addparam::json, 'pressure', 0) 
	WHERE arc_type = 'BINODE2ARC-PRV' AND result_id  = p_result;

	RAISE NOTICE 'transform all tanks by reservoirs with link and junction';
	v_querytext = 'SELECT * FROM rpt_inp_node WHERE (epa_type = ''TANK'' OR epa_type = ''INLET'') AND result_id = '||quote_literal(p_result);
	FOR v_record IN EXECUTE v_querytext
	LOOP

		-- new point
		v_x=st_x(v_record.the_geom);
		v_y=st_y(v_record.the_geom) + v_n2nlength;
		v_geom_point = ST_setsrid(ST_MakePoint(v_x, v_y),v_srid);

		-- new line
		v_geom_line = ST_MakeLine(v_record.the_geom, v_geom_point);

		-- modify the epa_type of the existing node
		UPDATE rpt_inp_node SET epa_type='JUNCTION' WHERE id = v_record.id AND result_id = p_result;

		-- insert new pipe
		INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom, expl_id, minorloss) VALUES
		(p_result, concat(v_record.node_id,'_n2n'), v_record.node_id, concat(v_record.node_id,'_n2n_r'), 'NODE2NODE', v_record.node_id, 'SHORTPIPE', v_record.sector_id, v_record.state, v_record.state_type, v_record.annotation, 
		999, v_roughness, 1, 'OPEN', v_geom_line, v_record.expl_id, 0);
	
		-- insert new reservoir
		INSERT INTO rpt_inp_node (result_id, node_id, elevation, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom, expl_id) 
		SELECT result_id, concat(v_record.node_id,'_n2n_r'), elevation, 'VIRT-RESERVOIR', v_record.nodecat_id, 'RESERVOIR', sector_id, state, state_type, annotation, demand, v_geom_point, expl_id
		FROM rpt_inp_node WHERE id = v_record.id AND result_id = p_result;

	END LOOP;


	RAISE NOTICE 'deleting nodes disconnected from any reservoir';
	DELETE FROM rpt_inp_node WHERE node_id IN (SELECT arc.node_1 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user 
						   UNION SELECT arc.node_2 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;

	RAISE NOTICE 'deleting arcs disconnected from any reservoir';
	DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;

	RAISE NOTICE 'delete orphan nodes';	
	DELETE FROM rpt_inp_node WHERE node_id IN (SELECT node_id FROM anl_node WHERE fprocesscat_id=7 AND cur_user=current_user) AND result_id=p_result;

	RAISE NOTICE 'deleting arcs without extremal nodes';
	DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=3 AND cur_user=current_user) AND result_id=p_result;	

	
	RAISE NOTICE 'set pressure groups';
	UPDATE rpt_inp_arc SET status= v_statuspg WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1'); 
	
	IF v_forcestatuspg IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status=v_forcestatuspg WHERE arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1') AND result_id=p_result;
	END IF;
	
	RAISE NOTICE 'set pump stations';
	UPDATE rpt_inp_arc SET status= v_statusps WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 

	IF v_forcestatusps IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusps WHERE result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 
	END IF;
		
	RAISE NOTICE 'set prv valves';
	UPDATE rpt_inp_arc SET status=v_statusprv WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve);
	
	IF v_forcestatusprv IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusprv WHERE result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve); 
	END IF;

	RAISE NOTICE 'set psv valves';
	UPDATE rpt_inp_arc SET status=v_statuspsv WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve WHERE valv_type = 'PRV');
	
	IF v_forcestatusprv IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatuspsv WHERE result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve WHERE valv_type = 'PRV'); 
	END IF;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
