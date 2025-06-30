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



v_count integer;
v_sql text;

v_tstep numeric;

v_selected_macroexpl_id text;
v_selected_drainzone_id text;

v_filter_macroexpl text;
v_filter_drainzone TEXT;

v_timeseries_list TEXT;
v_inflows_dscenario TEXT;
v_dscenario_id integer;
v_expl_id text;

BEGIN
	
	SET search_path = "SCHEMA_NAME", public;



	-- input params

	v_tstep = 10; -- tstep of the timeseries (every 10 mins, 5 mins., etc.)

	v_selected_macroexpl_id := (((p_data ->>'data')::json->>'parameters')::json->>'macroexplId')::text;
	v_selected_drainzone_id := (((p_data ->>'data')::json->>'parameters')::json->>'drainzoneId')::text;
	v_inflows_dscenario := (((p_data ->>'data')::json->>'parameters')::json->>'inflowsDscenarioName')::text;

	EXECUTE '
	SELECT expl_id::text from exploitation WHERE macroexpl_id::text in ('||v_selected_macroexpl_id||'::text) ORDER BY expl_id LIMIT 1
	' INTO v_expl_id;


	
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
	JOIN exploitation e ON n.expl_id = e.expl_id WHERE '||v_filter_macroexpl||' '||v_filter_drainzone||' 
	AND d.active IS TRUE and d.link is not null';


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
	EXECUTE '
	insert into cso_inp_system_subc (node_id)
	select (graphconfig::json ->''use''->0 ->>''nodeParent'')::text
	from drainzone where link is not null and drainzone_id IN ('||v_selected_drainzone_id||')
	on conflict (node_id) do nothing';

	EXECUTE '
	update cso_inp_system_subc t set drainzone_id = a.drainzone_id, q_max = a.qmax, vret = a.vret from (
	select 
	(graphconfig::json ->''use''->0 ->>''nodeParent'')::text as node_id,
	drainzone_id,
	(link::json ->>''qmax'')::numeric as qmax,
	(link::json ->>''vret'')::numeric as vret
	from drainzone where link is not null and drainzone_id IN ('||v_selected_drainzone_id||')
	)a where t.node_id = a.node_id 
	';

	-- imperv area 
	execute '
	update cso_inp_system_subc t set imperv_area = a.imperv from (
		select drainzone_id, sum(st_area(the_geom) * cn_value/100) as imperv from cso_subc_wwf group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id and t.drainzone_id in ('||v_selected_drainzone_id||');
	';

	-- area of rainwater thyssen group by drainzone
	execute '
	update cso_inp_system_subc t set thyssen_plv_area = a.area_thy from (
	select drainzone_id, sum(st_area(the_geom)) as area_thy 
	from cso_subc_wwf group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id and t.drainzone_id in ('||v_selected_drainzone_id||')
	';
	
	-- mean_runoff_coef
	execute '
	update cso_inp_system_subc t set mean_coef_runoff = a.c_value from (
	select drainzone_id, avg(ci_value) as c_value from cso_subc_wwf group by drainzone_id
	)a where a.drainzone_id = t.drainzone_id and t.drainzone_id in ('||v_selected_drainzone_id||')
	';
	
	-- sum of demand from sewage thyssen group by drainzone 
	execute '
	update cso_inp_system_subc s set demand = a.consumo from (
	select drainzone_id, sum(consumption) as consumo from cso_subc_dwf cntr
	where drainzone_id is not null
	group by drainzone_id)a 
	where s.drainzone_id = a.drainzone_id and s.drainzone_id in ('||v_selected_drainzone_id||')
	';

	-- calc of equivalent inhabitants
	execute '
	update cso_inp_system_subc t set eq_inhab = demand * 3600 * 24 / '||v_daily_supply||'
	where t.drainzone_id in ('||v_selected_drainzone_id||')
	';

	-- set constant value of RD 665/2023
	EXECUTE 'update cso_inp_system_subc set kb = 1.13 WHERE drainzone_id in ('||v_selected_drainzone_id||')';

	-- vret_imperv
	EXECUTE 'update cso_inp_system_subc set vret_imperv = vret/imperv_area where drainzone_id in ('||v_selected_drainzone_id||')';

	
	-- set active drainzones
	EXECUTE 'update cso_inp_system_subc set active = true AND drainzone_id in ('||v_selected_drainzone_id||')';
	
	-- set null to 0
	EXECUTE 'update cso_inp_system_subc set q_max = 0 where q_max is NULL AND drainzone_id in ('||v_selected_drainzone_id||')';
	EXECUTE 'update cso_inp_system_subc set vret = 0 where vret is NULL AND drainzone_id in ('||v_selected_drainzone_id||')';
	EXECUTE 'update cso_inp_system_subc set eq_inhab = 0 where eq_inhab is NULL AND drainzone_id in ('||v_selected_drainzone_id||')';



	-- INITIAL DATA: RAINFALL (from active timeseries from inp_timeseries_value)
	-- =========================================================================
	
	DROP TABLE IF EXISTS cso_inp_rainfall;

	create temp table cso_inp_rainfall as
		select timser_id as rf_name, 60*v_tstep as rf_length, value as rf_volume, (value*6)::numeric as rf_intensity, "time" as rf_tstep
		from v_edit_inp_timeseries_value a 
		WHERE timser_type = 'Rainfall'
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

	v_timeseries_list = coalesce(v_timeseries_list, '');
	v_selected_drainzone_id = coalesce(v_selected_drainzone_id, '');

	-- reset values
	EXECUTE 'DELETE FROM cso_out_vol where drainzone_id in ('||v_selected_drainzone_id||') 
	AND rf_name in (select distinct id from v_edit_inp_timeseries)';

	RAISE NOTICE 'Drainzones_id: %', v_selected_drainzone_id;

	-- Insert ALL values of the selected drainzone + its rainfall
	EXECUTE '
	INSERT INTO cso_out_vol (drainzone_id, node_id, rf_name, rf_tstep, rf_volume, rf_intensity)
	SELECT a.drainzone_id, (a.graphconfig::json ->''use''->0 ->>''nodeParent'')::text as node_id, 
	b.timser_id AS rf_name, b."time" AS rf_tstep, b.value as rf_volume, (b.value*6)::numeric as rf_intensity
	FROM drainzone a, inp_timeseries_value b
	JOIN inp_timeseries c ON b.timser_id = c.id
	WHERE c.timser_type = ''Rainfall'' AND a.drainzone_id in ('||v_selected_drainzone_id||')
	AND c.expl_id = '||v_expl_id||'
	ORDER BY 1, 3, 4 
	ON CONFLICT (drainzone_id, rf_name, rf_tstep) DO NOTHING;
	';
	
	-- delete EDAR from cso calculation
	DELETE FROM cso_out_vol WHERE node_id IN (
	SELECT DISTINCT a.node_id FROM ud.cso_out_vol a JOIN ud.node b USING (node_id) 
	WHERE b.node_type = 'EDAR'
	);


	-- Update these records that have rf_volume = 0!
	v_sql =  '
	UPDATE cso_out_vol t SET 
	vol_residual = a.vol_residual, 
	vol_max_epi = a.vol_max_epi, 
	vol_res_epi = a.vol_res_epi, 
	vol_rainfall = 0,
	vol_total = a.vol_total,
	vol_runoff = 0,
	vol_infiltr = 0,
	vol_circ = a.vol_circ,
	vol_circ_dep = a.vol_circ_dep,
	vol_circ_red = 0,
	vol_non_leaked = 0,
	vol_leaked = 0,
	vol_wwtp = a.vol_wwtp,
	vol_treated = a.vol_treated,
	efficiency = 1,
	rf_intensity = 0
	FROM (
			SELECT 
			drainzone_id, 
			node_id,
			rf_name,
			rf_tstep,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_residual,
			q_max * rf_length / 1000 AS vol_max_epi,
			(COALESCE(demand, 0) * rf_length) / 1000 AS vol_res_epi,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_total,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_circ,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_circ_dep,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_wwtp,
			COALESCE(demand, 0) * '||v_returncoeff||' * rf_length / 1000 AS vol_treated
			FROM cso_inp_system_subc, cso_inp_rainfall
			WHERE rf_volume = 0 AND drainzone_id in ('||v_selected_drainzone_id||')
	)a WHERE t.drainzone_id = a.drainzone_id AND t.rf_name = a.rf_name AND t.rf_volume = 0
	';

	EXECUTE v_sql;

	-- for each rainfall that have volume:
	FOR rec_rainfall in EXECUTE 'select * from cso_inp_rainfall WHERE rf_volume>0'
	LOOP	
		--raise notice '     Rainfall name: %', rec_rainfall.rf_name;
		
		-- for each subcatchment
		FOR rec_subc in execute 'select * from cso_inp_system_subc where drainzone_id in ('||v_selected_drainzone_id||') and thyssen_plv_area is not null'
		LOOP
			-- fill table cso_out_vol
			update cso_out_vol
				set 
				vol_residual = rec_subc.demand * v_returncoeff *  rec_rainfall.rf_length / 1000,
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

	IF v_inflows_dscenario IS NOT NULL THEN -- CREATE inflow dscenario
	
		-- insert values in inp_timeseries_(value)
		execute
		'
		INSERT INTO inp_timeseries (id, timser_type, times_type, idval, expl_id)
		WITH mec AS (
			SELECT node_id, concat(rf_name, ''_'', node_id) AS lluvia
			FROM cso_out_vol where drainzone_id in ('||v_selected_drainzone_id||')
		)
		SELECT DISTINCT lluvia, ''Inflow_Hydrograph'' AS timser_type, ''RELATIVE'' AS times_type, ''np'' AS idval, '||v_expl_id||' AS expl_id 
		FROM mec ON CONFLICT (id) DO NOTHING
		';
		
		-- insert values of inflows into inp_timeseries_values (vol_non_leaked is in m3/10 min and we pass it to m3/s)
		EXECUTE '
		INSERT INTO inp_timeseries_value (timser_id, time, value)
		SELECT concat(rf_name, ''_'', node_id) AS lluvia, rf_tstep, (vol_non_leaked/(60*'||v_tstep||'))
		FROM cso_out_vol WHERE drainzone_id in ('||v_selected_drainzone_id||')
		order by concat(rf_name, ''_'', node_id), to_timestamp(rf_tstep, ''HH24:MI'')
		';
	
		DELETE FROM inp_timeseries_value WHERE value IS NULL;
	
		-- delete duplicated values in timeseries_value
	   	DELETE FROM inp_timeseries_value WHERE id IN (
		   	WITH mec AS (
			   	SELECT id, timser_id, date, HOUR, time, value, 
			  	row_number() over(PARTITION BY timser_id, date, HOUR, time,value ORDER BY timser_id, date, HOUR, time,value) AS rw 
			  	FROM inp_timeseries_value
		  	)
		  	SELECT id FROM mec WHERE rw > 1
	  	);
	
	  	-- create an inflows dscenario if the name doesn't exists
		IF v_inflows_dscenario NOT IN (SELECT name FROM cat_dscenario) THEN 
	
			EXECUTE '
			INSERT INTO cat_dscenario ("name", dscenario_type, expl_id) 
			VALUES('||QUOTE_LITERAL(v_inflows_dscenario)||', ''INFLOWS'', '||v_expl_id||'::integer)
			ON CONFLICT (dscenario_id) do nothing
			';

		END IF;
	
		SELECT dscenario_id INTO v_dscenario_id FROM cat_dscenario WHERE "name" = v_inflows_dscenario;
			
		EXECUTE '
		INSERT INTO inp_dscenario_inflows (dscenario_id, node_id, order_id, timser_id, sfactor, base)
		SELECT '||v_dscenario_id||', node_id, node_id::INTEGER, concat(rf_name, ''_'', node_id) AS lluvia, 1, 1
		FROM cso_out_vol WHERE drainzone_id IN ('||v_selected_drainzone_id||')
		ORDER BY RIGHT(rf_name, 2) LIMIT 1
		ON CONFLICT (dscenario_id, node_id, order_id) DO NOTHING
		';
	
	END IF;

	-- clean temp tables

	drop table if exists cso_inp_rainfall;

	SELECT count(*) INTO v_count FROM ud.v_edit_inp_timeseries_value a 
	LEFT JOIN ud.cso_inp_system_subc b ON split_part(a.timser_id, '_', 3) = b.node_id
	WHERE a.timser_type = 'Inflow_Hydrograph'
	AND (a.value*1000)/(60*v_tstep) > q_max;

	
	return '{"status": "Accepted", 
	"message":{"level":1, "text":"done succesfully"}, 
	"data":{"drainzoneId": "'||v_selected_drainzone_id||'", "timeseries":"'||v_timeseries_list||'", "volNonLeakedOverQmax":"'||v_count||'"}}';

END;
$function$
;
