/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128



DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result_rec(integer, double precision, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result_rec( result_id_var integer, coefficient_var double precision, descript_var text)
  RETURNS integer AS
$BODY$

DECLARE 


BEGIN 

    SET search_path = "SCHEMA_NAME", public;

    -- reconstruction
	
	INSERT INTO om_rec_result_node (result_id, node_id, nodecat_id, node_type, top_elev, elev, epa_type, sector_id, state, annotation,
	the_geom, cost_unit, descript, measurement, cost, budget, expl_id)

	SELECT
	result_id_var,
	node_id,
	nodecat_id,
	node_type,
	top_elev,
	elev,
	epa_type,
	sector_id,
	state,
	annotation,
	the_geom,
	cost_unit,
	descript,
	measurement,
	cost*coefficient_var,
	budget*coefficient_var,
	expl_id
	FROM v_plan_node
	WHERE state=1;
	
	
	-- insert into arc table
	INSERT INTO om_rec_result_arc
	SELECT
	nextval('SCHEMA_NAME.om_rec_result_arc_id_seq'::regclass),
	result_id_var,
	arc_id,
	node_1,
	node_2,
	arc_type,
	arccat_id,
	epa_type,
	sector_id,
	state,
	annotation,
	soilcat_id,
	y1,
	y2,
	mean_y,
	v_plan_arc.z1,
	v_plan_arc.z2,
	thickness,
	width,
	b,
	bulk,
	geom1,
	area,
	y_param,
	total_y,
	rec_y,
	geom1_ext,
	calculed_y,
	m3mlexc,
	m2mltrenchl,
	m2mlbottom,
	m2mlpav,
	m3mlprotec,
	m3mlfill,
	m3mlexcess,
	m3exc_cost,
	m2trenchl_cost*coefficient_var,
	m2bottom_cost*coefficient_var,
	m2pav_cost*coefficient_var,
	m3protec_cost*coefficient_var,
	m3fill_cost*coefficient_var,
	m3excess_cost*coefficient_var,
	cost_unit,
	pav_cost*coefficient_var,
	exc_cost*coefficient_var,
	trenchl_cost*coefficient_var,
	base_cost*coefficient_var,
	protec_cost*coefficient_var,
	fill_cost*coefficient_var,
	excess_cost*coefficient_var,
	arc_cost*coefficient_var,
	cost*coefficient_var,
	length,
	budget*coefficient_var,
	other_budget*coefficient_var,
	total_budget*coefficient_var,
	the_geom,
	expl_id
	FROM v_plan_arc
	WHERE state=1;
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

