/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3042

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_create_dscenario_from_crm(p_data json) 
RETURNS json AS 
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_create_dscenario_from_crm($${"client":{}, "form":{}, "feature":{}, "data":{"parameters":{"name":"test", "descript":null, "type":"DEMAND", "targetFeature": "NODE", "period":"5", "pattern":1, "flowUnits":"M3H"}}}$$);
-- fid: 403

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
v_result_id text = null;
v_scenarioid integer;
v_pattern integer;
v_periodunits text;
v_demandunits text;
v_periodseconds integer;
v_factor float;
v_expl integer;

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
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('New scenario: ',v_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Copy from CRM period: ',v_crm_name));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Source pattern: ',v_pattern));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Demand units: ',v_demandunits));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Period seconds: ',v_periodseconds));
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, 'ERRORS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, '--------');
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, 'WARNINGS');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 2, '---------');

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, 'INFO');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, '---------');

	-- inserting on catalog table
	INSERT INTO cat_dscenario (name, descript, dscenario_type, expl_id, log) VALUES (v_name, v_descript, 'DEMAND', v_expl, concat('Insert by ',current_user,' on ', substring(now()::text,0,20),'. Input params:{·Target feature":"", "Source CRM Period":"',v_crm_name,'", "Source Pattern":"',v_pattern,'", "Demand Units":"',v_demandunits,'"}')) ON CONFLICT (name) DO NOTHING RETURNING dscenario_id INTO v_scenarioid ;

	IF v_scenarioid IS NULL THEN
		SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, null, 3, concat('ERROR: The dscenario ( ',v_scenarioid,' ) already exists with proposed name ',v_name ,'. Please try another one.'));
		
	ELSE
		IF (SELECT period_seconds FROM ext_cat_period WHERE id  = v_period) IS NULL THEN
			SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, null, 2, concat('WARNING: The period has not data on period_seconds columns. The system default value have been used ( ',v_periodseconds,' ) '));
		END IF;

		-- this factor is calculated assuming period value is on M3
		v_factor = 1000*(SELECT value::json->>v_demandunits FROM config_param_system WHERE parameter = 'epa_units_factor')::float/v_periodseconds::float;		

		-- total number of hydrometers
		SELECT count(*) INTO v_total_hydro FROM ext_rtc_hydrometer_x_data JOIN v_rtc_hydrometer USING (hydrometer_id) WHERE  cat_period_id  = v_period AND expl_id = v_expl;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('There are ', v_total_hydro, ' hydrometers with data for this period and this exploitation.'));

		-- total volume of hydrometers
		SELECT sum(sum) INTO v_total_vol FROM ext_rtc_hydrometer_x_data JOIN v_rtc_hydrometer USING (hydrometer_id) WHERE  cat_period_id  = v_period AND expl_id = v_expl;
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('The total volume (m3) for all the hydrometers is ', v_total_vol,'.'));
				
		INSERT INTO inp_dscenario_demand (feature_type, dscenario_id, feature_id, demand, source)
		SELECT 'CONNEC' as feature_type, v_scenarioid, c.connec_id as node_id, (case when custom_sum is null then v_factor*sum else v_factor*custom_sum end) as volume, hc.hydrometer_id
		FROM ext_rtc_hydrometer_x_data d
		JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text
		JOIN rtc_hydrometer_x_connec hc USING (hydrometer_id) 
		JOIN connec c ON c.connec_id = hc.connec_id
		WHERE cat_period_id  = v_period AND c.expl_id = v_expl
		order by 2;

		-- real number of hydrometers
		GET DIAGNOSTICS v_count = row_count;	
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat(v_count, ' rows with demands have been inserted on inp_dscenario_table, which it means ',v_count,' hydrometers.'));

		-- real volume inserted
		SELECT sum(demand)/v_factor INTO v_count2 FROM inp_dscenario_demand WHERE dscenario_id = v_scenarioid;

		--log
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('The volume water inserted is ',v_count2,', wich it means that lossed water percentatge due leak of data have been ', 
		(100-100*v_count2::float/v_total_vol::float)::numeric(12,2),' %.'));
		
		-- update patterns  (1 -> none)
		IF v_pattern = 2 THEN -- sector default

			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id 
			FROM sector s 
			JOIN connec USING (sector_id) 
			JOIN rtc_hydrometer_x_connec h USING (connec_id)
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;
		
		ELSIF v_pattern = 4 THEN -- dma default

			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id 
			FROM dma s 
			JOIN connec c ON c.dma_id = s.dma_id::integer  
			JOIN rtc_hydrometer_x_connec h USING (connec_id) 
			WHERE d.source = h.hydrometer_id
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 5 THEN -- dma period

			UPDATE inp_dscenario_demand d SET pattern_id = s.pattern_id 
			FROM ext_rtc_dma_period s 
			JOIN connec c ON c.dma_id = s.dma_id::integer  
			JOIN rtc_hydrometer_x_connec h USING (connec_id) 
			WHERE d.source = h.hydrometer_id AND cat_period_id = v_period
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 6 THEN -- hydrometer period

			UPDATE inp_dscenario_demand d SET pattern_id = h.pattern_id 
			FROM ext_rtc_hydrometer_x_data h
			WHERE d.source = h.hydrometer_id AND cat_period_id = v_period
			AND dscenario_id = v_scenarioid;

		ELSIF v_pattern = 7 THEN -- hydrometer category

			UPDATE inp_dscenario_demand d SET pattern_id = c.pattern_id 
			FROM ext_rtc_hydrometer h
			JOIN ext_hydrometer_category c ON c.id::integer = h.category_id
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
				VALUES (v_fid, v_result_id, 2, concat('SECTOR PERIOD: ext_rtc_sector_period table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('DMA PERIOD: ext_rtc_dma_period table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('HYDROMETER PERIOD: ext_rtc_hydrometer_x_data table.'));
				INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
				VALUES (v_fid, v_result_id, 2, concat('HYDROMETER PERIOD: hydrometer_category table.'));
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

	-- manage exceptions
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;