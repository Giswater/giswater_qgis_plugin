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
SELECT SCHEMA_NAME.gw_fct_waterbalance($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{}, "data":{"parameters":{"executeGrafDma":"true", "exploitation":1, "period":"5"}}}$$)::text;
SELECT SCHEMA_NAME.gw_fct_waterbalance($${"client":{"device":4, "infoType":1, "lang":"ES"},"form":{}, "data":{"parameters":{"executeGrafDma":true, "exploitation":2, "period":"5"}}}$$)::text;

CHECK
-----
SELECT * FROM om_waterbalance

-- fid: 441

*/

DECLARE

v_fid integer = 441;
v_expl integer;
v_period text;

v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_version text;
v_error_context text;
v_count integer;
v_executegrafdma boolean;
v_updatemapzone integer;
v_paramupdate double precision;
v_data json;

rec_nrw record;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data 	
	v_expl := ((p_data ->>'data')::json->>'parameters')::json->>'exploitation';
	v_period := ((p_data ->>'data')::json->>'parameters')::json->>'period';
	v_executegrafdma := ((p_data ->>'data')::json->>'parameters')::json->>'executeGrafDma';

	IF v_executegrafdma THEN

		v_updatemapzone = (SELECT (value::json->>'DMA')::json->>'updateMapZone' FROM config_param_system WHERE parameter  = 'utils_grafanalytics_vdefault');
		v_paramupdate = (SELECT (value::json->>'DMA')::json->>'geomParamUpdate' FROM config_param_system WHERE parameter  = 'utils_grafanalytics_vdefault');
			
		v_data =  concat ('{"data":{"parameters":{"grafClass":"DMA", "exploitation": [',v_expl,'], "updateFeature":"TRUE", "updateMapZone":',v_updatemapzone,', "geomParamUpdate":',v_paramupdate,'}}}');
		
		PERFORM gw_fct_grafanalytics_mapzones(v_data);
		
	END IF;

	-- Reset values
	DELETE FROM anl_arc_x_node WHERE cur_user="current_user"() AND fid = v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = v_fid;	
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('WATER BALANCE BY EXPLOITATION AND PERIOD'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');


	INSERT INTO om_waterbalance (expl_id, dma_id, cat_period_id)
	SELECT v_expl, dma_id, v_period FROM dma WHERE expl_id = v_expl AND dma_id > 0
	ON CONFLICT (cat_period_id, dma_id) do nothing;

	UPDATE om_waterbalance n SET total_sys_input =  value FROM (SELECT cat_period_id, dma_id, (sum(coalesce(value,0)*flow_sign))::numeric(12,2) as value 
					FROM ext_rtc_scada_x_data JOIN om_waterbalance_dma_graf USING (node_id) GROUP BY cat_period_id, dma_id)a
					WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id;

	GET DIAGNOSTICS v_count = row_count;

	UPDATE om_waterbalance n SET auth_bill_met_hydro = value::numeric(12,2) FROM (SELECT dma_id, cat_period_id, (sum(sum))::numeric(12,2) as value
						FROM ext_rtc_hydrometer_x_data d
						JOIN rtc_hydrometer_x_connec USING (hydrometer_id)
						JOIN connec c USING (connec_id) GROUP BY dma_id, cat_period_id)a
						WHERE n.dma_id = a.dma_id AND n.cat_period_id = a.cat_period_id;

	SELECT sum(total_sys_input) as tsi, sum(auth_bill_met_hydro) as bmc,
		(sum(total_sys_input) - sum(auth_bill_met_hydro))::numeric (12,2) as nrw INTO rec_nrw
		FROM om_waterbalance WHERE expl_id = v_expl AND cat_period_id  = v_period;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, 'Process done succesfully');
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Number of DMA processed: ', v_count));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Total System Input: ', rec_nrw.tsi::numeric(12,2), ' CMP'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Billed metered consumtion: ', rec_nrw.bmc::numeric(12,2), ' CMP'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('Non-revenue water: ', rec_nrw.nrw::numeric(12,2), ' CMP'));

	IF v_executegrafdma THEN
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('-------------------------------------'));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat(''));
		INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('INFO: Grafanalylitcs mapzones for DMA have been triggered'));
		DELETE FROM audit_check_data WHERE fid = 145 AND cur_user = current_user AND error_message ='INFO';
		DELETE FROM audit_check_data WHERE fid = 145 AND cur_user = current_user AND error_message LIKE '---%';
	END IF;

	-- get results
	
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT * FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid 
		UNION
	     SELECT id+1000 as id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=145 AND criticity = 1)a
		order by  id asc) row;
		
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	IF v_executegrafdma THEN

		-- disconnected arcs
		SELECT jsonb_agg(features.feature) INTO v_result
		FROM (
		SELECT jsonb_build_object(
		 'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM 
		(SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Disconnected'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraf USING (arc_id) WHERE water = 0
		UNION
		SELECT DISTINCT ON (arc_id) arc_id, arccat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_arc JOIN temp_anlgraf USING (arc_id) WHERE water = -1
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
		FROM (SELECT DISTINCT ON (connec_id) connec_id, connecat_id, c.state, c.expl_id, 'Disconnected'::text as descript, c.the_geom FROM v_edit_connec c JOIN temp_anlgraf USING (arc_id) WHERE water = 0
		UNION
		SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Conflict'::text as descript, the_geom FROM v_edit_connec c JOIN temp_anlgraf USING (arc_id) WHERE water = -1
		UNION			
		SELECT DISTINCT ON (connec_id) connec_id, connecat_id, state, expl_id, 'Orphan'::text as descript, the_geom FROM v_edit_connec c WHERE dma_id = 0 AND arc_id IS NULL
		) row) features;

		v_result := COALESCE(v_result, '{}'); 
		v_result_point = concat ('{"geometryType":"Point", "features":',v_result, '}'); 
		
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