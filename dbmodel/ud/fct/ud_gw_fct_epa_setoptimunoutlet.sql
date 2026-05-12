/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3242

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_epa_setoptimumoutlet(p_data json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$

/*
SELECT gw_fct_epa_setoptimumoutlet($${"client":{},"data":{"parameters":{"buffer":1000}}}$$)::text

update inp_subcatchment SET outlet_id = null

SELECT * FROM ve_inp_subcatchment

select * from cat_hydrology

select * from config_param_user

fid: 495

*/

DECLARE

v_selectionmode text;
v_worklayer text;
rec_node record;
rec_subc record;
v_id json;
v_result json;
v_result_info json;
v_result_point json;
v_array text;
v_version text;
v_error_context text;
v_count integer;
v_fid integer = 495;
i integer = 0;
v_sector text;
v_hydrology integer;
v_name text;
v_count1 integer;
v_count2 integer;
v_buffer numeric;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- getting input data
	v_buffer := ((p_data ->>'data')::json->>'parameters')::json->>'buffer';
	v_id :=  ((p_data ->>'feature')::json->>'id')::json;
	v_worklayer := ((p_data ->>'feature')::json->>'tableName')::text;
	v_selectionmode :=  ((p_data ->>'data')::json->>'selectionMode')::text;

	-- controls for input data
	v_buffer = coalesce (v_buffer, 1000);
	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	TRUNCATE temp_node;
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3242", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- starting process
	v_sector = (SELECT replace (replace ((array_agg(sector_id))::text, '{', ''), '}', '') FROM ve_sector);

	IF v_selectionmode = 'previousSelection' then
		if v_array is not null then
			EXECUTE 'INSERT INTO temp_node (node_id, the_geom, elev) SELECT node_id, the_geom, elev FROM ve_node 
			WHERE epa_type = ''JUNCTION'' AND state > 0 AND sector_id in (select sector_id from ve_sector) and node_id in ('||v_array||')';
		end if;
	else
		INSERT INTO temp_node (node_id, the_geom, elev) SELECT node_id, the_geom, elev FROM ve_node
		WHERE epa_type = 'JUNCTION' AND state > 0 AND sector_id in (select sector_id from ve_sector);
	end if;

	SELECT value::integer INTO v_hydrology FROM config_param_user where parameter = 'inp_options_hydrology_scenario' and cur_user = current_user;
	select name into v_name from cat_hydrology where hydrology_id = v_hydrology;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4202", "function":"3242", "parameters":{"v_sector":"'||v_sector||'"}, "fid":"'||v_fid||'", "criticity":"3", "is_process":true}}$$)';
	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4204", "function":"3242", "parameters":{"v_name":"'||v_name||'"}, "fid":"'||v_fid||'", "criticity":"4", "is_process":true}}$$)';

	select count(*) into v_count1 from ve_inp_subcatchment where outlet_id is null;

	if (select count(*) from temp_node) > 0 then

		FOR rec_subc IN SELECT * FROM inp_subcatchment WHERE hydrology_id = v_hydrology AND sector_id in (select sector_id from ve_sector)
		loop


			IF rec_subc.minelev IS NULL THEN
				SELECT n.* INTO rec_node FROM temp_node n WHERE st_dwithin(rec_subc.the_geom, n.the_geom, v_buffer)
				ORDER BY st_distance(rec_subc.the_geom, n.the_geom) ASC LIMIT 1;
			ELSE
				SELECT n.* INTO rec_node FROM temp_node n WHERE st_dwithin(rec_subc.the_geom, n.the_geom, v_buffer)
				AND n.elev > rec_subc.minelev
				ORDER BY st_distance(rec_subc.the_geom, n.the_geom) ASC LIMIT 1;
			END IF;

			UPDATE inp_subcatchment SET outlet_id = rec_node.node_id WHERE hydrology_id = v_hydrology AND subc_id = rec_subc.subc_id;

		END LOOP;

		select count(*) into v_count2 from ve_inp_subcatchment where outlet_id is null;
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4206", "function":"3242", "parameters":{"v_count2-v_count1":"'||v_count2-v_count1||'"}, "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

	else
		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"4208", "function":"3242", "fid":"'||v_fid||'", "criticity":"1", "is_process":true}}$$)';

	end if;

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 4230, null, null, null);

END;
$function$
;
