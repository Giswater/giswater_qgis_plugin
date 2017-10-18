DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_estimate_result(text, double precision, text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_estimate_result(
    result_name_var text,
    coefficient_var double precision,
    descript_var text)
  RETURNS integer AS
$BODY$

DECLARE 
id_last integer;

BEGIN 

    SET search_path = "SCHEMA_NAME", public;


	-- insert into result_cat table
	INSERT INTO plan_result_cat (name, network_price_coeff, tstamp, cur_user, descript) 
	VALUES ( result_name_var, coefficient_var, now(), current_user, descript_var)  RETURNING result_id INTO id_last;

	DELETE FROM plan_selector_result WHERE cur_user=current_user;
	INSERT INTO plan_selector_result (result_id, cur_user) VALUES (id_last, current_user);
	
	-- insert into node table
	INSERT INTO plan_result_node
	SELECT
	nextval('SCHEMA_NAME.plan_result_node_id_seq'::regclass),
	id_last,
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
	calculated_depth,
	cost*coefficient_var,
	budget*coefficient_var,
	expl_id
	FROM v_plan_node
	WHERE state=1;
	
	
	-- insert into arc table
	INSERT INTO plan_result_arc
	SELECT
	nextval('SCHEMA_NAME.plan_result_arc_id_seq'::regclass),
	id_last,
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
ALTER FUNCTION SCHEMA_NAME.gw_fct_plan_estimate_result(text, double precision, text)
  OWNER TO postgres;
