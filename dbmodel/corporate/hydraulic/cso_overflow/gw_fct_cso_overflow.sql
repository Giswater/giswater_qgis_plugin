/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_cso_calculation(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT SCHEMA_NAME.gw_fct_cso_calculation
($${"data":{
"thyssenPlv":{
	"tableName":"thy.thy_final_cn", 
	"curveNumber":"cn_value", 
	"drainzoneId":"drainzone_", 
	"poValue":"po", 
	"cValue":"c_value",
	"ciValue":"ci_value"
},
"thyssenRes":{"tableName":"thy.thy_residuals", "drainzoneId":"drainzone_"},
"rainfallParams":{"tstepMinutes":10},
"parameters": {}}}$$);


WARNING! The name of the tables MUST be within the name of the schema.

SELECT ud.gw_fct_cso_calculation($${"client":{"device":4, "lang":"es_ES", "epsg":25830}, "form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"macroexplId":"5", "drainzoneId":null}}}$$);

SELECT ud.gw_fct_cso_calculation(concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{},"parameters":{"macroexplId":"5", "drainzoneId":', drainzone_id, '}}}')::json)
FROM ud.drainzone WHERE link IS NOT NULL;

*/

DECLARE
rec_rainfall record;
rec_subc record;

v_returncoeff numeric;
v_daily_supply numeric;

v_thy_plv_table text;
v_thy_plv_drainzone text;
v_plv_cn text;
v_plv_po text;
v_plv_ci text;
v_geom_thy_plv text;

v_thy_res_table text;
v_thy_res_drainzone text;


v_count integer;
v_sql text;

v_tstep numeric;

v_selected_macroexpl_id text;
v_selected_drainzone_id text;

v_filter_macroexpl text;
v_filter_drainzone TEXT;


BEGIN
	
	SET search_path = "SCHEMA_NAME", public;



	-- input params
	v_thy_plv_table := ((p_data ->>'data')::json->>'thyssenPlv')::json->>'tableName'::text;
	v_thy_plv_drainzone := ((p_data ->>'data')::json->>'thyssenPlv')::json->>'drainzoneId'::text;
	v_plv_cn := ((p_data ->>'data')::json->>'thyssenPlv')::json->>'curveNumber'::text;
	v_plv_po := ((p_data ->>'data')::json->>'thyssenPlv')::json->>'poValue'::text;
	v_plv_ci := ((p_data ->>'data')::json->>'thyssenPlv')::json->>'ciValue'::text;

	v_thy_res_table := ((p_data ->>'data')::json->>'thyssenRes')::json->>'tableName'::text;
	v_thy_res_drainzone := ((p_data ->>'data')::json->>'thyssenRes')::json->>'drainzoneId'::text;

	v_tstep = 10; -- tstep of the timeseries (every 10 mins, 5 mins., etc.)

	v_selected_macroexpl_id := (((p_data ->>'data')::json->>'parameters')::json->>'macroexplId')::text;
	v_selected_drainzone_id := (((p_data ->>'data')::json->>'parameters')::json->>'drainzoneId')::text;



	
	IF v_selected_macroexpl_id IS NOT NULL then

		IF v_selected_macroexpl_id = '-901' THEN -- selected macroexpl

			SELECT string_agg(macroexpl_id::text, ',') into v_selected_macroexpl_id from selector_macroexpl where cur_user = current_user;
		
		END IF;
		
		v_filter_macroexpl = 'e.macroexpl_id IN ('||v_selected_macroexpl_id||')';
	
	END IF;

	
	IF v_selected_drainzone_id IS NOT NULL THEN
	
		v_filter_drainzone = 'AND d.drainzone_id IN ('||v_selected_drainzone_id||')';

	ELSE

		v_filter_drainzone = '';
	
	END IF;


	-- get the drainzones of execution according to selected options
	v_sql = '
	SELECT d.drainzone_id
	FROM drainzone d 
	JOIN node n ON d.graphconfig::json ->''use''->0 ->>''nodeParent''::TEXT = n.node_id::TEXT
	JOIN exploitation e ON n.expl_id = e.expl_id WHERE '||v_filter_macroexpl||' '||v_filter_drainzone||' AND d.active IS TRUE';


	EXECUTE 'SELECT count(*) from ('||v_sql||')a' INTO v_count;

	IF v_count = 0 THEN
	
		return '{"status": "Failed", "message":{"level":1, "text":"No drainzones match with selected macroexpl and/or drainzone"}}'::json;
	
	ELSE
	
		EXECUTE 'SELECT string_agg(drainzone_id::text, '', '') FROM ('||v_sql||')a' INTO v_selected_drainzone_id;	
	
	END IF;

	-- reset data from selected drainzone_id
	execute 'delete from cso_inp_system_subc where drainzone_id in ('||v_selected_drainzone_id||')';
	execute 'delete from cso_out_vol where drainzone_id in ('||v_selected_drainzone_id||')';

	-- config variables
	v_returncoeff = (select value::numeric from config_param_system where "parameter" = 'cso_returncoeff');
	v_daily_supply = (select value::numeric from config_param_system where "parameter" = 'cso_daily_supply');

	
	-- INITIAL DATA: SCHEMA_NAME NETWORK DATA (cso_inp_system_subc)
	-- ===================================================

	-- SCHEMA_NAME data: drainzones, outfalls and its specific features (vret, etc.)
	execute '
	insert into cso_inp_system_subc (node_id, drainzone_id, q_max, vret)
	select 
	(graphconfig::json ->''use''->0 ->>''nodeParent'')::text as node_id,
	drainzone_id,
	(link::json ->>''qmax'')::numeric as qmax,
	(link::json ->>''vret'')::numeric as vret
	from drainzone where link is not null and drainzone_id IN ('||v_selected_drainzone_id||')
	on conflict (node_id, drainzone_id) do nothing';

	-- imperv area 
	execute '
	update cso_inp_system_subc t set imperv_area = a.imperv from (
		select drainzone_id, sum(st_area(the_geom) * cn_value/100) as imperv from cso_subc_wwf group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id;
	';

	-- area of rainwater thyssen group by drainzone
	execute '
	update cso_inp_system_subc t set thyssen_plv_area = a.area_thy from (
	select drainzone_id, sum(st_area(the_geom)) as area_thy 
	from cso_subc_wwf group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id
	';
	
	-- mean_runoff_coef
	execute '
	update cso_inp_system_subc t set mean_coef_runoff = a.c_value from (
	select drainzone_id, avg(ci_value) as c_value from cso_subc_wwf group by drainzone_id
	)a where a.drainzone_id = t.drainzone_id
	';
	
	-- sum of demand from sewage thyssen group by drainzone 
	execute '
	update cso_inp_system_subc s set demand = a.consumo from (
	select drainzone_id, sum(consumption) as consumo from cso_subc_dwf cntr
	where drainzone_id is not null
	group by drainzone_id)a where s.drainzone_id = a.drainzone_id';

	-- calc of equivalent inhabitants
	execute '
	update cso_inp_system_subc t set eq_inhab = demand * 3600 * 24 / '||v_daily_supply||'
	';

	-- set constant value of RD 665/2023
	update cso_inp_system_subc set kb = 1.13;

	-- vret_imperv
	update cso_inp_system_subc set vret_imperv = vret/imperv_area;

	
	-- set active drainzones
	update cso_inp_system_subc set active = true;
	
	-- set null to 0
	update cso_inp_system_subc set q_max = 0 where q_max is null;
	update cso_inp_system_subc set vret = 0 where vret is null;
	update cso_inp_system_subc set eq_inhab = 0 where eq_inhab is null;



	-- INITIAL DATA: RAINFALL (from active timeseries from inp_timeseries_value)
	-- =========================================================================

	create temp table cso_inp_rainfall as
		select timser_id as rf_name, 60*v_tstep as rf_length, value as rf_volume, (value*6)::numeric as rf_intensity, "time" as rf_tstep
		from inp_timeseries_value a 
		join inp_timeseries t on a.timser_id = t.id 
		where t.active is true
		ORDER BY 1, 5;
	
	
	-- CHECK INPUT DATA (before calc)
	-- ==============================

	-- config variables exist
	IF v_returncoeff is null or v_daily_supply is null then 
	
		raise exception 'v_returncoeff, v_daily_supply % %', v_daily_supply, v_daily_supply;
	
	END IF;
	
	if (select count(*) from cso_inp_rainfall) = 0 then
	
		raise exception 'no tienes lluvias en la cso_inp_rainfall';
		
	end if;
	

	-- START ALGORITHM
	-- ===============
	
	-- for each rainfall
	FOR rec_rainfall in select * from cso_inp_rainfall
	LOOP	
		
		-- for each subcatchment
		FOR rec_subc in execute 'select * from cso_inp_system_subc where drainzone_id in ('||v_selected_drainzone_id||')'
		LOOP
			
			raise notice 'rec_rainfall.rf_name: %, rec_rainfall.rf_tstep: %', rec_rainfall.rf_name, rec_rainfall.rf_tstep;

			-- insert basic data
			INSERT INTO cso_out_vol (node_id, drainzone_id, rf_name, rf_tstep, rf_volume, rf_intensity)
			VALUES (rec_subc.node_id, rec_subc.drainzone_id, rec_rainfall.rf_name, rec_rainfall.rf_tstep, rec_rainfall.rf_volume, rec_rainfall.rf_intensity);
	
			-- fill table cso_out_vol
			update cso_out_vol
				set 
				vol_residual = rec_subc.demand * v_returncoeff * 600 / 1000,
				vol_max_epi = rec_subc.q_max * rec_rainfall.rf_length / 1000,
				vol_res_epi = (rec_subc.demand * rec_rainfall.rf_length) / 1000, 
				vol_rainfall = 1000 * rec_subc.kb * rec_rainfall.rf_volume * rec_subc.thyssen_plv_area/(1000*1000)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
				
			update cso_out_vol
				set vol_total = vol_residual + vol_rainfall 
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_runoff = vol_rainfall * rec_subc.imperv_area / rec_subc.thyssen_plv_area
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
		
			update cso_out_vol
				set vol_infiltr = vol_rainfall - vol_runoff 
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep; 
			
			update cso_out_vol
				set vol_circ = vol_runoff + vol_residual
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_circ_dep = case when vol_circ > rec_subc.vret then rec_subc.vret else vol_circ end 
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_circ_red = case when vol_circ - vol_circ_dep < 0 then 0 else vol_circ - vol_circ_dep end
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_non_leaked = least(vol_circ_red, vol_max_epi)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_leaked = vol_circ_red - vol_non_leaked
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_wwtp = vol_non_leaked + vol_circ_dep 
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			update cso_out_vol
				set vol_treated = vol_infiltr + vol_wwtp -- columna Z
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			-- efficiency
			-- ===========
			update cso_out_vol 
				set efficiency = vol_treated / vol_total -- columna AA
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep; 
		END LOOP;
		
	END LOOP;
	

	-- clean temp tables
	drop table if exists cso_inp_rainfall;

	return '{"status": "Accepted", "message":{"level":1, "text":"done succesfully"}}'::json;

END;
$function$
;
