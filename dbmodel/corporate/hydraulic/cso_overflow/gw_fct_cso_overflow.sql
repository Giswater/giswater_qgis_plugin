/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

CREATE OR REPLACE FUNCTION gw_fct_cso_calculation(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*

--modo calculo
SELECT gw_fct_cso_calculation($${"client":{"device":4, "lang":"es_ES", "epsg":25830}, "form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mode":"EXECUTION", "inflowsDscenarioName": "inf_gaikao", "exploitation":"14", "drainzoneId":null}}}$$);

SELECT gw_fct_cso_calculation(concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{},"parameters":{"mode":"EXECUTION", "inflowsDscenarioName": "inf_gaikao", "exploitation":"14", "drainzoneId":', drainzone_id, '}}}')::json);

--modo calibración
SELECT gw_fct_cso_calculation($${"client":{"device":4, "lang":"es_ES", "epsg":25830}, "form":{}, "feature":{}, 
"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"mode":"CALIBRATION", "inflowsDscenarioName": "inf_gaikao", "exploitation":"14", "drainzoneId":null}}}$$);



SELECT gw_fct_cso_calculation(concat('{"client":{"device":4, "infoType":1, "lang":"ES"}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{},"parameters":{"exploitation":"14", "drainzoneId":', d.drainzone_id, '}}}')::json)
FROM drainzone d
LEFT JOIN node n ON REPLACE((d.graphconfig->'use'->0->'nodeParent')::TEXT, '"', '') = n.node_id
LEFT JOIN exploitation e ON n.expl_id = e.expl_id
WHERE e.macroexpl_id = 6
AND d.link IS NOT NULL;



*/

DECLARE
-- input params
v_returncoeff NUMERIC;
v_daily_supply NUMERIC;
v_expl_id INTEGER;
v_drainzone_id text;
v_tstep NUMERIC;

-- 
v_drainzone_array text;
v_filter_drainzone TEXT;
v_timeseries_list TEXT;
v_inflows_dscenario TEXT;
v_dscenario_id INTEGER;
-- 
rec_rainfall record;
rec_subc record;
v_count INTEGER;
v_sql text;
-- calc
v_non_leaked_vol NUMERIC;
v_leaked_vol NUMERIC;
v_cur_vol NUMERIC;
v_last_vol NUMERIC;
v_delta_vol NUMERIC;
v_vol_circ NUMERIC;
v_vol_max_epi NUMERIC;

-- return
v_version TEXT;
v_result JSON;
v_result_info JSON;
v_result_polygon JSON;

v_calib_imperv_area NUMERIC = 0;
v_mode TEXT;
v_filtercal TEXT;


BEGIN
	
	SET search_path = "SCHEMA_NAME", public;

	-- input params
	v_tstep = 10; -- tstep of the timeseries (every 10 mins, 5 mins., etc.)
	v_expl_id := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_drainzone_id := (((p_data ->>'data')::json->>'parameters')::json->>'drainzoneId')::text;
	v_inflows_dscenario := (((p_data ->>'data')::json->>'parameters')::json->>'inflowsDscenarioName')::text;
	v_mode:= (((p_data ->>'data')::json->>'parameters')::json->>'mode')::text;

	-- config variables
	v_returncoeff = (select value::numeric from config_param_system where "parameter" = 'cso_returncoeff');
	v_daily_supply = (select value::numeric from config_param_system where "parameter" = 'cso_daily_supply');
	SELECT giswater INTO v_version FROM sys_version ORDER BY id ASC LIMIT 1;
	
	-- filter drainzones
	IF v_drainzone_id IS NOT NULL OR v_drainzone_id !='' THEN
		v_filter_drainzone = 'AND d.drainzone_id IN ('||v_drainzone_id||')';
	ELSE
		v_filter_drainzone = '';
		
	END IF;

	-- get the drainzones of execution according to selected options
	v_sql = '
	SELECT d.drainzone_id
	FROM drainzone d WHERE expl_id = '||v_expl_id||' '||v_filter_drainzone||' AND d.active IS TRUE and d.link is not null';

	EXECUTE 'SELECT count(*) from ('||v_sql||')a' INTO v_count;


	IF v_count = 0 THEN
		return '{"status": "Failed", "message":{"level":1, "text":"No drainzones match with selected expl and/or drainzone"}}'::json;
	ELSE
		v_sql = 'SELECT string_agg(drainzone_id::text, '', '') FROM ('||v_sql||')a' ;
		EXECUTE v_sql INTO v_drainzone_array;	
	END IF;

	-- reset all
	execute 'delete from cso_inp_system_subc where drainzone_id in ('||v_drainzone_array||')';
	execute 'delete from cso_out_vol where drainzone_id in ('||v_drainzone_array||')';


	RAISE NOTICE 'Drainzones array: %', v_drainzone_array;

	-- PREPARE DATA: water consumption from connecs grouped by dwf thyssen triangles 
	-- ===================================================
	FOR rec IN EXECUTE 'SELECT drainzone_id FROM drainzone WHERE drainzone_id in ('||v_drainzone_array||')'
	LOOP -- INTERSECT w/ connecs FOR EACH selected drainzone TO gain performance

		EXECUTE 'UPDATE cso_subc_dwf_all t SET consumption = a.su FROM (
			SELECT c.id, sum(consumo) AS su FROM ws.man_connec_acometida a
			LEFT JOIN ws.connec b USING (connec_id)
			LEFT JOIN cso_subc_dwf_all c ON st_intersects(c.the_geom, b.the_geom)
			WHERE consumo IS NOT NULL AND drainzone_id = '||rec.drainzone_id||'
			GROUP BY id
		)a WHERE t.id = a.id';
	
	END LOOP;

	-- PREPARE DATA: update drainzone_id for each dwf triangle taking the drainzone of the triangle's source node_id
	-- ===================================================

	EXECUTE '
	UPDATE cso_subc_dwf_all t SET drainzone_id = a.drainzone_id FROM (
		SELECT a.id, b.drainzone_id
		FROM cso_subc_dwf_all a
		LEFT JOIN node b USING (node_id)
		WHERE (a.drainzone_id > 0 OR b.drainzone_id >0) 
		AND a.drainzone_id<>b.drainzone_id AND b.drainzone_id > 0 
		AND b.drainzone_id in ('||v_drainzone_array||')
	)a WHERE t.id = a.id;
	';

	EXECUTE '
	UPDATE cso_subc_wwf_all t SET drainzone_id = a.drainzone_id FROM (
	SELECT a.id, b.drainzone_id
		FROM cso_subc_wwf_all a
		LEFT JOIN node b USING (node_id)
		WHERE (a.drainzone_id > 0 OR b.drainzone_id >0) 
		AND a.drainzone_id<>b.drainzone_id AND b.drainzone_id > 0 
		AND b.drainzone_id in ('||v_drainzone_array||')
	)a where t.id = a.id';

	
	-- INITIAL DATA: ud NETWORK DATA (cso_inp_system_subc)
	-- ===================================================

	-- ud data: drainzones, outfalls and its specific features (vret, etc.)
	EXECUTE '
	insert into cso_inp_system_subc (node_id)
	select (graphconfig::json ->''use''->0 ->>''nodeParent'')::text
	from drainzone where link is not null and drainzone_id IN ('||v_drainzone_array||')
	on conflict (node_id) do nothing';

	EXECUTE '
	update cso_inp_system_subc t set drainzone_id = a.drainzone_id, q_max = a.qmax, vret = a.vret, 
	muni_name = a.muni_name, expl_name = a.expl_name, macroexpl_name = a.macroexpl_name from (
		select 
		(a.graphconfig::json ->''use''->0 ->>''nodeParent'')::text as node_id,
		a.drainzone_id,
		(a.link::json ->>''qmax'')::numeric as qmax,
		(a.link::json ->>''vret'')::numeric as vret,
		concat(m.muni_id, '' - '', m.name) AS muni_name,
		concat(e.expl_id, '' - '', e.name) AS expl_name,
		concat(me.macroexpl_id, '' - '', me.name) AS macroexpl_name
		from drainzone a
		LEFT JOIN node b ON (a.graphconfig::json ->''use''->0 ->>''nodeParent'')::TEXT = b.node_id
		LEFT JOIN ext_municipality m USING (muni_id)
		LEFT JOIN exploitation e ON e.expl_id = b.expl_id
		LEFT JOIN macroexploitation me USING (macroexpl_id)
		where a.link is not null and a.drainzone_id IN ('||v_drainzone_array||')
	)a where t.node_id = a.node_id 
	';

	-- imperv area 
	execute '
	update cso_inp_system_subc t set imperv_area = a.imperv from (
		select drainzone_id, sum(st_area(the_geom) * cn_value/100) as imperv from cso_subc_wwf_all group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id and t.drainzone_id in ('||v_drainzone_array||');
	';

	-- area of rainwater thyssen group by drainzone
	execute '
	update cso_inp_system_subc t set thyssen_plv_area = a.area_thy from (
	select drainzone_id, sum(st_area(the_geom)) as area_thy 
	from cso_subc_wwf_all group by drainzone_id
	)a where t.drainzone_id = a.drainzone_id and t.drainzone_id in ('||v_drainzone_array||')
	';
	
	-- mean_runoff_coef
	execute '
	update cso_inp_system_subc t set mean_coef_runoff = a.c_value from (
	select drainzone_id, avg(ci_value) as c_value from cso_subc_wwf_all group by drainzone_id
	)a where a.drainzone_id = t.drainzone_id and t.drainzone_id in ('||v_drainzone_array||')
	';


	-- sum of demand (L/s) from sewage thyssen group by drainzone 
	execute '
	update cso_inp_system_subc s set demand = a.consumo from (
	select drainzone_id, sum(consumption) as consumo from cso_subc_dwf_all cntr
	where drainzone_id is not null
	group by drainzone_id)a 
	where s.drainzone_id = a.drainzone_id and s.drainzone_id in ('||v_drainzone_array||')
	';

	-- calc of equivalent inhabitants
	execute '
	update cso_inp_system_subc t set eq_inhab = demand * 3600 * 24 / '||v_daily_supply||'
	where t.drainzone_id in ('||v_drainzone_array||')
	';

	-- set constant value of RD 665/2023
	EXECUTE 'update cso_inp_system_subc set kb = 1.13 WHERE drainzone_id in ('||v_drainzone_array||')';

	-- vret_imperv
	EXECUTE 'update cso_inp_system_subc set vret_imperv = vret/imperv_area where drainzone_id in ('||v_drainzone_array||')';

	-- set active drainzones
	EXECUTE 'update cso_inp_system_subc set active = true AND drainzone_id in ('||v_drainzone_array||')';
	
	-- set null to 0
	EXECUTE 'update cso_inp_system_subc set q_max = 0 where q_max is NULL AND drainzone_id in ('||v_drainzone_array||')';
	EXECUTE 'update cso_inp_system_subc set vret = 0 where vret is NULL AND drainzone_id in ('||v_drainzone_array||')';
	EXECUTE 'update cso_inp_system_subc set eq_inhab = 0 where eq_inhab is NULL AND drainzone_id in ('||v_drainzone_array||')';



	-- INITIAL DATA: RAINFALL (from active timeseries from inp_timeseries_value)
	-- =========================================================================
	DROP TABLE IF EXISTS cso_inp_rainfall;

	IF v_mode ='EXECUTION' THEN
	
		CREATE TEMP table cso_inp_rainfall as
		select timser_id as rf_name, 60*v_tstep as rf_length, value as rf_volume, (value*6)::numeric as rf_intensity, "time" as rf_tstep
		from inp_timeseries_value a 
		JOIN inp_timeseries b ON a.timser_id = b.id
		WHERE timser_type = 'Rainfall' AND active AND addparam IS NULL AND expl_id = v_expl_id ORDER BY 1, 5;
	
		v_filtercal = ' AND c.addparam is null ';
	
	ELSIF v_mode = 'CALIBRATION' THEN
	
		create TEMP table cso_inp_rainfall as
		select timser_id as rf_name, 60*v_tstep as rf_length, value as rf_volume, (value*6)::numeric as rf_intensity, "time" as rf_tstep
		from inp_timeseries_value a 
		JOIN inp_timeseries b ON a.timser_id = b.id
		WHERE timser_type = 'Rainfall' AND active AND addparam->>'mode'='CALIBRATION' AND expl_id = v_expl_id ORDER BY 1, 5;
	
		v_filtercal = ' AND c.addparam->>''mode''=''CALIBRATION''';
	
	ELSE
		return '{"status": "Failed", "message":{"level":1, "text":"It is mandatory to select a MODE"}}'::json;

	END IF;
	
	
	IF (SELECT EXISTS(SELECT 1 FROM cso_inp_rainfall)) IS FALSE THEN
		return '{"status": "Failed", "message":{"level":1, "text":"La expl seleccioanda no tiene lluvias en la inp_timeseries"}}'::json;
	END IF;
	

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
	v_drainzone_array = coalesce(v_drainzone_array, '');

	-- reset values
	EXECUTE 'DELETE FROM cso_out_vol where drainzone_id in ('||v_drainzone_array||')';

	-- Insert ALL values of the selected drainzone + its rainfall
	v_sql = '
	INSERT INTO cso_out_vol (drainzone_id, node_id, rf_name, rf_tstep, rf_volume, rf_intensity)
	SELECT a.drainzone_id, (a.graphconfig::json ->''use''->0 ->>''nodeParent'')::text as node_id, 
	b.timser_id AS rf_name, b."time" AS rf_tstep, b.value as rf_volume, (b.value*6)::numeric as rf_intensity
	FROM drainzone a 
	JOIN inp_timeseries c USING (expl_id)
	JOIN inp_timeseries_value b ON b.timser_id = c.id
	WHERE c.timser_type = ''Rainfall'' AND a.drainzone_id in ('||v_drainzone_array||') '||v_filtercal||' ORDER BY 1, 3, 4 
	ON CONFLICT (drainzone_id, rf_name, rf_tstep) DO NOTHING;
	';

	--RAISE EXCEPTION '% ', v_sql;
	EXECUTE v_sql;
	
	-- delete EDAR from cso calculation
	DELETE FROM cso_out_vol WHERE node_id IN (
	SELECT DISTINCT a.node_id FROM cso_out_vol a JOIN node b USING (node_id) 
	WHERE b.node_type = 'EDAR'
	);

	-- for each subcatchment
	FOR rec_subc in execute 'select * from cso_inp_system_subc where drainzone_id in ('||v_drainzone_array||') 
	and thyssen_plv_area is not null'
	LOOP
			
		v_last_vol = 0;
		v_cur_vol = 0;
		v_calib_imperv_area = (SELECT calib_imperv_area FROM cso_calibration WHERE drainzone_id = rec_subc.drainzone_id);
		
		RAISE NOTICE 'rec_subc.kb % rec_subc.thyssen_plv_area %', rec_subc.kb ,  rec_subc.thyssen_plv_area;
		
		-- for each rainfall that have volume:
		FOR rec_rainfall in EXECUTE 'select * from cso_inp_rainfall order by rf_name, rf_tstep'
		LOOP	
					
			RAISE NOTICE 'rainfall %', rec_rainfall;
			
			-- fill table cso_out_vol
			update cso_out_vol
				set 
				vol_residual = round((coalesce(rec_subc.demand,0) * v_returncoeff *  rec_rainfall.rf_length / 1000)::NUMERIC,3),
				vol_max_epi = round((rec_subc.q_max * rec_rainfall.rf_length / 1000)::NUMERIC,3),
				vol_res_epi = round(((coalesce(rec_subc.demand,0) * rec_rainfall.rf_length) / 1000)::NUMERIC,3), 
				vol_rainfall = round((1000 * rec_subc.kb * rec_rainfall.rf_volume * rec_subc.thyssen_plv_area/(1000*1000))::NUMERIC,3)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			
			IF v_calib_imperv_area > 0 THEN				
				update cso_out_vol
				set vol_total = round((vol_residual + vol_rainfall)::NUMERIC, 3),
				vol_runoff = round((vol_rainfall * v_calib_imperv_area / rec_subc.thyssen_plv_area)::NUMERIC, 3)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;
			ELSE 
				update cso_out_vol
				set vol_total = round((vol_residual + vol_rainfall)::NUMERIC, 3),
				vol_runoff = round((vol_rainfall * rec_subc.imperv_area / rec_subc.thyssen_plv_area)::NUMERIC, 3)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;		
			END IF;
					
			update cso_out_vol
				set vol_infiltr = round((vol_rainfall - vol_runoff )::NUMERIC, 3),
				vol_circ = round((vol_runoff + vol_residual)::NUMERIC, 3)
				where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep; 
											
			-- take into account accumulated volume in dep							
			SELECT vol_circ, vol_max_epi, (vol_circ - vol_max_epi) 
			INTO v_vol_circ, v_vol_max_epi, v_delta_vol
			FROM cso_out_vol where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep; 
		
			RAISE NOTICE 'circ: %, maxQ: %, maxV: %, delta: % ', v_vol_circ, v_vol_max_epi, rec_subc.vret, v_delta_vol;
		
			v_cur_vol = GREATEST(v_delta_vol + v_last_vol, 0);		
		
			IF v_cur_vol < rec_subc.vret THEN
			
				IF v_last_vol = 0 THEN
					v_non_leaked_vol = v_vol_circ;
				ELSE 
					
					v_non_leaked_vol = least((v_last_vol + v_vol_circ),v_vol_max_epi);
				END IF;
			
				IF v_vol_circ > v_vol_max_epi THEN
					v_non_leaked_vol = v_vol_max_epi;
				END IF;
				v_leaked_vol = 0;
			
			elsif v_cur_vol > rec_subc.vret THEN
				v_leaked_vol = v_cur_vol - rec_subc.vret;
				v_non_leaked_vol = v_vol_max_epi;
				v_cur_vol = rec_subc.vret;
				
			end if;	
						
			update cso_out_vol set 
				vol_circ_red = round((v_vol_circ -(v_cur_vol-v_last_vol))::numeric,3),
				vol_circ_dep = round(v_cur_vol::numeric,3),
				vol_non_leaked = round(v_non_leaked_vol::numeric,3),
				vol_leaked = round(v_leaked_vol::numeric,3),
				vol_wwtp = round(v_non_leaked_vol::NUMERIC,3),
				vol_treated = round((vol_infiltr + v_non_leaked_vol)::NUMERIC, 3),
				efficiency = CASE WHEN vol_total > 0 THEN round(((vol_infiltr + v_non_leaked_vol)/vol_total)::NUMERIC, 3) ELSE 1 END
			where node_id = rec_subc.node_id and rf_name = rec_rainfall.rf_name and rf_tstep=rec_rainfall.rf_tstep;	
							
			RAISE NOTICE 'curVol: %, lastVol: %, leak: %, nonLeak: %',  v_cur_vol, v_last_vol, v_leaked_vol, v_non_leaked_vol;
		
			v_last_vol = v_cur_vol;
		END LOOP;
	
		v_calib_imperv_area = 0;
	
	END LOOP;

	IF v_inflows_dscenario IS NOT NULL THEN -- CREATE inflow dscenario
	
		-- delete previous 
		DELETE FROM inp_dscenario_inflows WHERE timser_id IN (SELECT id FROM inp_timeseries WHERE log = 'Created by CSO ALGORTHIM' AND expl_id = v_expl_id);
		DELETE FROM inp_timeseries WHERE log = 'Created by CSO ALGORTHIM' AND expl_id = v_expl_id;
		
		-- insert values in inp_timeseries_(value)
		execute
		'
		INSERT INTO inp_timeseries (id, timser_type, times_type, idval, expl_id, log)
		WITH mec AS (
			SELECT node_id, concat(rf_name, ''_'', node_id) AS lluvia
			FROM cso_out_vol where drainzone_id in ('||v_drainzone_array||')
		)
		SELECT DISTINCT lluvia, ''Inflow_Hydrograph'' AS timser_type, ''RELATIVE'' AS times_type, lluvia AS idval, '||v_expl_id||', ''Created by CSO ALGORTHIM''
		FROM mec ON CONFLICT (id) DO NOTHING
		';
		
		-- insert values of inflows into inp_timeseries_values (vol_non_leaked is in m3/10 min and we pass it to m3/s)
		EXECUTE '
		INSERT INTO inp_timeseries_value (timser_id, time, value)
		SELECT concat(rf_name, ''_'', node_id) AS lluvia, rf_tstep, (vol_non_leaked/(60*'||v_tstep||'))
		FROM cso_out_vol WHERE drainzone_id in ('||v_drainzone_array||')
		order by concat(rf_name, ''_'', node_id), to_timestamp(rf_tstep, ''HH24:MI'')
		';
	
		UPDATE inp_timeseries_value SET value=0 WHERE value IS null;
	
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
		INSERT INTO inp_dscenario_inflows (dscenario_id, node_id, order_id, timser_id, sfactor, base, active)
		SELECT '||v_dscenario_id||', node_id, RIGHT(rf_name, 2)::INTEGER, concat(rf_name, ''_'', node_id) AS lluvia, 1, 0, false
		FROM cso_out_vol WHERE drainzone_id IN ('||v_drainzone_array||') 
		ORDER BY RIGHT(rf_name, 2)
		ON CONFLICT (dscenario_id, node_id, order_id) DO NOTHING
		';	
	END IF;

	EXECUTE 'UPDATE cso_out_vol SET lastupdate = now() WHERE drainzone_id IN ('||v_drainzone_array||')';

	
	DELETE FROM audit_check_data WHERE fid = 990 AND cur_user = current_user;

	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 1, '------------------------', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 1, ' CSO CALCULATION   ', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 1, '------------------------', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 1, '', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 1, '', current_user;


	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 2, 'CALCULATED DRAINZONES ', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 2, '--------------------------------', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 2, drainzone_id, current_user FROM cso_out_vol WHERE lastupdate=now();
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 2, '', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 2, '', current_user;

	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 3, 'RAINFALLS USED', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 3, '-----------------------', current_user;
	INSERT INTO audit_check_data (fid, criticity, error_message, cur_user) SELECT DISTINCT 990, 3, rf_name, current_user FROM cso_inp_rainfall ORDER BY rf_name;


	drop table if exists cso_inp_rainfall;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT error_message AS message FROM audit_check_data WHERE fid = 990 AND cur_user = current_user ORDER BY criticity asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

  	--polygon;
	  	SELECT jsonb_agg(features.feature) INTO v_result
	  	FROM (
		    SELECT jsonb_build_object(
		    'type',       'Feature',
		    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		    'properties', to_jsonb(row) - 'the_geom'
		    ) AS feature
		    FROM (SELECT drainzone_id AS id, drainzone_name, NULL AS descript, expl_id, efficiency, the_geom FROM v_cso_drainzone) 
	   	row) features;
	
	  v_result := COALESCE(v_result, '{}'); 
	  v_result_polygon = concat ('{"geometryType":"Polygon", "features":',v_result, '}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
    ',"body":{"form":{}, "data":{"info":'||v_result_info||',"polygon":'||v_result_polygon||'}}}')::json, 9997, null, null, null);


END;
$function$
;
