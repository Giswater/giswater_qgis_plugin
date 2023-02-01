/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3142

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_waterbalance(p_data json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_waterbalance(p_data json)  RETURNS json AS
$BODY$

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
v_expl integer;
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
v_startdate date;
v_enddate date;
v_dma integer;
v_total_hydro double precision = 0;
v_total_input double precision = 0;
v_total_inlet double precision = 0;
v_total_out double precision = 0;
v_centroidday integer;
v_prevperiod text;

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

BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data 	
	v_expl := ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_period := ((p_data ->>'data')::json->>'parameters')::json->>'period';
	v_allperiods := (((p_data ->>'data')::json->>'parameters')::json->>'allPeriods')::boolean;
	v_executegraphdma := ((p_data ->>'data')::json->>'parameters')::json->>'executeGraphDma';
	v_method := ((p_data ->>'data')::json->>'parameters')::json->>'method';

	-- Reset values
	DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid = v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('WATER BALANCE BY EXPLOITATION AND PERIOD'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');


	IF v_executegraphdma THEN

		IF v_setmawithperiodmeters THEN 

			UPDATE dma SET active = false, the_geom = null WHERE expl_id = v_expl;
			
			UPDATE dma SET active = true FROM 
			(SELECT * FROM 
			(SELECT dma_id, (json_array_elements_text((graphconfig->>'use')::json))::json->>'nodeParent'  as node_id FROM dma) b JOIN 
			(SELECT DISTINCT (node_id) FROM ext_cat_period, ext_rtc_scada_x_data JOIN node USING (node_id) WHERE  
			node.expl_id = v_expl AND start_date < value_date AND end_date > value_date) a USING (node_id))c
			WHERE dma.dma_id = c.dma_id;
			
		END IF;
		
		v_updatemapzone = (SELECT (value::json->>'DMA')::json->>'updateMapZone' FROM config_param_system WHERE 
		parameter  = 'utils_graphanalytics_vdefault');
		v_paramupdate = (SELECT (value::json->>'DMA')::json->>'geomParamUpdate' FROM config_param_system WHERE 
		parameter  = 'utils_graphanalytics_vdefault');
			
		v_data =  concat ('{"data":{"parameters":{"graphClass":"DMA", "exploitation": [',v_expl,'], "updateMapZone":',v_updatemapzone,
		', "geomParamUpdate":',v_paramupdate,', "updateFeature":true}}}');

		PERFORM gw_fct_graphanalytics_mapzones(v_data);
	END IF;

	IF v_allperiods IS TRUE THEN
		v_querytext ='SELECT id FROM ext_cat_period order by start_date asc';
	ELSE
		v_querytext ='SELECT id FROM ext_cat_period WHERE id='||quote_literal(v_period)||'';
	END IF;

	FOR rec IN EXECUTE v_querytext LOOP
		
		v_period=rec;

		-- calculation process
		INSERT INTO om_waterbalance (expl_id, dma_id, cat_period_id)
		SELECT v_expl, dma_id, v_period FROM dma WHERE expl_id = v_expl AND dma_id > 0
		ON CONFLICT (cat_period_id, dma_id) do nothing;

		-- getting dates for period
		v_startdate = (SELECT start_date FROM ext_cat_period WHERE id = v_period);
		v_enddate =  (SELECT end_date FROM ext_cat_period WHERE id = v_period);

		IF v_method = 'CPW' THEN -- static period

			-- startdate & enddate
			UPDATE om_waterbalance SET startdate = v_startdate, enddate = v_enddate WHERE cat_period_id = v_period;

			-- total inlet
			UPDATE om_waterbalance n SET total_in =  value FROM (
			SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric(12,2) as value 
			FROM ext_cat_period p, ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph  USING (node_id)
			WHERE value_date >= start_date AND value_date <= end_date and flow_sign = 1
			GROUP BY p.id, dma_id order by 1,2)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.id;

			-- total_inyected
			UPDATE om_waterbalance n SET total_sys_input =  value FROM (
			SELECT dma_id, p.id, (sum(coalesce(value,0)*flow_sign))::numeric(12,2) as value 
			FROM ext_cat_period p, ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph  USING (node_id)
			WHERE value_date >= start_date AND value_date <= end_date 
			GROUP BY p.id, dma_id order by 1,2)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.id;

			-- total outlet
			UPDATE om_waterbalance n SET total_out = total_in - total_sys_input
			WHERE cat_period_id = v_period;

	 			SELECT count(*) INTO v_count FROM om_waterbalance WHERE cat_period_id = v_period AND expl_id = v_expl;

			-- auth_bill_met_hydro
			UPDATE om_waterbalance n SET auth_bill_met_hydro = value::numeric(12,2) FROM (SELECT dma_id, cat_period_id, (sum(sum))::numeric(12,2) as value
			FROM ext_rtc_hydrometer_x_data d
			JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
			JOIN connec c USING (connec_id) GROUP BY dma_id, cat_period_id)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id;

			UPDATE om_waterbalance SET auth_bill_met_hydro = 0 WHERE auth_bill_met_hydro is null AND cat_period_id = v_period;
	 			
	 		ELSIF  v_method = 'DCW' THEN -- dynamic period acording centroid for dates x vol of dma

			FOR v_dma IN SELECT DISTINCT dma_id FROM connec WHERE state = 1 AND expl_id = v_expl
			LOOP
			v_count = v_count + 1;
			
			v_total_hydro = (SELECT sum(sum) FROM ext_rtc_hydrometer_x_data JOIN rtc_hydrometer_x_connec USING (hydrometer_id) JOIN connec USING (connec_id) where cat_period_id = v_period AND dma_id = v_dma AND expl_id = v_expl);

			v_centroidday = (SELECT (sum(sum*extract(epoch from value_date)/(24*3600)))/v_total_hydro FROM ext_rtc_hydrometer_x_data 
					JOIN rtc_hydrometer_x_connec USING (hydrometer_id) JOIN connec USING (connec_id) where cat_period_id = v_period AND dma_id = v_dma);
			IF v_centroidday IS NULL THEN 
				v_centroidday = extract(epoch from((end_date - start_date) + start_date))/(24*3600);
			END IF;

			v_startdate = (SELECT start_date FROM ext_cat_period WHERE id = v_period);

			v_prevperiod = (SELECT id FROM ext_cat_period WHERE end_date + interval '5 days' > v_startdate AND start_date <  v_startdate);

			v_startdate = (SELECT enddate FROM om_waterbalance WHERE dma_id = v_dma AND cat_period_id = v_prevperiod);
			
			IF v_startdate IS NULL OR v_prevperiod IS NULL THEN v_startdate = '1970-01-01'::date; END IF;
			
			v_enddate = (to_timestamp(v_centroidday*3600*24))::date;

			--raise notice ' % % % % % %',v_centroidday::integer , v_period, v_prevperiod, v_dma, v_startdate, v_enddate;

			v_total_input = (SELECT (sum(coalesce(value,0)*flow_sign))::numeric(12,2)
					FROM ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph USING (node_id) WHERE dma_id = v_dma AND value_date >= v_startdate AND value_date <= v_enddate);

			v_total_inlet = (SELECT (sum(coalesce(value,0)*flow_sign))::numeric(12,2)
					FROM ext_rtc_scada_x_data JOIN om_waterbalance_dma_graph USING (node_id) WHERE flow_sign = 1 AND dma_id = v_dma AND value_date >= v_startdate AND value_date <= v_enddate);

			v_total_out = v_total_inlet - v_total_input;

			UPDATE om_waterbalance SET total_sys_input = v_total_input, total_in = v_total_inlet, total_out = v_total_out,
					auth_bill_met_hydro = v_total_hydro::numeric(12,2), startdate = v_startdate, enddate = v_enddate WHERE cat_period_id = v_period AND dma_id = v_dma;
			END LOOP;
			
			END IF;

			--update data
			UPDATE om_waterbalance n SET n_connec = count_connecs, link_length = length::numeric(12,3)
			FROM (SELECT c.dma_id, p.id as cat_period_id, count(connec_id) as count_connecs, sum(st_length(l.the_geom)) /1000 as length
			FROM ext_cat_period p, rtc_hydrometer_x_connec d
			JOIN connec c USING (connec_id) 
			left join link l on connec_id = feature_id
			where c.state=1 and p.id = v_period
			GROUP BY c.dma_id, p.id)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id AND expl_id = v_expl;
			
			UPDATE om_waterbalance n SET n_hydro = count_hydro FROM 
			(SELECT dma_id, p.id as cat_period_id, count(hydrometer_id) as count_hydro
			FROM ext_cat_period p, rtc_hydrometer_x_connec d
			JOIN connec c USING (connec_id) 
			JOIN ext_rtc_hydrometer h ON c.customer_code = h.connec_id
			where state=1  and p.id = v_period
			GROUP BY dma_id, p.id)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id AND expl_id = v_expl;

			UPDATE om_waterbalance set n_connec = 0, link_length = 0, n_hydro = 0 where n_connec is null;

			UPDATE om_waterbalance n SET arc_length = length::numeric(12,3) FROM 
			(SELECT dma_id, p.id as cat_period_id, sum(st_length(the_geom)) /1000 as length
			FROM  arc c ,ext_cat_period p
			where state=1 and p.id = v_period
			GROUP BY dma_id, p.id)a
			WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id AND expl_id = v_expl;

			UPDATE om_waterbalance set arc_length = 0 where arc_length is null;

	 		UPDATE om_waterbalance w SET meters_in = meters FROM 
	 		(SELECT string_agg (node_id, ', ') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = 1 group by dma_id) a
	 		WHERE a.dma_id = w.dma_id AND cat_period_id = v_period AND expl_id = v_expl;

			UPDATE om_waterbalance w SET meters_out = meters FROM 
	 		(SELECT string_agg (node_id, ', ') as meters, dma_id FROM om_waterbalance_dma_graph WHERE flow_sign = -1 group by dma_id) a
	 		WHERE a.dma_id = w.dma_id AND cat_period_id = v_period AND expl_id = v_expl;

	 		UPDATE om_waterbalance SET auth_bill = (COALESCE(auth_bill_met_export, 0::double precision) + 
	 		COALESCE(auth_bill_met_hydro, 0::double precision) + COALESCE(auth_bill_unmet, 0::double precision)),
	 		auth_unbill = (COALESCE(auth_unbill_met, 0::double precision) + 
	 		COALESCE(auth_unbill_unmet, 0::double precision)),
			loss_app = (COALESCE(loss_app_unath, 0::double precision) + (COALESCE(loss_app_met_error, 0::double precision) + 
			COALESCE(loss_app_data_error, 0::double precision))::numeric(12,2)::double precision),
    	loss_real = (COALESCE(loss_real_leak_main, 0::double precision) + COALESCE(loss_real_leak_service, 0::double precision) + 
    	COALESCE(loss_real_storage, 0::double precision)),
    	total_in = COALESCE(total_in::double precision, 0::double precision),
   		total_out = COALESCE(total_out::double precision, 0::double precision),
    	total = COALESCE(total_sys_input, 0::double precision) WHERE cat_period_id = v_period AND expl_id = v_expl;

    	UPDATE om_waterbalance SET auth =  (auth_bill + auth_unbill),
    	nrw = (total::double precision - auth_bill::double precision)::numeric(12,2),
    	nrw_eff = CASE WHEN total::double precision > 0::double precision THEN ((100::numeric * auth_bill)::double precision / total::double precision)::numeric(12,2)
      ELSE 0::numeric(12,2) end,
      loss = (total::double precision - auth_bill::double precision - auth_unbill::double precision)
      WHERE cat_period_id = v_period AND expl_id = v_expl;
	 		
			-- calculate ili
			v_a = 6.57;
			v_b = 9.13;
			v_c = 0.256;
			
			FOR v_dma IN SELECT DISTINCT dma_id FROM connec WHERE state = 1 AND expl_id = v_expl
			LOOP
			v_kmarc = (SELECT COALESCE(sum(st_length(the_geom)),0) FROM arc WHERE state = 1 AND dma_id = v_dma)/1000;
			v_kmconnec = (SELECT COALESCE(sum(st_length(l.the_geom)),0) FROM link l JOIN connec c ON feature_id = connec_id WHERE c.state = 1 AND c.dma_id = v_dma)/1000;
			v_numconnec = (SELECT COALESCE(count(*),0) FROM connec WHERE state = 1 AND dma_id = v_dma);
			v_avgpress = (SELECT avg_press FROM dma WHERE dma_id = v_dma);
			
			v_uarl = (v_a*v_kmarc + v_b*v_kmconnec + v_c*v_numconnec)*v_avgpress;	
			
			v_carl = (SELECT loss FROM om_waterbalance WHERE cat_period_id = v_period AND 
				dma_id = v_dma)*(365/(SELECT extract (day from end_date - start_date) FROM ext_cat_period WHERE id = v_period));

			v_ili = v_carl/v_uarl;

			RAISE NOTICE ' % % %' , v_carl, v_uarl, v_dma;

			UPDATE om_waterbalance SET ili = v_ili WHERE cat_period_id = v_period AND dma_id = v_dma;

			END LOOP;
			
		END LOOP;	

		-- get log data
		SELECT sum(total_sys_input) as tsi, sum(auth_bill_met_hydro) as bmc, (sum(total_sys_input) - sum(auth_bill_met_hydro))::numeric (12,2) as nrw INTO rec_nrw
		FROM om_waterbalance WHERE expl_id = v_expl AND cat_period_id  = v_period;

		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Process done succesfully for period: ',v_period));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Number of DMA processed: ', v_count));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Total System Input: ', rec_nrw.tsi::numeric(12,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Billed metered consumtion: ', rec_nrw.bmc::numeric(12,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Non-revenue water: ', rec_nrw.nrw::numeric(12,2), ' CMP'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));


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
			FROM (SELECT DISTINCT ON (connec_id) connec_id, connecat_id, c.state, c.expl_id, 'Disconnected'::text as descript, c.the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = 0
			UNION
			SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_connec c JOIN temp_anlgraph USING (arc_id) WHERE water = -1
			UNION			
			SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Orphan'::text as descript, the_geom FROM v_edit_connec c WHERE dma_id = 0 AND arc_id IS NULL
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
	RETURN  gw_fct_json_create_return(('{"status":"accepted", "message":{"level":1, "text":"Process done succesfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}, "data":{ "info":'||v_result_info||','||
				  '"point":'||v_result_point||','||
				  '"line":'||v_result_line||'}'||'}}')::json, 3142, null, ('{"visible": ["v_edit_dma"]}')::json, null);
			      

	--EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;$BODY$
LANGUAGE plpgsql VOLATILE
 COST 100;