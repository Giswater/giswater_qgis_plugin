/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
--FUNCTION CODE: XXXX
drop FUNCTION "SHCEMA_NAME".gw_fct_getwaterbalance(json);
CREATE OR REPLACE FUNCTION "SHCEMA_NAME".gw_fct_getdmabalance(p_data json) RETURNS json AS 
$BODY$
/*EXAMPLE
SELECT SHCEMA_NAME.gw_fct_getdmabalance($${"client":{"device":4, "infoType":1, "lang":"ES"},
"form":{},"feature":{"tableName":"v_edit_dma", "id":"1"}, 
"data":{"filterFields":{}, "pageInfo":{}, "selectionMode":"wholeSelection",
"parameters":{}}}$$)::JSON
-- fid: v_fid

*/

DECLARE
	    
v_id json;
v_selectionmode text;
v_worklayer text;
v_result json;
v_result_info json;
v_result_line json;
v_array text;
v_version text;
v_error_context text;
v_count integer;
v_checktype text;
v_fid integer = 479;
v_dmaid integer;
v_dmaname text;
v_explname text;
v_period_list text;
BEGIN

	-- Search path
	SET search_path = "SHCEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
		
	-- getting input data 	
	v_dmaid :=  ((p_data ->>'feature')::json->>'id')::json;

	select name INTO v_dmaname FROM dma WHERE dma_id = v_dmaid;
	select e.name INTO v_explname FROM dma JOIN exploitation e USING (expl_id) WHERE dma_id = v_dmaid;

	EXECUTE 'SELECT string_agg(quote_literal(period), '','') FROM 
	(select distinct period, crm_startdate from v_om_waterbalance where dma = '||quote_literal(v_dmaname)||' order by crm_startdate desc limit 4)a'
	INTO v_period_list;

	EXECUTE 'WITH balance AS (SELECT jsonb_build_object('||quote_literal(v_dmaname)||', json_agg(jsonb_build_object(period, jsonb_build_object(crm_startdate::date, total)))) as chart_dma
	FROM v_om_waterbalance WHERE dma = '||quote_literal(v_dmaname)||' AND period IN  ('||v_period_list||') ),
	balance_expl AS (SELECT jsonb_build_object('||quote_literal(v_explname)||', json_agg(jsonb_build_object(period, jsonb_build_object(a.crm_startdate::date,a.suma)))) as chart_expl from
	(SELECT crm_startdate::date, period, sum(total) AS suma
	FROM v_om_waterbalance WHERE exploitation = '||quote_literal(v_explname)||' AND  period IN  ('||v_period_list||')  group by crm_startdate,period)a)
	SELECT jsonb_build_object(
	''info'', to_jsonb(row) ,
	''chart'', (chart_dma::jsonb ||chart_expl::jsonb ))
	FROM balance, balance_expl,
	(SELECT DISTINCT 
	expl_name, 
	dma_name,
	meters_in,
	meters_out,
	n_connec,
	n_hydro,
	arc_length,
	link_length
	FROM 
	 v_om_waterbalance_report
	join dma using(dma_id) 
	WHERE dma_id = '||v_dmaid||') row'
	INTO v_result;

raise notice 'v_result,%',v_result;
	-- info
--	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
--	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		
	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
	             ',"body":{"form":{}'||
			     ',"data":{ "info":'||v_result_info||','||
					'"line":'||v_result_line||
				'}}'||
		    '}')::json, 3040, null, null, null);

	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


