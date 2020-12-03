/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2904

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_odbc2pg_hydro_filldata(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_odbc2pg_hydro_filldata(p_data json)
  RETURNS json AS
$BODY$
 

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_odbc2pg_hydro_filldata($${
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{},"data":{"parameters":{"exploitation":"507", "period":"3T", "year":"2019"}}}$$)

*/


DECLARE
v_expl integer;
v_period text;
v_year integer;
v_project_type text;
v_version text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_querytext text;
v_count	integer;
v_error_context text;
	
BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;


	/* getting input data 	
	v_expl := (((p_data ->>'data')::json->>'parameters')::json->>'exploitation')::integer;
	v_year := (((p_data ->>'data')::json->>'parameters')::json->>'year')::integer;
	v_period := (((p_data ->>'data')::json->>'parameters')::json->>'period')::text;
	*/
	
	-- select config values
	SELECT wsoftware, giswater INTO v_project_type, v_version FROM version order by id desc limit 1;


	-- ext_cat_period
	INSERT INTO ext_cat_period (id, code, period_seconds, period_year, period_name, period_type) 
	SELECT DISTINCT CONCAT(log_message::json->>'year', '-', log_message::json->>'period') , CONCAT(log_message::json->>'year', 0, log_message::json->>'period'), 2*30*24*3600, 
	(log_message::json->>'year')::integer, (log_message::json->>'period')::integer, 1
	FROM audit_log_data WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fprocesscat_id=74
	ON CONFLICT (id) DO NOTHING;

	-- rtc_hdyrometer
	INSERT INTO rtc_hydrometer (hydrometer_id)
	SELECT feature_id FROM audit_log_data WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fprocesscat_id=74
	ON CONFLICT (hydrometer_id) DO NOTHING;

	-- ext_rtc_hdydrometer
	IF (SELECT value FROM config_param_system WHERE parameter='admin_crm_schema')::boolean THEN
		INSERT INTO crm.hydrometer (id, connec_id, state_id, expl_id, category_id)
		SELECT a.feature_id , log_message::json->>'connec_id', 1, (log_message::json->>'expl_id')::integer, 1  FROM audit_log_data a
		WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fid = 174
		ON CONFLICT (id) DO NOTHING;
	ELSE
		INSERT INTO ext_rtc_hydrometer (id, connec_id, state_id, expl_id, category_id)
		SELECT a.feature_id::int8 , (log_message::json->>'connec_id')::integer, 1, (log_message::json->>'expl_id')::integer, 1 FROM audit_log_data a
		WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fid = 174 and (log_message::json->>'connec_id')!='None'
		ON CONFLICT (id) DO NOTHING;
	END IF;

	-- hydrometer_x_connec
	INSERT INTO rtc_hydrometer_x_connec (hydrometer_id, connec_id)
	SELECT a.feature_id , connec_id FROM audit_log_data a
	JOIN connec ON connec_id = (log_message::json->>'connec_id')
	WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fid = 174
	ON CONFLICT (hydrometer_id) DO NOTHING;

	-- ext_rtc_dma_period
	INSERT INTO ext_rtc_dma_period (dma_id, cat_period_id, effc, minc, maxc, pattern_id) 
	SELECT dma_id, CONCAT(log_message::json->>'year', 0, log_message::json->>'period') , 1, 1, 1, dma.pattern_id
	FROM audit_log_data 
	JOIN rtc_hydrometer_x_connec ON feature_id=hydrometer_id 
	JOIN connec USING (connec_id)
	JOIN dma USING (dma_id)
	WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fprocesscat_id=74
	ON CONFLICT (dma_id, cat_period_id) DO NOTHING;

	-- ext_rtc_hydrometer_category_x_pattern
	INSERT INTO ext_hydrometer_category_x_pattern (category_id, period_type, pattern_id) 
	SELECT category_id, period_type, c.pattern_id
	FROM audit_log_data 
	JOIN ext_cat_period a ON CONCAT(log_message::json->>'year', 0, log_message::json->>'period') = a.id
	JOIN ext_rtc_hydrometer b ON b.id=feature_id::int8
	JOIN ext_hydrometer_category c ON c.id::integer=b.category_id::integer	
	WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fprocesscat_id=74
	ON CONFLICT (category_id, period_type) DO NOTHING;

	--ext_rtc_hydrometer_x_data
	INSERT INTO ext_rtc_hydrometer_x_data (hydrometer_id, sum, cat_period_id, pattern_id) 
	SELECT feature_id, (log_message::json->>'value')::numeric(12,5)*2*30*24*3.6, concat(log_message::json->>'year', '-', log_message::json->>'period'), c.pattern_id
	FROM audit_log_data 
	LEFT JOIN ext_rtc_hydrometer a ON a.id=feature_id::int8
	LEFT JOIN ext_cat_period b ON CONCAT(log_message::json->>'year', 0, log_message::json->>'period')::int8 = a.id
	LEFT JOIN ext_hydrometer_category_x_pattern c ON a.category_id=c.category_id::integer
	WHERE log_message::json->>'year' IS NOT NULL AND log_message::json->>'period' IS NOT NULL AND fid = 174
	ON CONFLICT (hydrometer_id, cat_period_id) DO NOTHING;

	-- update connec table
	UPDATE connec SET num_value = lps FROM (
	WITH query AS (
	SELECT log_message::json->>'periodSeconds' as ps, log_message::json->>'value' as value, log_message::json->>'connec_id'::text as connec_id, log_message::json->>'expl_id' as expl_id
	FROM audit_log_data WHERE fid = 174 and cur_user = current_user)
	SELECT sum(ps::integer*value::numeric(12,5)/1000)::numeric(12,2) as m3value, connec_id, expl_id::integer FROM query group by expl_id, connec_id) a WHERE connec.expl_id = a.expl_id and connec.connec_id = a.connec_id;
	
	--  Return
	RETURN ('{"status":"Accepted", "message":{"level":1, "text":"ODBC hydro fill data done succesfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{}'||
		     '}}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;