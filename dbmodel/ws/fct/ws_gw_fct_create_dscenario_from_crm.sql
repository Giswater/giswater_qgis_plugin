/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
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
v_startdate TEXT;
v_enddate TEXT;
v_sql TEXT;
v_tmethod text;
v_tmethod_query TEXT;
v_query_catdscenario TEXT;

v_step integer;
v_queryfinal TEXT;
v_queryhydro TEXT;
v_percent_hydro text;
v_proposed_enddate text;
v_rec_hydro record;
v_query_period text;
v_dma_weight_factor boolean;

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater, project_type INTO v_version, v_projecttype FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_step := ((p_data ->>'data')::json->>'parameters')::json->>'step';
	v_name :=  ((p_data ->>'data')::json->>'parameters')::json->>'name';
	v_descript :=  ((p_data ->>'data')::json->>'parameters')::json->>'descript';
	v_period :=  ((p_data ->>'data')::json->>'parameters')::json->>'period';
	v_pattern :=  ((p_data ->>'data')::json->>'parameters')::json->>'pattern';
	v_demandunits :=  ((p_data ->>'data')::json->>'parameters')::json->>'demandUnits';
	v_expl :=  ((p_data ->>'data')::json->>'parameters')::json->>'exploitation'::text;
	v_onlyiswaterbal :=  ((p_data ->>'data')::json->>'parameters')::json->>'onlyIsWaterBal';
	v_tmethod :=  ((p_data ->>'data')::json->>'parameters')::json->>'patternOrDate';
	v_startdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'initDate'::text;
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'endDate';
	v_dma_weight_factor :=  ((p_data ->>'data')::json->>'parameters')::json->>'export_weight';


	v_percent_hydro := (SELECT "value" FROM config_param_user WHERE "parameter" = 'epa_dscenario_percent_hydro_threshold');
	v_percent_hydro = coalesce(v_percent_hydro, '1');

	IF v_expl = '99999' THEN

		EXECUTE 'SELECT string_agg(expl_id::text, '', '') from exploitation WHERE active IS TRUE AND expl_id>0 ' INTO v_expl;

	END IF;


	-- query calc hydro: (enddate)
	v_queryhydro = 'WITH hydro_data AS (
        SELECT
        d.hydrometer_id,
        d.cat_period_id,
        d.sum,
        p.end_date AS p_end_date,
        first_value(d.sum) OVER w AS last_sum,
        first_value(d.cat_period_id) OVER w AS last_cat_period_id,
        first_value(p.end_date) OVER w::date AS last_end_date,
        first_value(p.period_seconds) OVER w AS last_period_seconds
        FROM ext_rtc_hydrometer_x_data d
        JOIN ext_cat_period p ON d.cat_period_id = p.id
        WINDOW w AS (PARTITION BY d.hydrometer_id ORDER BY p.end_date desc)
    ), hydro_data_calculat AS (
        SELECT DISTINCT
        d.hydrometer_id,
        d.last_sum,
        d.last_cat_period_id,
        d.last_end_date,
        d.last_period_seconds AS p_seconds
        FROM hydro_data d
    ), hydro_data_selected AS (
        SELECT d.*
        FROM hydro_data_calculat d
        JOIN ext_rtc_hydrometer h ON d.hydrometer_id = h.hydrometer_id
        WHERE h.end_date IS NULL
	), hydro_data_selected_expl AS (
	     SELECT d.*, c.expl_id AS expl_id
	     FROM hydro_data_selected d
	     JOIN rtc_hydrometer_x_connec hc ON hc.hydrometer_id = d.hydrometer_id
	     JOIN connec c ON c.connec_id = hc.connec_id
		 WHERE expl_id in ('||v_expl||')
	     UNION ALL
	     SELECT d.*, n.expl_id AS expl_id
	     FROM hydro_data_selected d
	     JOIN rtc_hydrometer_x_node hn ON hn.hydrometer_id = d.hydrometer_id
	     JOIN node n ON n.node_id = hn.node_id
	     WHERE expl_id in ('||v_expl||')
     ), hydro_estimated_statistic AS (
    	SELECT
        d.*,
        count(*) OVER (ORDER BY d.last_end_date RANGE BETWEEN UNBOUNDED PRECEDING AND ''1 days'' PRECEDING) AS hydro_no_llegits,
        count(*) OVER (PARTITION BY d.last_end_date) AS hydro_day,
        count(*) OVER () AS hydro_total
    	FROM hydro_data_selected_expl as d) ';

	IF v_step = 1 THEN -- set proposal OF enddate

		v_sql = concat(v_queryhydro, ' SELECT max(last_end_date)
    	FROM hydro_estimated_statistic
    	WHERE (100*hydro_no_llegits/hydro_total::float) < '||v_percent_hydro||'');

		execute v_sql INTO v_proposed_enddate;

    	v_proposed_enddate = coalesce(v_proposed_enddate, '1800-01-01');

		EXECUTE '
 		UPDATE temp_sys_function
 		SET descript = REPLACE(descript, split_part(descript, ''>'', 2), ''End Date proposal for '||v_percent_hydro||'% of hydrometers which consum is out of the period: '||v_proposed_enddate::TIMESTAMP||''')
		WHERE id in (3110)';


		v_proposed_enddate = quote_literal(v_proposed_enddate)::date - INTERVAL '1 day';
		v_proposed_enddate = v_proposed_enddate::date;

		UPDATE temp_config_toolbox 
 		SET inputparams = (
 		    SELECT jsonb_agg(
 		        CASE 
 		            WHEN elem->>'widgetname' = 'endDate' 
 		            THEN jsonb_set(elem, '{value}', to_jsonb(v_proposed_enddate::text))
 		            ELSE elem
 		        END
 		    )
 		    FROM jsonb_array_elements(inputparams::jsonb) elem
 		)
 		WHERE id = 3110;
   		RETURN '{"status":"Accepted"}';

	END IF;



	IF v_onlyiswaterbal is true then
		v_waterbal = 'TRUE';
	ELSE
		v_waterbal = 'TRUE, FALSE, NULL';
	END IF;
	
	v_crm_name := (SELECT code FROM ext_cat_period WHERE id  = v_period);
	
	IF v_tmethod = '1' then

		v_periodseconds := (SELECT period_seconds FROM ext_cat_period WHERE id  = v_period);
	
	ELSIF v_tmethod = '2' THEN --use date INTERVAL
	
		EXECUTE 'SELECT ('||quote_literal(v_enddate)||'::date - '||quote_literal(v_startdate)||'::date) * 24 * 3600' INTO v_periodseconds; -- FROM days to seconds
	
	END IF;

	

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
	CASE WHEN v_expl ILIKE '%,%' THEN NULL ELSE v_expl::integer END,
	concat('Insert by ',current_user,' on ', substring(now()::text,0,20),'. Input params:{"Target feature":"", "Exploitation":"'||v_expl||'", "Source CRM Period":"',v_crm_name,'", "Source Pattern":"',v_pattern,'", "Demand Units":"',v_demandunits,'"}')
	ON CONFLICT (name) DO NOTHING RETURNING dscenario_id INTO v_scenarioid;


	IF v_tmethod = '1' THEN -- use period_id

		IF v_dma_weight_factor IS TRUE THEN

			v_querytext = 
				'WITH hydros AS (
					SELECT hydrometer_id, c.connec_id AS feature_id, c.dma_id, ''CONNEC'' AS feature_type, c.expl_id
					from rtc_hydrometer_x_connec e
						JOIN connec c ON c.connec_id = e.connec_id
					UNION ALL
					SELECT
						hydrometer_id, n.node_id AS feature_id, n.dma_id, ''NODE'' AS feature_type, n.expl_id
					from rtc_hydrometer_x_node e
						JOIN node n ON n.node_id = e.node_id
				),
				data AS (
					SELECT d.hydrometer_id, h.dma_id, h.feature_id, h.feature_type, h.expl_id, sum, custom_sum
					FROM ext_rtc_hydrometer_x_data d
					JOIN hydros h
					ON h.hydrometer_id = d.hydrometer_id
					WHERE d.cat_period_id = '||quote_literal(v_period)||'
				)
				SELECT
					feature_type,
					feature_id,
					COALESCE(custom_sum, sum) / SUM(COALESCE(custom_sum, sum)) OVER (PARTITION BY dma_id) AS demand_weight,
					sum,
					custom_sum,
					concat(''pattern_dma'', dma_id) AS pattern_id,
					hydrometer_id,
					expl_id,
					dma_id
				FROM data';

		ELSE
			v_querytext = '
			with final_hydros as (
				SELECT hydrometer_id, sum, custom_sum, pattern_id from ext_rtc_hydrometer_x_data where cat_period_id = '||quote_literal(v_period)||'
			), aux_data AS (
				SELECT b.hydrometer_id, b.connec_id AS feature_id, ''CONNEC'' AS feature_type, a.expl_id FROM rtc_hydrometer_x_connec b JOIN connec a USING (connec_id) UNION
						SELECT hydrometer_id, node_id AS feature_id, ''NODE'' AS feature_type, a.expl_id FROM rtc_hydrometer_x_node JOIN node a USING (node_id)
			)
			SELECT*FROM final_hydros LEFT JOIN aux_data USING (hydrometer_id) where feature_id is not null and expl_id in ('||v_expl||')';
		END IF;

	ELSIF v_tmethod = '2' THEN -- calculate period

		v_query_period = 
		'WITH period_calculat AS (
	        SELECT
				p.id, p.start_date::date, p.end_date::date, p.period_seconds AS p_seconds,
				CASE
					WHEN p.start_date >= '||quote_literal(v_startdate)||'::date THEN p.start_date
					ELSE '||quote_literal(v_startdate)||'
				END::date AS c_start_date,
				CASE
					WHEN p.end_date <= '||quote_literal(v_enddate)||'::date + INTERVAL ''1 day'' THEN p.end_date
						ELSE '||quote_literal(v_enddate)||'
				END::date AS c_end_date
			FROM ext_cat_period p
		),
		period_selected AS (
			SELECT
				p.*,
				EXTRACT(EPOCH FROM p.c_end_date::date + INTERVAL ''1 day'') - EXTRACT(EPOCH FROM p.c_start_date) AS c_seconds
			FROM period_calculat p
			WHERE p.end_date >= '||quote_literal(v_startdate)||'
			AND  p.start_date <= '||quote_literal(v_enddate)||'::date + INTERVAL ''1 day''
		),';

		IF v_dma_weight_factor IS TRUE THEN
			v_querytext = v_query_period||
			'hydros AS (
				SELECT b.hydrometer_id, b.connec_id AS feature_id, c.dma_id, ''CONNEC'' AS feature_type, c.expl_id
				FROM rtc_hydrometer_x_connec b
				JOIN connec c ON c.connec_id = b.connec_id
				UNION ALL
				SELECT b.hydrometer_id, b.node_id AS feature_id, n.dma_id, ''NODE'' AS feature_type, n.expl_id
				FROM rtc_hydrometer_x_node b
				JOIN node n ON n.node_id = b.node_id
			),
			data AS (
				SELECT
					d.hydrometer_id,
					h.dma_id,
					h.feature_id,
					h.feature_type,
					h.expl_id,
					SUM(d.sum * (p.c_seconds / p.p_seconds))::numeric(10,0) AS sum,
					NULL::numeric AS custom_sum,
					d.pattern_id
				FROM ext_rtc_hydrometer_x_data d
				JOIN period_selected p ON d.cat_period_id = p.id
				JOIN hydros h ON d.hydrometer_id = h.hydrometer_id
				GROUP BY d.hydrometer_id, h.dma_id, h.feature_id, h.feature_type, h.expl_id, d.pattern_id
			)
			SELECT
				feature_type,
				feature_id,
				COALESCE(custom_sum, sum) / SUM(COALESCE(custom_sum, sum)) OVER (PARTITION BY dma_id) AS demand_weight,
				sum,
				custom_sum,
				concat(''pattern_dma'', dma_id) AS pattern_id,
				hydrometer_id,
				expl_id,
				dma_id
			FROM data
			WHERE feature_id IS NOT NULL
			AND expl_id IN ('||v_expl||')';

		ELSE

		v_querytext = v_query_period||
		'final_hydros AS  (
			    SELECT
			    d.hydrometer_id,
			    sum(d.sum*(p.c_seconds/p.p_seconds))::numeric(10,0) AS sum, null as custom_sum, pattern_id
			    FROM ext_rtc_hydrometer_x_data d
			    JOIN period_selected p ON d.cat_period_id = p.id
			    GROUP BY hydrometer_id, pattern_id
			), aux_data AS (
				SELECT b.hydrometer_id, b.connec_id AS feature_id, ''CONNEC'' AS feature_type, a.expl_id FROM rtc_hydrometer_x_connec b JOIN connec a USING (connec_id) UNION
				SELECT hydrometer_id, node_id AS feature_id, ''NODE'' AS feature_type, a.expl_id FROM rtc_hydrometer_x_node JOIN node a USING (node_id)
			)
				SELECT*FROM final_hydros LEFT JOIN aux_data USING (hydrometer_id) where feature_id is not null and expl_id in ('||v_expl||')';
		END IF;

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
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Period seconds: ',abs(v_periodseconds)));
	
		IF (SELECT period_seconds FROM ext_cat_period WHERE id  = v_period) IS NULL THEN
			SELECT dscenario_id INTO v_scenarioid FROM cat_dscenario where name = v_name;
			INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
			VALUES (v_fid, null, 2, concat('WARNING: The period has not data on period_seconds columns. The system default value have been used ( ',v_periodseconds,' ) '));
		END IF;

		-- this factor is calculated assuming period value is on M3
		v_factor = 1000*(SELECT value::json->>v_demandunits FROM config_param_system WHERE parameter = 'epa_units_factor')::float/v_periodseconds::float;		


		-- count hydrometers and total vol grouped by feature_type
		EXECUTE 'SELECT COUNT(hydrometer_id) FROM ('||v_querytext||')' INTO v_total_hydro;

		EXECUTE 'SELECT sum("sum") FROM ('||v_querytext||')' INTO v_total_vol;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('There are ', v_total_hydro, ' hydrometers with data for this period and this exploitation.'));

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)	
		VALUES (v_fid, v_result_id, 1, concat('The total volume (m3) for all the hydrometers is ', v_total_vol,'.'));

		IF v_dma_weight_factor is true then
			EXECUTE 'INSERT INTO inp_pattern (pattern_id, active)
			SELECT concat(''pattern_dma'', dma_id), true
			FROM dma
			WHERE EXISTS (SELECT 1 FROM ('||v_querytext||') v WHERE v.dma_id = dma.dma_id)
			ON CONFLICT DO NOTHING;';

			EXECUTE 'INSERT INTO inp_dscenario_demand (feature_type, dscenario_id, feature_id, demand, source, pattern_id)
			WITH aux as ('||v_querytext||')
			SELECT  feature_type, '||v_scenarioid||', feature_id,
			demand_weight as volume,
			hydrometer_id as source,
			pattern_id
			FROM aux order by 2';
		ELSE
			EXECUTE 'INSERT INTO inp_dscenario_demand (feature_type, dscenario_id, feature_id, demand, source)
			WITH aux as ('||v_querytext||')
			SELECT  feature_type, '||v_scenarioid||', feature_id,
			(case when custom_sum is null then '||v_factor||'*sum::numeric else '||v_factor||'*custom_sum::numeric end) as volume,
			hydrometer_id as source
			FROM aux order by 2';
		END IF;

		-- real volume inserted
		SELECT sum(demand)/v_factor INTO v_count2 FROM inp_dscenario_demand WHERE dscenario_id = v_scenarioid;

		--log
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('The volume water inserted is ',v_count2,', wich it means that lossed water percentatge due leak of data have been ',
		(100-100*v_count2::float/v_total_vol::float)::numeric(12,2),' %.'));

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1, concat('The water loss could be motivated by current connecs with state = 0 which they was operative for that period with some hydrometer linked'));
	
		-- update patterns  (1 -> none)
		IF v_dma_weight_factor IS FALSE THEN
			IF v_pattern = 2 THEN -- sector default

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
				WHERE d.source = h.hydrometer_id AND h.hydrometer_id IN (SELECT hydrometer_id FROM ('||v_querytext||'))
				AND dscenario_id = '||v_scenarioid||'';

			ELSIF v_pattern = 5 THEN -- hydrometer period

				EXECUTE '
				UPDATE inp_dscenario_demand d SET pattern_id = h.pattern_id
				FROM ext_rtc_hydrometer_x_data h
				WHERE d.source = h.hydrometer_id AND h.hydrometer_id IN (SELECT hydrometer_id FROM ('||v_querytext||'))
				AND dscenario_id = '||v_scenarioid||'';

			ELSIF v_pattern = 6 THEN -- hydrometer category

				UPDATE inp_dscenario_demand d SET pattern_id = c.pattern_id 
				FROM ext_rtc_hydrometer h
				JOIN ext_hydrometer_category c ON c.id::integer = h.category_id
				WHERE d.source = h.hydrometer_id::text
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
				

		-- hydro stats

		EXECUTE concat(v_queryhydro, ', aux AS (
    	SELECT DISTINCT last_end_date, hydro_no_llegits, hydro_day,hydro_total,
		(100*hydro_no_llegits/hydro_total::float) AS percentage
		FROM hydro_estimated_statistic
		ORDER BY last_end_date)
		SELECT aux.*, ROW_NUMBER() OVER(PARTITION BY percentage ORDER BY percentage)
		FROM aux WHERE percentage< ', v_percent_hydro, ' ORDER BY ROW_NUMBER() OVER() DESC LIMIT 1')
		INTO v_rec_hydro;


		INSERT INTO audit_check_data (fid, result_id, criticity, error_message)
		VALUES (v_fid, v_result_id, 1,
		concat('INFO: There are ', v_rec_hydro.hydro_no_llegits, ' non-read hydrometers from ', v_rec_hydro.hydro_total, ' hydrometers in total (', v_rec_hydro.percentage, '% of the hydrometers)')
		);

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
	v_result_info = concat ('{"values":',v_result, '}');

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