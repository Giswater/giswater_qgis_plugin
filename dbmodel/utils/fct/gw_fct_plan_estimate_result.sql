
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_estimate_result(varchar, float, text);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_plan_estimate_result(result_name_var text, coefficient_var float, descript_var text) RETURNS integer AS

$BODY$

DECLARE 
id_last integer;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;


	-- insert into result_cat table
	INSERT INTO plan_result_cat (name, network_price_coeff, tstamp, cur_user, descript) 
	VALUES ( result_name_var, coefficient_var, now(), current_user, descript_var)  RETURNING result_id INTO id_last;
	
	-- insert into node table
	INSERT INTO plan_result_node
	SELECT
	nextval('SCHEMA_NAME.plan_result_node_id_seq'::regclass),
	result_name_var,
	v_edit_node.node_id,
	v_edit_node.nodecat_id,
	v_edit_node.node_type,
	v_edit_node.top_elev,
	v_edit_node.elev,
	v_edit_node.epa_type,
	v_edit_node.sector_id,
	v_edit_node.state,
	annotation,
	v_edit_node.the_geom,
	cost_unit,
	calculated_depth,
	cost*coefficient_var,
	budget*coefficient_var
	FROM v_plan_node
	JOIN v_edit_node on v_edit_node.node_id=v_plan_node.node_id
	WHERE v_edit_node.state=1;
	
	
	-- insert into arc table
	INSERT INTO plan_result_arc
	SELECT
	nextval('SCHEMA_NAME.plan_result_arc_id_seq'::regclass),
	result_name_var,
	v_edit_arc.arc_id,
	node_1,
	node_2,
	arc_type,
	v_edit_arc.arccat_id,
	epa_type,
	sector_id,
	v_edit_arc.state,
	annotation,
	length,
	v_edit_arc.the_geom,
	v_edit_arc.soilcat_id,
	v_edit_arc.y1,
	v_edit_arc.y2,
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
	bulk_bottom,
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
	arc_cost*coefficient_var,
	cost*coefficient_var,
	budget*coefficient_var,
	other_total_cost*coefficient_var,
	total_budget*coefficient_var
	FROM v_plan_arc
	JOIN v_edit_arc ON v_edit_arc.arc_id=v_plan_arc.arc_id;
	
RETURN 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
