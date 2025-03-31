/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3142
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_waterbalance(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
EXAMPLE
-------
SELECT SCHEMA_NAME.gw_fct_waterbalance($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{}, "data":{"parameters":{"executeGraphDma":"false", "exploitation":1, "period":"5", "method":"CPW"}}}$$)::text;
SELECT SCHEMA_NAME.gw_fct_waterbalance($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{}, "data":{"parameters":{"executeGraphDma":"false", "exploitation":1, "allPeriods":true, "method":"DCW"}}}$$)::text;
CPW-CRM PERIOD
DCW-DYNAMIC CENTROID

CHECK
-----
DELETE FROM om_waterbalance

SELECT * FROM om_waterbalance

SELECT * FROM ext_cat_period

-- fid: 441

*/

DECLARE

v_fid integer = 441;
v_expl text;
v_period text;
v_allperiods boolean;
rec text;
v_querytext text;

v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_version text;
v_error_context text;
v_count integer = 0;
v_executegraphdma boolean;
v_updatemapzone integer;
v_paramupdate double precision;
v_data json;
rec_nrw record;
v_method text;
v_startdate text;
v_enddate text;
v_dma integer;
v_total_hydro double precision = 0;
v_total_input double precision = 0;
v_total_inlet double precision = 0;
v_total_out double precision = 0;
v_centroidday integer;
v_prevperiod text;
v_hydrometer integer;

v_kmarc  double precision = 0;
v_kmconnec  double precision = 0;
v_numconnec  double precision = 0;
v_avgpress  double precision = 0;
v_a double precision = 0;
v_b double precision = 0;
v_c double precision = 0;
v_ili double precision = 0;
v_uarl double precision = 0;
v_carl double precision = 0;

v_setmawithperiodmeters boolean = false;

v_days_limiter integer;
v_current_date text;
v_days_past integer;

v_percent_hydro TEXT;
v_queryhydro TEXT;
v_proposed_enddate TEXT;
v_step integer;
v_tmethod TEXT;
v_sql TEXT;
v_flag_date date = '1800-01-01';
v_descript TEXT;


BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_expl := ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_period := ((p_data ->>'data')::json->>'parameters')::json->>'period';
	v_executegraphdma := ((p_data ->>'data')::json->>'parameters')::json->>'executeGraphDma';
	v_method := ((p_data ->>'data')::json->>'parameters')::json->>'method';
	v_tmethod := ((p_data ->>'data')::json->>'parameters')::json->>'patternOrDate';
	v_startdate :=  ((p_data ->>'data')::json->>'parameters')::json->>'initDate'::text;
	v_enddate :=  ((p_data ->>'data')::json->>'parameters')::json->>'endDate'::text;
	v_step := ((p_data ->>'data')::json->>'parameters')::json->>'step';

	v_percent_hydro := (SELECT "value" FROM config_param_user WHERE "parameter" = 'epa_dscenario_percent_hydro_threshold');
	v_percent_hydro = coalesce(v_percent_hydro, '1');

	-- Reset values
	DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid = v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('WATER BALANCE BY EXPLOITATION AND PERIOD'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');


	
	IF v_expl = 'ALL' THEN -- ALL expls
	
		EXECUTE 'SELECT string_agg(expl_id::text, '', '') FROM exploitation WHERE expl_id>0' INTO v_expl;
	
	END IF;

	

	IF v_step = 1 THEN -- set proposal OF enddate
	
		EXECUTE 'SELECT string_agg(expl_id::text, '','') FROM exploitation WHERE expl_id>0' INTO v_expl;
	
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
        JOIN ext_rtc_hydrometer h ON d.hydrometer_id = h.id
        WHERE h.end_date IS NULL
	), hydro_data_selected_expl AS (
	     SELECT d.*, c.expl_id AS expl_id
	     FROM hydro_data_selected d
	     JOIN rtc_hydrometer_x_connec hc ON hc.hydrometer_id = d.hydrometer_id
	     JOIN connec c ON c.connec_id = hc.connec_id
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
    	FROM hydro_data_selected_expl as d
	) 
		SELECT max(last_end_date)
    	FROM hydro_estimated_statistic
    	WHERE (100*hydro_no_llegits/hydro_total::float) < '||v_percent_hydro||'';

		execute v_queryhydro INTO v_proposed_enddate;

    	v_proposed_enddate = coalesce(v_proposed_enddate, '1800-01-01');

		EXECUTE '
 		UPDATE temp_sys_function
 		SET descript = REPLACE(descript, split_part(descript, ''>'', 2), ''End Date proposal for '||v_percent_hydro||'% of hydrometers which consum is out of the period: '||v_proposed_enddate::TIMESTAMP||''')
		WHERE id in (3142)';


		v_proposed_enddate = quote_literal(v_proposed_enddate)::date - INTERVAL '1 day';
		v_proposed_enddate = v_proposed_enddate::date;

 		UPDATE temp_config_toolbox c SET inputparams = REPLACE(inputparams::TEXT, inputparams->5->>'value', v_proposed_enddate)::JSON WHERE id = 3142; --enddate
 		
 		v_expl = NULL;

   		RETURN '{"status":"Accepted"}';

	END IF;


	IF v_executegraphdma THEN

		IF v_setmawithperiodmeters THEN 

			EXECUTE 'UPDATE dma SET active = false, the_geom = null WHERE expl_id in ('||v_expl||')';
			
			EXECUTE '
			UPDATE dma SET active = true FROM 
			(SELECT * FROM 
			(SELECT dma_id, (json_array_elements_text((graphconfig->>''use'')::json))::json->>''nodeParent''  as node_id FROM dma) b JOIN 
			(SELECT DISTINCT (node_id) FROM ext_cat_period, ext_rtc_scada_x_data JOIN node USING (node_id) WHERE  
			node.expl_id in ('||v_expl||')AND start_date < value_date AND end_date > value_date) a USING (node_id))c
			WHERE dma.dma_id = c.dma_id';
			
		END IF;
		
		v_updatemapzone = (SELECT (value::json->>'DMA')::json->>'updateMapZone' FROM config_param_system WHERE parameter  = 'utils_graphanalytics_vdefault');
		v_paramupdate = (SELECT (value::json->>'DMA')::json->>'geomParamUpdate' FROM config_param_system WHERE parameter  = 'utils_graphanalytics_vdefault');
			
		v_data =  concat ('{"data":{"parameters":{"graphClass":"DMA", "exploitation": "',v_expl,'", "updateMapZone":',v_updatemapzone,
		', "geomParamUpdate":',v_paramupdate,', "updateFeature":true}}}');

		PERFORM gw_fct_graphanalytics_mapzones(v_data);
	
	END IF;

	

	IF v_method in ('DCW', 'CPW') THEN -- time method: period_id
	
		v_descript = 'Time method: period_id';
	
		v_startdate = (SELECT start_date FROM ext_cat_period WHERE id = v_period);
		v_enddate =  (SELECT end_date FROM ext_cat_period WHERE id = v_period);
	
	ELSIF v_tmethod = 'CDI' THEN -- time METHOD: date interval
	
		v_period = 'NULL';
	
		v_descript = 'Time method: Custom date interval';
	
	END IF;

	
	--RAISE EXCEPTION 'v_expl %', v_expl;

	--EXECUTE '
	v_sql = '
	INSERT INTO om_waterbalance (expl_id, dma_id, cat_period_id, startdate, enddate, descript)
	SELECT 
	expl_id, dma_id, '||v_period||'::text, '||quote_literal(v_startdate)||'::date, '||quote_literal(v_enddate)||'::date, '||quote_literal(v_descript)||' 
	FROM dma WHERE expl_id @> ARRAY['||v_expl||'] AND dma_id > 0 AND active IS TRUE
	ON CONFLICT (dma_id, startdate, enddate) do nothing';

	--RAISE EXCEPTION 'v_sql %', v_sql;

	IF v_method = 'CPW' THEN -- static period or remote lecture period (1 day)

		UPDATE om_waterbalance SET startdate = v_startdate::date, enddate = v_enddate::date WHERE cat_period_id = v_period;
		
		-- total inlet
		UPDATE om_waterbalance n SET total_in =  value FROM (
		SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric as value 
		FROM ext_cat_period p, ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph  USING (node_id)
		WHERE value_date >= start_date AND value_date <= end_date and flow_sign = 1
		GROUP BY p.id, dma_id order by 1,2)a
		WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.id;

		-- total_inyected
		UPDATE om_waterbalance n SET total_sys_input =  value FROM (
		SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric as value 
		FROM ext_cat_period p, ext_rtc_scada_x_data d JOIN om_waterbalance_dma_graph  USING (node_id)
		WHERE value_date >= start_date AND value_date <= end_date
		GROUP BY p.id, dma_id order by 1,2)a
		WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.id;

		-- total outlet
		UPDATE om_waterbalance n SET total_out = total_in - total_sys_input
		WHERE cat_period_id = v_period;

 		EXECUTE 'SELECT count(*) FROM om_waterbalance WHERE cat_period_id = '||v_period ||'::text AND expl_id in ('||v_expl||')' INTO v_count;

		-- auth_bill_met_hydro
		UPDATE om_waterbalance n SET auth_bill_met_hydro = value::numeric FROM (SELECT dma_id, cat_period_id, (sum(sum))::numeric as value
		FROM ext_rtc_hydrometer_x_data d
		JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
		JOIN connec c USING (connec_id) 
		JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text
		WHERE is_waterbal IS TRUE OR is_waterbal IS NULL
		GROUP BY dma_id, cat_period_id)a
		WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id;
	
		select count(*) into v_hydrometer
		FROM ext_rtc_hydrometer_x_data d
		JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
		JOIN connec c USING (connec_id) 
		JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text
		WHERE (is_waterbal IS TRUE OR is_waterbal IS NULL) AND cat_period_id = v_period;

		UPDATE om_waterbalance SET auth_bill_met_hydro = 0 WHERE auth_bill_met_hydro is null AND cat_period_id = v_period;
		
 	ELSIF v_method = 'DCW' THEN -- dynamic period acording centroid for dates x vol of dma

		FOR v_dma IN EXECUTE 'SELECT DISTINCT dma_id FROM connec WHERE state = 1 AND expl_id in ('||v_expl||')'
		LOOP
			v_count = v_count + 1;
		
			EXECUTE '
			SELECT sum(sum) FROM ext_rtc_hydrometer_x_data d JOIN rtc_hydrometer_x_connec USING (hydrometer_id) JOIN connec USING (connec_id) 
			JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text where cat_period_id = '||v_period||'::text AND dma_id = '||v_dma||' AND connec.expl_id in ('||v_expl||') AND is_waterbal IS TRUE
			' INTO v_total_hydro;
		
			EXECUTE '
			SELECT (sum(sum*extract(epoch from value_date)/(24*3600)))/'||v_total_hydro||' FROM ext_rtc_hydrometer_x_data d
			JOIN rtc_hydrometer_x_connec USING (hydrometer_id) JOIN connec USING (connec_id) 
			JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text where cat_period_id = '||v_period ||'::text AND dma_id = '||v_dma ||' AND is_waterbal IS TRUE
			' INTO v_centroidday;
						
				
			IF v_centroidday IS NULL THEN 
				v_centroidday = extract(epoch from((end_date - start_date) + start_date))/(24*3600);
			END IF;

			v_startdate = (SELECT start_date FROM ext_cat_period WHERE id = v_period);
	
			v_prevperiod = (SELECT id FROM ext_cat_period WHERE end_date + interval '5 days' > v_startdate::date AND start_date <  v_startdate::date);
	
			v_startdate = (SELECT enddate FROM om_waterbalance WHERE dma_id = v_dma AND cat_period_id = v_prevperiod);

			IF v_startdate IS NULL OR v_prevperiod IS NULL THEN v_startdate = '1970-01-01'::date; END IF;

			v_enddate = (to_timestamp(v_centroidday*3600*24))::date;

			--raise notice ' % % % % % %',v_centroidday::integer , v_period, v_prevperiod, v_dma, v_startdate, v_enddate;

			v_total_input = (SELECT (sum(coalesce(value,0)*flow_sign))::numeric
					FROM ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph USING (node_id) WHERE dma_id = v_dma AND value_date >= v_startdate::date AND value_date <= v_enddate::date);
	
			v_total_inlet = (SELECT (sum(coalesce(value,0)*flow_sign))::numeric
					FROM ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph USING (node_id) WHERE flow_sign = 1 AND dma_id = v_dma AND value_date >= v_startdate::date AND value_date <= v_enddate::date);
	
			v_total_out = v_total_inlet - v_total_input;

			UPDATE om_waterbalance SET total_sys_input = v_total_input, total_in = v_total_inlet, total_out = v_total_out,
					auth_bill_met_hydro = v_total_hydro::numeric, startdate = v_startdate::date, enddate = v_enddate::date WHERE cat_period_id = v_period::text AND dma_id = v_dma;
		END LOOP;
	
	
	ELSIF v_method = 'CDI' THEN -- custom date interval
	
		-- total inlet
		UPDATE om_waterbalance n SET total_in =  value FROM (
		SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric as value, v_startdate::date AS startdate, v_enddate::date AS enddate
		FROM ext_cat_period p, ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph  USING (node_id)
		WHERE value_date::date >= v_startdate::date AND value_date::date <= v_enddate::date and flow_sign = 1
		GROUP BY p.id, dma_id order by 1,2)a
		WHERE n.dma_id = a.dma_id AND n.startdate::date = v_startdate::date AND n.enddate::date = v_enddate::date;

	
		-- total_inyected
		UPDATE om_waterbalance n SET total_sys_input =  value FROM (
		SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric as value, v_startdate::date AS startdate, v_enddate::date AS enddate
		FROM ext_cat_period p, ext_rtc_scada_x_data d JOIN om_waterbalance_dma_graph  USING (node_id)
		WHERE value_date::date >= v_startdate::date AND value_date::date <= v_enddate::date
		GROUP BY p.id, dma_id order by 1,2)a
		WHERE n.dma_id = a.dma_id AND n.startdate::date = v_startdate::date AND n.enddate::date = v_enddate::date;


		-- total outlet
		UPDATE om_waterbalance n SET total_out = total_in - total_sys_input
		WHERE startdate::date = v_startdate::date AND enddate::date = v_enddate::date;


		EXECUTE '
 		SELECT count(*) FROM om_waterbalance 
 		WHERE startdate::date = '||quote_literal(v_startdate)||'::date AND enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id IN ('||v_expl||')
		' INTO v_count;


		-- auth_bill_met_hydro
		EXECUTE '
		UPDATE om_waterbalance n SET auth_bill_met_hydro = value::numeric FROM (SELECT dma_id, '||quote_literal(v_startdate)||', '||quote_literal(v_enddate)||', (sum(sum))::numeric as value
		FROM ext_rtc_hydrometer_x_data d
		JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
		JOIN connec c USING (connec_id) 
		JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text
		WHERE is_waterbal IS TRUE OR is_waterbal IS NULL
		GROUP BY dma_id, cat_period_id)a
		WHERE n.dma_id = a.dma_id AND n.startdate::date = '||quote_literal(v_startdate)||'::date AND enddate::date = '||quote_literal(v_enddate)||'::date';
	
	
		EXECUTE '
		select count(*)
		FROM ext_rtc_hydrometer_x_data d
		JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
		JOIN connec c USING (connec_id) 
		JOIN ext_rtc_hydrometer h ON h.id::text = d.hydrometer_id::text
		WHERE (is_waterbal IS TRUE OR is_waterbal IS NULL) AND h.start_date::date = '||quote_literal(v_startdate)||'::date and h.end_date::date = '||quote_literal(v_enddate)||'::date'
		into v_hydrometer;
	
	
		UPDATE om_waterbalance SET auth_bill_met_hydro = 0 WHERE auth_bill_met_hydro is null 
		AND startdate::date = quote_literal(v_startdate)::date AND enddate::date = quote_literal(v_enddate)::date;
		
	
		--EXECUTE 'UPDATE om_waterbalance SET startdate = '||quote_literal(v_startdate)||'::date, enddate = '||quote_literal(v_enddate)||'::date WHERE expl_id IN ('||v_expl||')';
	
	END IF;


	--update data
	EXECUTE '
	UPDATE om_waterbalance n SET n_connec = count_connecs, link_length = length::numeric(12,3)
	FROM (SELECT c.dma_id, count(c.connec_id) as count_connecs, sum(st_length(l.the_geom)) /1000 as length
	FROM ext_cat_period p, rtc_hydrometer_x_connec d
	JOIN connec c USING (connec_id) 
	JOIN ext_rtc_hydrometer h ON c.customer_code::text = h.connec_id::text
	left join link l on c.connec_id = feature_id
	where c.state=1 AND is_waterbal IS TRUE
	GROUP BY c.dma_id)a
	WHERE n.dma_id = a.dma_id AND n.startdate::date = '||quote_literal(v_startdate)||'::date AND n.enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')';


	-- n_hydro
	EXECUTE '
	UPDATE om_waterbalance n SET n_hydro = count_hydro FROM 
	(SELECT dma_id, count(hydrometer_id) as count_hydro
	FROM rtc_hydrometer_x_connec d
	JOIN connec c USING (connec_id) 
	JOIN ext_rtc_hydrometer h ON c.customer_code::text = h.connec_id::TEXT
	GROUP BY dma_id)a
	WHERE n.dma_id = a.dma_id AND n.startdate::date = '||quote_literal(v_startdate)||'::date AND n.enddate::date = '||quote_literal(v_enddate )||'::date AND expl_id in ('||v_expl||')';

	UPDATE om_waterbalance set n_connec = 0, link_length = 0, n_hydro = 0 where n_connec is null;

	-- arc_length
	EXECUTE '
	UPDATE om_waterbalance n SET arc_length = length::numeric(12,3) FROM 
	(SELECT dma_id, sum(st_length(the_geom)) /1000 as length
	FROM arc c
	GROUP BY dma_id)a
	WHERE n.dma_id = a.dma_id AND n.startdate::date = '||quote_literal(v_startdate)||'::date and n.enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')';

	UPDATE om_waterbalance set arc_length = 0 where arc_length is null;


	-- meters_in
	EXECUTE '
	UPDATE om_waterbalance w SET meters_in = meters FROM 
	(SELECT string_agg (node_id, '', '') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = 1 group by dma_id) a
	WHERE a.dma_id = w.dma_id AND w.startdate::date = '||quote_literal(v_startdate)||'::date and w.enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')';


	-- meters_out
	EXECUTE '
	UPDATE om_waterbalance w SET meters_out = meters FROM 
	(SELECT string_agg (node_id, '', '') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = -1 group by dma_id) a
	WHERE a.dma_id = w.dma_id AND w.startdate::date = '||quote_literal(v_startdate)||'::date and w.enddate::date = '||quote_literal(v_enddate)||'::date AND w.expl_id in ('||v_expl||')';

	
	-- auth_bill
	EXECUTE '
	UPDATE om_waterbalance SET auth_bill = (COALESCE(auth_bill_met_export, 0::double precision) + 
	COALESCE(auth_bill_met_hydro, 0::double precision) + COALESCE(auth_bill_unmet, 0::double precision)),
	auth_unbill = (COALESCE(auth_unbill_met, 0::double precision) + 
	COALESCE(auth_unbill_unmet, 0::double precision)),
	loss_app = (COALESCE(loss_app_unath, 0::double precision) + (COALESCE(loss_app_met_error, 0::double precision) + 
	COALESCE(loss_app_data_error, 0::double precision))::numeric::double precision),
   	loss_real = (COALESCE(loss_real_leak_main, 0::double precision) + COALESCE(loss_real_leak_service, 0::double precision) + 
	COALESCE(loss_real_storage, 0::double precision)),
	total_in = COALESCE(total_in::double precision, 0::double precision),
	total_out = COALESCE(total_out::double precision, 0::double precision),
	total = COALESCE(total_sys_input, 0::double precision) 
	WHERE startdate::date = '||quote_literal(v_startdate)||'::date and enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')';
	

	-- auth
	EXECUTE '
	UPDATE om_waterbalance SET auth =  (auth_bill + auth_unbill),
	nrw = (total::double precision - auth_bill::double precision)::numeric,
	nrw_eff = CASE WHEN total::double precision > 0::double precision THEN ((100::numeric * auth_bill)::double precision / total::double precision)::numeric
	ELSE 0::numeric end, loss = (total::double precision - auth_bill::double precision - auth_unbill::double precision)
	WHERE startdate::date = '||quote_literal(v_startdate)||'::date and enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')';
 		
	-- calculate ili
	v_a = 6.57;
	v_b = 9.13;
	v_c = 0.256;
	
	FOR v_dma IN EXECUTE 'SELECT DISTINCT dma_id FROM connec WHERE state = 1 AND expl_id IN ('||v_expl||')'
	LOOP
		v_kmarc = (SELECT COALESCE(sum(st_length(the_geom)),0) FROM arc WHERE state = 1 AND dma_id = v_dma)/1000;
		v_kmconnec = (SELECT COALESCE(sum(st_length(l.the_geom)),0) FROM link l JOIN connec c ON feature_id = connec_id WHERE c.state = 1 AND c.dma_id = v_dma)/1000;
		v_numconnec = (SELECT COALESCE(count(*),0) FROM connec WHERE state = 1 AND dma_id = v_dma);
		v_avgpress = (SELECT avg_press FROM dma WHERE dma_id = v_dma);
		
		v_uarl = (v_a*v_kmarc + v_b*v_kmconnec + v_c*v_numconnec)*v_avgpress;	
	
		v_carl = (SELECT sum(loss) FROM om_waterbalance WHERE startdate = v_startdate::date AND enddate = v_enddate::date AND 
			dma_id = v_dma)*(365/(SELECT case when quote_literal(v_enddate)::date - quote_literal(v_startdate)::date = 0 then 1
		else  quote_literal(v_enddate)::date - quote_literal(v_startdate)::date end));
	
		v_ili = v_carl/v_uarl;
	
		RAISE NOTICE ' % % %' , v_carl, v_uarl, v_dma;
	
		UPDATE om_waterbalance SET ili = v_ili, avg_press = v_avgpress
		WHERE startdate::date = v_startdate::date AND enddate::date = v_enddate::date AND dma_id = v_dma;

	END LOOP;
			
	-- get log data
	EXECUTE '
	SELECT sum(total_sys_input) as tsi, sum(auth_bill_met_hydro) as bmc, (sum(total_sys_input) - sum(auth_bill_met_hydro))::numeric (12,2) as nrw
	FROM om_waterbalance  
	WHERE startdate::date = '||quote_literal(v_startdate)||'::date and enddate::date = '||quote_literal(v_enddate)||'::date AND expl_id in ('||v_expl||')' 
	INTO rec_nrw;

	--restrict water balance if threshold days after lastupdate DMA are surpassed
	select value into v_days_limiter from config_param_system where parameter = 'om_waterbalance_threshold_days';
	
	EXECUTE 'select lastupdate::text from dma where expl_id @> ARRAY['||v_expl||'] and lastupdate is not null order by tstamp asc limit 1'  into v_current_date;

	if v_current_date is null then
	
		EXECUTE 'select tstamp::text from dma where expl_id @> ARRAY['||v_expl||'] and tstamp is not null order by tstamp asc limit 1' into v_current_date;
			
	end if;

	select date_part('day', now() - v_current_date::timestamp) into v_days_past;
		
	
	IF v_days_past is null then

		INSERT INTO audit_check_data (error_message, fid, cur_user, criticity) 
		VALUES ('ERROR: There are NULL values on lastupdate or tstamp on table dma. Please, update DMAs to fill these columns', v_fid, current_user, 3);
	
	ELSIF v_days_past >= v_days_limiter then
	
		INSERT INTO audit_check_data (error_message, fid, cur_user, criticity) 
		VALUES ('ERROR: Water balance is not allowed having surpassed the threshold day limiter (parameter om_waterbalance_threshold_days)', v_fid, current_user, 3);
		
	else
		
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Process done succesfully for period: ',v_period));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Number of DMA processed: ', v_count));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Number of hydrometer processed: ', v_hydrometer));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Total System Input: ', round(rec_nrw.tsi::numeric,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Billed metered consumtion: ', round(rec_nrw.bmc::numeric,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Non-revenue water: ', round(rec_nrw.nrw::numeric,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('DMAs updated ',date_part('day', now() - v_current_date::timestamp), ' days ago.'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
	
	end if;

	IF v_executegraphdma THEN

		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (441, 145) order by criticity desc, id asc) row;

		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

		-- disconnected arcs
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		 'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM 
		(SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Disconnected'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraph USING (arc_id) WHERE water = 0
		UNION
		SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraph USING (arc_id) WHERE water = -1
		) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_line = concat ('{"geometryType":"LineString", "features":',v_result,'}'); 

		-- disconnected connecs
		v_result = null;

		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		 'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT DISTINCT ON (connec_id) connec_id, conneccat_id, c.state, c.expl_id, 'Disconnected'::text as descript, c.the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = 0
		UNION
		SELECT DISTINCT ON (connec_id) connec_id, conneccat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = -1
		UNION			
		SELECT DISTINCT ON (connec_id) connec_id, conneccat_id, state, expl_id, 'Orphan'::text as descript, the_geom FROM v_edit_connec c WHERE dma_id = 0 AND arc_id IS NULL
		) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 
	ELSE

		-- info
		SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
		FROM (SELECT * FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid) a order by  id asc) row;
		v_result := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		
	END IF;

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

			
	--  Return
	RETURN  gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Process done succesfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
				  '"point":'||v_result_point||','||
				  '"line":'||v_result_line||'}'||'}}')::json, 3142, null, ('{"visible": ["v_edit_dma"]}')::json, null);
			      

END;
$function$
;

-- Permissions

ALTER FUNCTION SCHEMA_NAME.gw_fct_waterbalance(json) OWNER TO postgres;
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_waterbalance(json) TO public;
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_waterbalance(json) TO postgres;
GRANT ALL ON FUNCTION SCHEMA_NAME.gw_fct_waterbalance(json) TO role_basic;
