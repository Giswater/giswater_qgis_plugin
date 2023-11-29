/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3242

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_epa_setoptimumoutlet(p_data json) RETURNS json AS 
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_epa_setoptimumoutlet($${"client":{"device":4, "infoType":1, "lang":"ES"},"data":{"filterFields":{}, "pageInfo":{}, "parameters":{"sector":21}}}$$)::text

update inp_subcatchment SET outlet_id = null

SELECT * FROM v_edit_inp_subcatchment

select * from cat_hydrology

select * from config_param_user

fid: 495

*/

DECLARE

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
v_sector integer;
v_hydrology integer;
v_name text;
v_count1 integer;
v_count2 integer;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	
	-- getting input data 	
	v_sector := ((p_data ->>'data')::json->>'parameters')::json->>'sector';
	IF v_sector = -999 THEN
		v_sector = (SELECT replace (replace ((array_agg(sector_id))::text, '{', ''), '}', '') FROM v_edit_sector);
	END IF;

	select string_agg(quote_literal(a),',') into v_array from json_array_elements_text(v_id) a;

	raise notice '0 - Reset';
	TRUNCATE temp_node;
	DELETE FROM anl_node WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;		
	
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('SET OPTIMUM OUTLET'));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, '-------------------------------------------------------------');

	INSERT INTO temp_node (node_id, the_geom, elev) SELECT node_id, the_geom, elev FROM v_edit_node 
	WHERE epa_type = 'JUNCTION' AND state > 0 AND sector_id = v_sector;

	SELECT value::integer INTO v_hydrology FROM config_param_user where parameter = 'inp_options_hydrology_scenario' and cur_user = current_user;
	select name into v_name from cat_hydrology where hydrology_id = 11;

	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 3, concat('SECTOR ID: ', v_sector));
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 4, concat('HYDROLOGY SCENARIO: ', v_name));
	
	select count(*) into v_count1 from v_edit_inp_subcatchment where outlet_id is null;

	FOR rec_subc IN SELECT * FROM inp_subcatchment WHERE hydrology_id = v_hydrology AND sector_id in (v_sector)
	loop
		
		raise notice 'loop rec_subc % ', rec_subc.subc_id;
		
		IF rec_subc.minelev IS NULL THEN
			SELECT n.* INTO rec_node FROM temp_node n WHERE st_dwithin(rec_subc.the_geom, n.the_geom, 5000) 
			ORDER BY st_distance(rec_subc.the_geom, n.the_geom) ASC LIMIT 1;
		ELSE
			SELECT n.* INTO rec_node FROM temp_node n WHERE st_dwithin(rec_subc.the_geom, n.the_geom, 5000) 
			AND n.elev > rec_subc.minelev
			ORDER BY st_distance(rec_subc.the_geom, n.the_geom) ASC LIMIT 1;
		END IF;

		UPDATE inp_subcatchment SET outlet_id = rec_node.node_id WHERE hydrology_id = v_hydrology AND subc_id = rec_subc.subc_id;
		
	END LOOP;

	select count(*) into v_count2 from v_edit_inp_subcatchment where outlet_id is null;
	INSERT INTO audit_check_data (fid, result_id, criticity, error_message) VALUES (v_fid, null, 1, concat (v_count1-v_count2,' subcatchments have been updated with outlet values'));

	-- get results
	-- info	
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');	

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||
			'}}'||
	    '}')::json, 4230, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
