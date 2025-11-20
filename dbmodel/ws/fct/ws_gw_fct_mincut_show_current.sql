/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3236

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_mincut_show_current(p_data json) ;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_mincut_show_current(p_data json)
RETURNS json AS
$BODY$

/*EXAMPLE

SELECT SCHEMA_NAME.gw_fct_mincut_show_current($${
"client":{"device":4, "lang":"es_ES", "infoType":1, "epsg":SRID_VALUE},
"form":{}, "feature":{}, "data":{"filterFields":{},
"pageInfo":{}, "parameters":{"explId":"1"}}}$$);

--fid: 490
*/

DECLARE

rec_node record;
rec record;

v_version text;
v_result json;
v_id json;
v_result_info json;
v_result_line json;
v_expl_id integer;
v_worklayer text;
v_array text;
v_node_aux record;
v_error_context text;
v_count integer;
v_fid integer = 490;
BEGIN

	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	-- Reset values
	DELETE FROM anl_node WHERE cur_user="current_user"() AND anl_node.fid=v_fid;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid;

	EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"function":"3236", "fid":"'||v_fid||'", "criticity":"4", "is_process":true, "is_header":"true"}}$$)';

	-- getting input data
	v_expl_id := json_extract_path_text(p_data,'data','parameters','explId')::integer;

	-- get results
	--lines
	v_result = null;
  EXECUTE 'SELECT jsonb_build_object(
        ''type'', ''FeatureCollection'',
        ''features'', COALESCE(jsonb_agg(features.feature), ''[]''::jsonb)
    ) 
 	FROM (
    SELECT jsonb_build_object(
    ''type'',       ''Feature'',
    ''geometry'',   ST_AsGeoJSON(ST_Transform(the_geom, 4326))::jsonb,
    ''properties'', to_jsonb(row) - ''the_geom'' - ''srid''
    ) AS feature
    FROM
	(SELECT
	om_mincut_arc.id,
	om_mincut_arc.result_id,
	m.work_order,
	om_mincut_arc.arc_id,
	om_mincut_arc.the_geom,
	ST_SRID(om_mincut_arc.the_geom) as srid
	FROM om_mincut m
	JOIN om_mincut_arc ON result_id = m.id
	where mincut_state = 1 and expl_id ='||v_expl_id||')row)features'
 		INTO v_result;

  	v_result_line = COALESCE(v_result, '{}');

	SELECT count(*) INTO v_count FROM om_mincut WHERE expl_id =v_expl_id and mincut_state = 1;

	IF v_count = 0 THEN

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3542", "function":"3236", "v_count":"'||v_count||'", "fid":"'||v_fid||'",  "is_process":true}}$$)';
	ELSE

		EXECUTE 'SELECT gw_fct_getmessage($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{},
                       "data":{"message":"3544", "function":"3236", "parameters":{"v_count":"'||v_count||'"}, "fid":"'||v_fid||'","fcount":"'||v_count||'",  "is_process":true}}$$)';

		INSERT INTO audit_check_data(fid,  error_message, fcount)
		SELECT v_fid,  concat ('Mincut_id: ',string_agg(id::text, ', '), '.' ), v_count
		FROM om_mincut WHERE expl_id =v_expl_id and mincut_state = 1;

	END IF;

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid=v_fid order by  id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_result_line := COALESCE(v_result_line, '{}');

	-- Return
	RETURN gw_fct_json_create_return(('{"status":"Accepted", "message":{"level":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"line":'||v_result_line||
			'}}'||
	    '}')::json, 3236, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
