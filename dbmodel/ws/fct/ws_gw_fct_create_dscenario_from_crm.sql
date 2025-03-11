/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3110

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_crm(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_crm($${"client":{"device":4, "lang":"ca_ES", "infoType":1, "epsg":SRID_VALUE}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"name":"212", "descript":"te", "exploitation":"1", "period":"5", "onlyIsWaterBal":"true", "pattern":"3", "demandUnits":"LPS"}, "aux_params":null}}$$);

*/


DECLARE

object_rec record;

v_version text;
v_result json;
v_result_info json;
v_name text;
v_descript text;
v_period text;
v_crm_name text;
v_error_context text;
v_count integer;
v_total_vol integer;
v_total_hydro integer;
v_count2 integer;
v_projecttype text;
v_fid integer = 403;
v_source_name text;
v_target_name text;
v_action text;
v_querytext text;
v_result_id text = 'empty';
v_scenarioid integer;
v_pattern integer;
v_periodunits text;
v_demandunits text;
v_periodseconds integer;
v_factor float;
v_expl TEXT;
v_onlyiswaterbal boolean;
v_waterbal TEXT;
v_initdate TEXT;
v_enddate TEXT;
v_tmethod INTEGER;
v_tmethod_query TEXT;
v_query_catdscenario TEXT;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_period :=  ((p_data ->>'data')::json->>'parameters')::json->>'period';
	v_pattern :=  ((p_data ->>'data')::json->>'parameters')::json->>'pattern';
	v_demandunits :=  ((p_data ->>'data')::json->>'parameters')::json->>'demandUnits';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_onlyiswaterbal :=  ((p_data ->>'data')::json->>'parameters')::json->>'onlyIsWaterBal';
	v_tmethod :=  ((p_data ->>'data')::json->>'parameters')::json->>'patternOrDate';
	v_initdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'initDate';
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'endDate';

	IF v_onlyiswaterbal is true then 
		v_waterbal = 'TRUE';
	ELSE
		v_waterbal = 'TRUE, FALSE, NULL';
	END IF;
	
	-- getting system values
	v_crm_name := (SELECT code FROM ext_cat_period WHERE id  = v_period);
	v_periodseconds := (SELECT period_seconds FROM ext_cat_period WHERE id  = v_period);

	IF v_periodseconds IS NULL THEN
		SELECT value::integer INTO v_periodseconds FROM config_param_system WHERE parameter = 'admin_crm_periodseconds_vdefault';
	END IF;
	
	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;	

	-- create log
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('CREATE DSCENARIO FROM CRM'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '--------------------------------------------------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- inserting on catalog table
	PERFORM setval('SCHEMA_NAME.cat_dscenario_dscenario_id_seq'::regclass,(SELECT max(dscenario_id) FROM cat_dscenario) ,true);

	INSERT INTO cat_dscenario (name, descript, dscenario_type, expl_id, log)
	SELECT v_name, v_descript, 'DEMAND',
	CASE WHEN v_expl='ALL' THEN NULL ELSE v_expl::integer END,
	concat('Insert by ',current_user,' on ', substring(now()::text,0,20),'. Input params:{"Target feature":"", "Exploitation":"'||v_expl||'", "Source CRM Period":"',v_crm_name,'", "Source Pattern":"',v_pattern,'", "Demand Units":"',v_demandunits,'"}')
	ON CONFLICT (name) DO NOTHING RETURNING dscenario_id INTO v_scenarioid;


	IF v_tmethod = 1 THEN --use period_id

		v_tmethod_query = 'rhd.cat_period_id = '||quote_literal(v_period)|| '';

	ELSIF v_tmethod = 2 THEN -- use date INTERVAL

		v_tmethod_query = 'value_date BETWEEN '||quote_literal(v_initdate)||'::date AND '||quote_literal(v_enddate)||'::date ';

	END IF;


	IF v_expl = 'ALL' THEN

		EXECUTE 'SELECT string_agg(expl_id::text, '', '') from exploitation WHERE active IS TRUE AND expl_id>0 ' INTO v_expl;

	END IF;


	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, null, 3, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
		
	ELSE

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('New scenario: ',v_name, ' ( ',v_scenarioid,' )'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Copy from CRM period: ',v_crm_name));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Source pattern: ',v_pattern));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Demand units: ',v_demandunits));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Period seconds: ',v_periodseconds));
	
		IF (SELECT period_seconds FROM ext_cat_period WHERE id  = v_period) IS NULL THEN
			SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, null, 2, concat('WARNING: The period has not data on period_seconds columns. The system default value have been used ( ',v_periodseconds,' ) '));
		END IF;

		-- this factor is calculated assuming period value is on M3
		v_factor = 1000*(SELECT value::json->>v_demandunits FROM config_param_system WHERE parameter = 'epa_units_factor')::float/v_periodseconds::float;		

		-- create base query
		v_querytext = '
		SELECT rhd.hydrometer_id, vuh.feature_id, sum(rhd."sum"), erh.is_waterbal, rhd.pattern_id, rhd.custom_sum,
		CASE WHEN vuh.feature_id IN (SELECT node_id FROM node) THEN ''NODE'' ELSE ''CONNEC'' END AS feature_type
		FROM ext_rtc_hydrometer_x_data rhd
		LEFT JOIN v_ui_hydrometer vuh USING (hydrometer_id)
		LEFT JOIN exploitation e ON vuh.expl_name = e.name
		LEFT JOIN ext_rtc_hydrometer erh ON rhd.hydrometer_id=erh.id
		WHERE e.expl_id in ('||v_expl||')
		AND '||v_tmethod_query||'
		AND erh.is_waterbal IN ('||v_waterbal||')
		GROUP BY rhd.hydrometer_id, erh.is_waterbal, rhd.pattern_id, vuh.feature_id, rhd.custom_sum';


		-- count hydrometers and total vol grouped by feature_type
		EXECUTE 'SELECT COUNT(hydrometer_id) FROM ('||v_querytext||')' INTO v_total_hydro;

		EXECUTE 'SELECT sum("sum") FROM ('||v_querytext||')' INTO v_total_vol;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('There are ', v_total_hydro, ' hydrometers with data for this period and this exploitation.'));

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('The total volume (m3) for all the hydrometers is ', v_total_vol,'.'));


		-- insert connecs and nodes (netwjoins)
		EXECUTE 'INSERT INTO inp_dscenario_demand (feature_type, dscenario_id, feature_id, demand, source)
		WITH aux as ('||v_querytext||')
		SELECT  feature_type, '||v_scenarioid||', feature_id,
		(case when custom_sum is null then '||v_factor||'*sum else '||v_factor||'*custom_sum end) as volume,
		hydrometer_id as source
		FROM aux order by 2';


		EXECUTE  '
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		WITH aux as ('||v_querytext||')
		SELECT '||v_fid||', '||quote_literal(v_result_id)||', 1,
		concat(count(hydrometer_id), '' rows (hydrometers) with demands on '', feature_type, '' have been inserted on inp_dscenario_demand.'')
		FROM aux GROUP BY feature_type';

		-- real volume inserted
		SELECT sum(demand)/v_factor INTO v_count2 FROM inp_dscenario_demand WHERE dscenario_id = v_scenarioid;

		--log
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('The volume water inserted is ',v_count2,', wich it means that lossed water percentatge due leak of data have been ',
		(100-100*v_count2::float/v_total_vol::float)::numeric(12,2),' %.'));

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('The water loss could be motivated by current connecs with state = 0 which they was operative for that period with some hydrometer linked'));


		-- update patterns  (1 -> none) -> SEGONS D'ON VOLS AGAFAR EL PATTERN (del sector, dma, periodes de dma, .etc), AQUEST S'UPDATEJARÀ A LA TAULA DEL DSCENARIO
		IF v_pattern = 2 THEN -- sector DEFAULT ->

			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id
			FROM sector s
			JOIN connec USING (sector_id)
			JOIN rtc_hydrometer_x_connec h USING (connec_id)
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 3 THEN -- dma default
			-- LO MATEIX PERÒ PER AL PATTERN DE LA DMA
			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id
			FROM dma s
			JOIN connec c ON c.dma_id = s.dma_id::integer
			JOIN rtc_hydrometer_x_connec h USING (connec_id)
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 4 THEN -- dma period

			EXECUTE '
			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id
			FROM ext_rtc_dma_period s
			JOIN connec c ON c.dma_id = s.dma_id::integer
			JOIN rtc_hydrometer_x_connec h USING (connec_id)
			WHERE d.source = h.hydrometer_id AND h.hydrometer_id IN (SELECT hydrometer_id FROM ('||v_querytext||')
			AND dscenario_id = '||v_scenarioid||'';

		ELSIF v_pattern = 5 THEN -- hydrometer period

			EXECUTE '
			UPDATE inp_dscenario_demand d SET pattern_id = h.pattern_id
			FROM ext_rtc_hydrometer_x_data h
			WHERE d.source = h.hydrometer_id AND h.hydrometer_id IN (SELECT hydrometer_id FROM ('||v_querytext||')
			AND dscenario_id = '||v_scenarioid||'';

		ELSIF v_pattern = 6 THEN -- hydrometer category

			UPDATE inp_dscenario_demand d SET pattern_id = c.pattern_id 
			FROM ext_rtc_hydrometer h
			JOIN ext_hydrometer_category c ON c.id::integer = h.category_id
			WHERE d.source = h.id::text
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 7 THEN -- feature pattern

			-- update wjoins (connec)
			UPDATE inp_dscenario_demand d SET pattern_id = i.pattern_id 
			FROM inp_connec i
			JOIN connec c USING (connec_id)
			JOIN rtc_hydrometer_x_connec h ON h.connec_id = c.connec_id
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;
			
			-- update netwjoins (node)
			UPDATE inp_dscenario_demand d SET pattern_id = i.pattern_id 
			FROM inp_junction i
			JOIN node n USING (node_id)
			JOIN rtc_hydrometer_x_node h ON h.node_id = n.node_id
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;


		END IF;

		IF v_pattern > 1 THEN

			GET DIAGNOSTICS v_count2 = row_count;	
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, v_result_id, 1, concat(v_count2, ' rows have been update with pattern value.'));
		
			IF v_count > v_count2 THEN

				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('WARNING-403: ',v_count-v_count2,' rows have not been updated. This may be for missed data from source pattern table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('SECTOR DEFAULT: sector table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('DMA DEFAULT: dma table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('DMA PERIOD: ext_rtc_dma_period table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('HYDROMETER PERIOD: ext_rtc_hydrometer_x_data table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('HYDROMETER CATEGORY: hydrometer_category table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('FEATURE PATTERN: inp_junction & inp_connec tables.'));
			END IF;
		END IF;
				
		-- set selector
		INSERT INTO selector_inp_dscenario (dscenario_id,cur_user) VALUES (v_scenarioid, current_user) ON CONFLICT (dscenario_id,cur_user) DO NOTHING;

		UPDATE inp_dscenario_demand SET source = concat('HYD ', source) WHERE dscenario_id = v_scenarioid;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat(''));
	END IF;
		
	-- insert spacers
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat(''));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, concat(''));

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 3042, null, null, null); 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;