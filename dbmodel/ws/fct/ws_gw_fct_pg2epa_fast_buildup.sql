/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2774

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_pg2epa_fast_builtup(varchar);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_fast_builtup(v_result varchar)
RETURNS integer 
AS $BODY$

/*example
select SCHEMA_NAME.gw_fct_pg2epa ('r1', false, false)
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

BEGIN

	--  Search path
	SET search_path = "SCHEMA_NAME", public;

	-- get values
	SELECT epsg INTO v_srid FROM version LIMIT 1;

	SELECT value->>'nullElevBuffer' INTO v_buffer FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'tank'::json->>'distVirtualReservoir' INTO v_n2nlength FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'pressGroup'::json->>'status' INTO v_statuspg FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'pressGroup'::json->>'forceStatus' INTO v_forcestatuspg FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'pumpStation'::json->>'status' INTO v_statusps FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'pumpStation'::json->>'forceStatus' INTO v_forcestatusps FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'PRV'::json->>'status' INTO v_statusprv FROM config_param_syste WHERE parameter = 'inp_fast_builddup';
	SELECT value->>'PRV'::json->>'forceStatus' INTO v_forcestatusprv FROM config_param_syste WHERE parameter = 'inp_fast_builddup';


	
	-- setting roughness for null values
	SELECT avg(roughness) INTO v_roughness FROM rpt_inp_arc WHERE result_id=v_result;
	UPDATE rpt_inp_arc SET roughness = v_roughness WHERE roughness IS NULL AND result_id=v_result;

	-- setting null elevation values using closest points values
	UPDATE rpt_inp_node SET elevation = d.elevation FROM
		(SELECT c.n1 as node_id, e2 as elevation FROM (SELECT DISTINCT ON (a.node_id) a.node_id as n1, a.elevation as e1, a.the_geom as n1_geom, b.node_id as n2, b.elevation as e2, b.the_geom as n2_geom FROM node a, node b 
		WHERE st_dwithin (a.the_geom, b.the_geom, v_buffer) AND a.node_id != b.node_id AND a.elevation IS NULL AND b.elevation IS NOT NULL) c order by st_distance (n1_geom, n2_geom))d
	WHERE rpt_inp_node.elevation IS NULL AND d.node_id=rpt_inp_node.node_id AND result_id=v_result;
	
	-- transform all tanks by reservoirs with link and junction
	FOR v_record IN SELECT * FROM rpt_inp_node WHERE epa_type = 'TANK' AND result_id=v_result
	LOOP

		-- new point
		v_x=st_x (v_record.the_geom - v_n2nlength);
		v_y=st_y (v_record.the_geom);
		v_geom_point = ST_setsrid(ST_MakePoint(v_x, v_y),v_srid);

		-- new line
		v_geom_line = ST_MakeLine(v_record.the_geom, v_geom_point);


		-- modify the epa_type of the existing node
		UPDATE rpt_inp_node SET epa_type='JUNCTION' WHERE node_id = v_record.node_id AND result_id=v_result;

		-- insert new pipe
		INSERT INTO rpt_inp_arc (result_id, arc_id, node_1, node_2, arc_type, arccat_id, epa_type, sector_id, state, state_type, annotation, diameter, roughness, length, status, the_geom, expl_id, minorloss) VALUES
		(v_result, concat(v_record.node_id,'_n2n'), vrecord.node_id, concat(v_record.node_id,'_n2n_r'), 'NODE2NODE', vrecord.node_id, 'SHORTPIPE', sector_id, state, state_type, annotation, 999, v_roughness, 1, 'OPEN', v_geom_line, expl_id, 0);
	
		-- insert new reservoir
		INSERT INTO rpt_inp_node (result_id, node_id, elevation, node_type, nodecat_id, epa_type, sector_id, state, state_type, annotation, demand, the_geom, expl_id) 
		SELECT result_id, concat(v_record.node_id,'_n2n_1') elevation, 'VIRT-RESERVOIR', vrecord.node_id, 'RESERVOIR', sector_id, state, state_type, annotation, demand, v_geom_point, expl_id
		FROM rpt_inp_node WHERE node_id = v_record.node_id AND result_id=v_result;

	END LOOP;
	
	-- set pressure groups
	UPDATE rpt_inp_arc SET status= v_statuspg WHERE status IS NULL AND result_id=v_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1'); 
	
	IF v_forcestatuspg IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status=v_forcestatuspg WHERE arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '1') AND result_id=v_result;
	END IF;
	
	-- set pump stations
	UPDATE rpt_inp_arc SET status= v_statusps WHERE status IS NULL AND result_id=v_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 

	
	IF v_forcestatusps IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusps AND result_id=v_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_pump WHERE pump_type = '2'); 
	END IF;
		
	-- set valves
	UPDATE rpt_inp_arc SET status=v_statusprv WHERE status IS NULL AND result_id=v_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve);
	
	IF v_forcestatusprv IS NOT NULL THEN
		UPDATE rpt_inp_arc SET status= v_forcestatusprv AND result_id=v_result AND arc_id IN (SELECT concat(node_id, '_n2a') FROM inp_valve); 
	END IF;

    RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
