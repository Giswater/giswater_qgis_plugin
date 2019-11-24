/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2774

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_fast_buildup(p_result text)
RETURNS integer 
AS $BODY$

/*example
SELECT SCHEMA_NAME.gw_fct_pg2epa($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"data":{"resultId":"t12", "useNetworkGeom":"false"}}$$)
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
v_buffer float;
v_n2nlength float;
v_querytext text;
v_diameter float;
v_defaultdemand float;
v_demandtype int2;

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
	SELECT epsg INTO v_srid FROM version LIMIT 1;

	-- system variables
	SELECT (value::json->>'node')::json->>'nullElevBuffer' INTO v_buffer FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'junction')::json->>'defaultDemand' INTO v_defaultdemand FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'pipe')::json->>'diameter' INTO v_diameter FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'tank')::json->>'distVirtualReservoir' INTO v_n2nlength FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'pressGroup')::json->>'status' INTO v_statuspg FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'pressGroup')::json->>'forceStatus' INTO v_forcestatuspg FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'pumpStation')::json->>'status' INTO v_statusps FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'pumpStation')::json->>'forceStatus' INTO v_forcestatusps FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'PRV')::json->>'status' INTO v_statusprv FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	SELECT (value::json->>'PRV')::json->>'forceStatus' INTO v_forcestatusprv FROM config_param_system WHERE parameter = 'inp_fast_buildup';
	
	-- get user variables
	SELECT value INTO v_demandtype FROM config_param_user WHERE parameter = 'inp_options_demandtype' AND cur_user=current_user;


	-- delete orphan nodes
	DELETE FROM rpt_inp_node WHERE result_id = p_result AND node_id NOT IN 
	(SELECT node_1 FROM rpt_inp_arc WHERE result_id = p_result UNION SELECT node_2 FROM rpt_inp_arc WHERE result_id = p_result) ;
	

	-- deleting arcs without extremal nodes
	DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=3 AND cur_user=current_user) AND result_id=p_result;	

	-- deleting arcs and nodes disconnected from any reservoir
	DELETE FROM rpt_inp_node WHERE node_id IN (SELECT node_1 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user 
						   UNION SELECT node_2 FROM anl_arc JOIN arc USING (arc_id) WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;
	DELETE FROM rpt_inp_arc WHERE arc_id IN (SELECT arc_id FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user) AND result_id=p_result;


	-- setting roughness for null values
	SELECT avg(roughness) INTO v_roughness FROM rpt_inp_arc WHERE result_id=p_result;
	UPDATE rpt_inp_arc SET roughness = v_roughness WHERE roughness IS NULL AND result_id= p_result;

	-- setting demands for null values
	IF v_defaultdemand IS NOT NULL AND v_demandtype = 1 THEN
		UPDATE rpt_inp_node SET demand = v_defaultdemand WHERE demand IS NULL AND result_id= p_result;
	END IF;
	
	-- setting diameter for null values
	UPDATE rpt_inp_arc SET diameter = v_diameter WHERE diameter IS NULL AND result_id= p_result;

	-- setting null elevation values using closest points values
	UPDATE rpt_inp_node SET elevation = d.elevation FROM
		(SELECT c.n1 as node_id, e2 as elevation FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.elevation as e1, a.the_geom as n1_geom, b.node_id as n2, b.elevation as e2, b.the_geom as n2_geom FROM node a, node b 
		WHERE st_dwithin (a.the_geom, b.the_geom, v_buffer) AND a.node_id != b.node_id AND a.elevation IS NULL AND b.elevation IS NOT NULL) c order by st_distance (n1_geom, n2_geom))d
	WHERE rpt_inp_node.elevation IS NULL AND d.node_id=rpt_inp_node.node_id AND result_id=p_result;
	v_querytext = 'SELECT * FROM rpt_inp_node WHERE (epa_type = ''TANK'' OR epa_type = ''INLET'') AND result_id = '||quote_literal(p_result);

	-- setting cero on elevation those have null values in spite of previous process
	UPDATE rpt_inp_node SET elevation = 0 WHERE elevation IS NULL AND result_id=p_result;

	-- transform all tanks by reservoirs with link and junction
	FOR v_record IN EXECUTE v_querytext
	LOOP
		raise notice '  %', v_record;

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
	
	-- set pressure groups
	UPDATE rpt_inp_arc SET status= v_statuspg WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1'); 
	
	IF v_forcestatuspg IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status=v_forcestatuspg WHERE arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1') AND result_id=p_result;
	END IF;
	
	-- set pump stations
	UPDATE rpt_inp_arc SET status= v_statusps WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 

	IF v_forcestatusps IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusps WHERE result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 
	END IF;
		
	-- set valves
	UPDATE rpt_inp_arc SET status=v_statusprv WHERE status IS NULL AND result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve);
	
	IF v_forcestatusprv IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusprv WHERE result_id = p_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve); 
	END IF;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
