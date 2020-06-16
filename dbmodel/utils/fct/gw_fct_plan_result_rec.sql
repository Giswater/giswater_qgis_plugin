/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2128

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result_rec(integer, double precision, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result_rec(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_result_rec($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"data":{"step":1, "parameters":{"resultName":"test", "coefficient":1, "descript":"test text"}}}$$)

SELECT SCHEMA_NAME.gw_fct_plan_result_rec($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"data":{"step":2, "parameters":{"resultName":"test", "coefficient":1, "descript":"test text"}}}$$)

--fid: 249

Function has two steps:

STEP 1:  fill table

STEP 2: Calculate amortitzations

Btween step 1 and 2 need to be filled initcost and it is possible to be update acoeff (it's filled on step 1 using default value from catalog acoeff)

*/

DECLARE 

v_result_id integer;
v_result_name text;
v_coeff float;
v_descript text;
v_fid integer = 249;
v_version text;
v_result text;
v_result_info json;
v_error_context text;
v_pricecat text = 'DEFAULT';
v_step integer ;

BEGIN 

	-- set search_path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;

	-- Reset values
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- getting input data 	
	v_result_name :=  (((p_data ->>'data')::json->>'parameters')::json->>'resultName');
	v_coeff :=  (((p_data ->>'data')::json->>'parameters')::json->>'coefficient');
	v_descript :=  (((p_data ->>'data')::json->>'parameters')::json->>'descript');
	v_step :=  ((p_data ->>'data')::json->>'step');
	
	-- control nulls of step
	IF v_step = '' OR v_step is null then v_step = 1; end if;
	
	-- getting pricecat
	v_pricecat = (SELECT id FROM plan_price_cat LIMIT 1);
	
	IF v_step =  1 THEN

		-- inserting result on table plan_result_cat
		INSERT INTO plan_result_cat (name, result_type, coefficient, tstamp, cur_user, descript, pricecat_id) VALUES
		(v_result_name, 1, v_coeff, now(), current_user, v_descript, v_pricecat) RETURNING result_id INTO v_result_id;

		-- start build log message
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('CALCULATE COST OF RECONSTRUCTION'));
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, concat('----------------------------------------------------------'));


		-- starting process
		INSERT INTO plan_rec_result_node (result_id, node_id, nodecat_id, node_type, top_elev, elev, epa_type, sector_id, state, annotation,
		the_geom, cost_unit, descript, measurement, cost, budget, expl_id, age, acoeff)

		SELECT
		v_result_id,
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
		cost*v_coeff,
		budget*v_coeff,
		expl_id,
		age, acoeff
		FROM v_plan_node
		WHERE state=1
		ON CONFLICT (result_id, node_id) DO NOTHING;


		-- insert into arc table
		INSERT INTO plan_rec_result_arc
		SELECT
		v_result_id,
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
		m2trenchl_cost*v_coeff,
		m2bottom_cost*v_coeff,
		m2pav_cost*v_coeff,
		m3protec_cost*v_coeff,
		m3fill_cost*v_coeff,
		m3excess_cost*v_coeff,
		cost_unit,
		pav_cost*v_coeff,
		exc_cost*v_coeff,
		trenchl_cost*v_coeff,
		base_cost*v_coeff,
		protec_cost*v_coeff,
		fill_cost*v_coeff,
		excess_cost*v_coeff,
		arc_cost*v_coeff,
		cost*v_coeff,
		length,
		budget*v_coeff,
		other_budget*v_coeff,
		total_budget*v_coeff,
		the_geom,
		expl_id,
		age,
		acoeff
		FROM v_plan_arc
		WHERE state=1
		ON CONFLICT (result_id, arc_id) DO NOTHING;

		-- force selector
		INSERT INTO selector_plan_result (cur_user, result_id) VALUES (current_user, v_result_id) ON CONFLICT (cur_user, result_id) DO NOTHING;

		-- inserting log
		INSERT INTO audit_check_data (fid, error_message) VALUES (v_fid, 'Process -> Done');
	
	ELSIF v_step = 2 THEN
		
		-- update result on node table
		UPDATE plan_rec_result_node SET
			aperiod = concat ((1/acoeff)::numeric(6,1), ' years'),
			arate = (initcost * acoeff)::numeric(12,2),
			amortized = CASE WHEN (age::float * initcost * acoeff) < initcost THEN (age * initcost * acoeff)::numeric(12,2) 
						ELSE initcost::numeric(12,2) END,
			pending = 	CASE WHEN (age * initcost * acoeff)< initcost THEN (initcost - age * initcost * acoeff)::numeric(12,2) 
						ELSE 0::numeric(12,2) END
		WHERE result_id = v_result_id;
		
		-- update result on arc table
		UPDATE plan_rec_result_arc SET
			aperiod = concat ((1/acoeff)::numeric(6,1), ' years'),
			arate = (initcost * acoeff)::numeric(12,2),
			amortized = CASE WHEN (age::float * initcost * acoeff) < initcost THEN (age * initcost * acoeff)::numeric(12,2) 
						ELSE initcost::numeric(12,2) END,
			pending = 	CASE WHEN (age * initcost * acoeff)< initcost THEN (initcost - age * initcost * acoeff)::numeric(12,2) 
						ELSE 0::numeric(12,2) END
		WHERE result_id = v_result_id;
	
	END IF;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT * FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	raise notice 'v_result_info %', v_result_info;

	-- Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||',"setVisibleLayers":[]}'||
		     '}'||
	    '}')::json;

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

