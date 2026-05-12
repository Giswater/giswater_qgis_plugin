/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/


--FUNCTION CODE: 3554

CREATE OR REPLACE FUNCTION cm.gw_fct_cm_check_progress(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*EXAMPLE


SELECT gw_fct_cm_check_progress($${"client":{"device":4, "lang":"es_ES", "version":"4.5.3", "infoType":1, "epsg":8908}, "form":{}, 
"feature":{}, "data":{"filterFields":{}, "pageInfo":{}, "parameters":{"campaignId":"4"}, "aux_params":null}}$$);

*/

DECLARE

-- Init params
v_version text;
v_srid integer;
v_project_type text = 'ws';
v_fid integer = 999;
v_function_id integer = 3554;


v_campaign_id integer;
v_lot_id integer;



-- Vars

v_sql_result TEXT;
v_sum numeric = 0;
v_sum_total numeric = 1;
v_sum_result numeric;
v_filter text;
v_lot_list text;
v_campaign_name text;



-- Return

v_result json;
v_result_info json;




BEGIN

    SET search_path = "PARENT_SCHEMA","cm", public;

	-- Init params
	SELECT giswater, epsg INTO v_version, v_srid FROM sys_version ORDER BY id DESC LIMIT 1;
   
   	v_campaign_id := (p_data ->'data' ->'parameters'->>'campaignId')::integer;


	EXECUTE 'SELECT gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"CREATE", "group":"LOG"}}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"data":{"function":"'||v_function_id||'", "fid":"'||v_fid||'", "tempTable":"t_", "is_header":true,"separator_id":"2022"}}$$)';


	SELECT name into v_campaign_name FROM cm.om_campaign WHERE campaign_id = v_campaign_id;


	-- calculate length of arcs for campaign
	execute 'select round(sum(st_length(c.the_geom)::numeric)/1000, 2) from cm.om_campaign_lot_x_arc join cm.om_campaign_lot ocl using (lot_id)
				join cm.om_campaign_x_arc c using (arc_id) WHERE ocl.campaign_id = '||v_campaign_id||' and action is not null' INTO v_sum;
	execute 'select round(sum(st_length(c.the_geom)::numeric)/1000, 2) from cm.om_campaign_lot_x_arc join cm.om_campaign_lot ocl using (lot_id)
				join cm.om_campaign_x_arc c using (arc_id) WHERE ocl.campaign_id = '||v_campaign_id||' and arc_id > 0' INTO v_sum_total;

	v_sum_result = round((v_sum/v_sum_total)*100, 2);


   	-- Report results
   	INSERT INTO t_audit_check_data (fid, criticity, error_message) SELECT v_fid, 2, CONCAT('Km de red hechos: ', v_sum, '.'); 
	INSERT INTO t_audit_check_data (fid, criticity, error_message) SELECT v_fid, 2, CONCAT('Km de red en el inicio de la campaña: ', v_sum_total, '.'); 
	INSERT INTO t_audit_check_data (fid, criticity, error_message) SELECT v_fid, 1, '';
	INSERT INTO t_audit_check_data (fid, criticity, error_message) SELECT v_fid, 1, concat('En km de red, el progreso de la campaña ', v_campaign_id, ' es del ', v_sum_result, ' %.');


   	-- Return results

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM t_audit_check_data WHERE fid = v_fid ORDER BY id asc, criticity desc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');


	EXECUTE 'SELECT PARENT_SCHEMA.gw_fct_manage_temp_tables($${"data":{"parameters":{"fid":'||v_fid||', "project_type":"'||v_project_type||'", "action":"DROP", "group":"LOG"}}}$$)';

	DROP TABLE IF EXISTS t_count_nodes;


	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||'}}'||
	    '}')::json, 2110, null, null, null);
   
END;
$function$
;

