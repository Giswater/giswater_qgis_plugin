/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 2128

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_plan_result_rec(integer, double precision, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_plan_result_rec(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_plan_result_rec($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"data":{"parameters":{"step":1, "resultName":"test4", "coefficient":1, "descript":"test text"}}}$$)

SELECT SCHEMA_NAME.gw_fct_plan_result_rec($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"data":{"parameters":{"step":2, "resultName":"test", "coefficient":1, "descript":"test text"}}}$$)

--fid: 249

Function has two steps:

STEP 1:  fill table

STEP 2: Calculate amortitzations

Between step 1 and 2 need to be filled initcost and it is possible to be update acoeff (it's filled on step 1 using default value from catalog acoeff)

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
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	-- getting input data 	
	v_result_name :=  (((p_data ->>'data')::json->>'parameters')::json->>'resultName');
	v_coeff :=  (((p_data ->>'data')::json->>'parameters')::json->>'coefficient');
	v_descript :=  (((p_data ->>'data')::json->>'parameters')::json->>'descript');
	v_step :=  (((p_data ->>'data')::json->>'parameters')::json->>'step');
	
	-- control nulls of step
	IF v_step is null then v_step = 1; end if;
	
	-- getting pricecat
	v_pricecat = (SELECT id FROM plan_price_cat LIMIT 1);
	
	IF v_step = 1 THEN
			-- start build log message
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"2128", "fid":"'||v_fid||'", "is_process":true, "is_header":"true"}}$$)';

		IF v_result_name IN (SELECT name FROM plan_result_cat) THEN 
			
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4006", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';
		ELSE
			-- inserting result on table plan_result_cat
			INSERT INTO plan_result_cat (name, result_type, coefficient, tstamp, cur_user, descript, pricecat_id) VALUES
			(v_result_name, 1, v_coeff, now(), current_user, v_descript, v_pricecat) RETURNING result_id INTO v_result_id;

		
			-- starting process
			INSERT INTO plan_rec_result_node (result_id, node_id, nodecat_id, node_type, top_elev, elev, epa_type, sector_id, state, annotation,
			the_geom, cost_unit, descript, measurement, cost, budget, expl_id, builtdate, age, acoeff)

			SELECT
			v_result_id,
			v.node_id,
			v.nodecat_id,
			v.node_type,
			v.top_elev,
			v.elev,
			v.epa_type,
			v.sector_id,
			v.state,
			v.annotation,
			v.the_geom,
			v.cost_unit,
			v.descript,
			measurement,
			v.cost*v_coeff,
			v.budget*v_coeff,
			v.expl_id,
			builtdate,
			((date_part('days',(now()-node.builtdate)::interval))/365)::numeric(12,2) as age,
			acoeff
			FROM v_plan_node v
			JOIN node USING (node_id)
			JOIN cat_node ON id = node.nodecat_id
			WHERE v.state=1
			ON CONFLICT (result_id, node_id) DO NOTHING;


			-- insert into arc table
			INSERT INTO plan_rec_result_arc
			SELECT
			v_result_id,
			v.arc_id,
			v.node_1,
			v.node_2,
			v.arc_type,
			v.arccat_id,
			v.epa_type,
			v.sector_id,
			v.state,
			v.annotation,
			v.soilcat_id,
			v.y1,
			v.y2,
			v.mean_y,
			v.z1,
			v.z2,
			v.thickness,
			v.width,
			v.b,
			v.bulk,
			v.geom1,
			v.area,
			v.y_param,
			v.total_y,
			v.rec_y,
			v.geom1_ext,
			v.calculed_y,
			v.m3mlexc,
			v.m2mltrenchl,
			v.m2mlbottom,
			v.m2mlpav,
			v.m3mlprotec,
			v.m3mlfill,
			v.m3mlexcess,
			v.m3exc_cost,
			v.m2trenchl_cost*v_coeff,
			v.m2bottom_cost*v_coeff,
			v.m2pav_cost*v_coeff,
			v.m3protec_cost*v_coeff,
			v.m3fill_cost*v_coeff,
			v.m3excess_cost*v_coeff,
			v.cost_unit,
			v.pav_cost*v_coeff,
			v.exc_cost*v_coeff,
			v.trenchl_cost*v_coeff,
			v.base_cost*v_coeff,
			v.protec_cost*v_coeff,
			v.fill_cost*v_coeff,
			v.excess_cost*v_coeff,
			v.arc_cost*v_coeff,
			v.cost*v_coeff,
			v.length,
			v.budget*v_coeff,
			v.other_budget*v_coeff,
			v.total_budget*v_coeff,
			v.the_geom,
			v.expl_id,
			null,
			builtdate,
			((date_part('days',(now()-a.builtdate)::interval))/365)::numeric(12,2) as age,
			acoeff
			FROM v_plan_arc v
			JOIN arc a USING (arc_id)
			JOIN cat_arc c ON c.id = a.arccat_id
			WHERE a.state=1
			ON CONFLICT (result_id, arc_id) DO NOTHING;

			-- force selector
			INSERT INTO selector_plan_result (cur_user, result_id) VALUES (current_user, v_result_id) ON CONFLICT (cur_user, result_id) DO NOTHING;

			-- inserting log
			
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4008", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';


				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4010", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';


	
					EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4012", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';
		END IF;
	ELSIF v_step = 2 THEN
		
		-- update result on node table
		UPDATE plan_rec_result_node SET
			aperiod = concat ((1/acoeff)::numeric(6,1), ' years'),
			arate = (builtcost * acoeff)::numeric(12,2),
			amortized = CASE WHEN (age::float * builtcost * acoeff) < builtcost THEN (age * builtcost * acoeff)::numeric(12,2) 
						ELSE builtcost::numeric(12,2) END,
			pending = CASE WHEN (age * builtcost * acoeff)< builtcost THEN (builtcost - age * builtcost * acoeff)::numeric(12,2) 
						ELSE 0::numeric(12,2) END
		WHERE result_id = v_result_id;
		
		-- update result on arc table
		UPDATE plan_rec_result_arc SET
			aperiod = concat ((1/acoeff)::numeric(6,1), ' years'),
			arate = (builtcost * acoeff)::numeric(12,2),
			amortized = CASE WHEN (age::float * builtcost * acoeff) < builtcost THEN (age * builtcost * acoeff)::numeric(12,2) 
						ELSE builtcost::numeric(12,2) END,
			pending = CASE WHEN (age * builtcost * acoeff)< builtcost THEN (builtcost - age * builtcost * acoeff)::numeric(12,2) 
						ELSE 0::numeric(12,2) END
		WHERE result_id = v_result_id;

		
			EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4014", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';

		INSERT INTO audit_check_data (fid, error_message) 
		VALUES (v_fid, 'Amortized values using age,cost and acoeff have been calculated');
				EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4016", "function":"2128", "fid":"'||v_fid||'", "is_process":true}}$$)';
	
	END IF;
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	raise notice 'v_result_info %', v_result_info;

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
		     '}'||
	    '}}')::json,2128, null, null, null);
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
