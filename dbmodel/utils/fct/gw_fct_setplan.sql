/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 3002

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setplan(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setplan(p_data json)
RETURNS json AS
$BODY$

/*+

SELECT gw_fct_setplan($${"client":{"device":4, "infoType":1, "lang":"ES"}, 
"form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"1"}}$$);
*/

DECLARE
v_version text;
v_psector integer;
v_query text;
v_count integer;
v_state_obsolete_planified integer;
v_uservalues json;

v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_error_context text;
v_result json;
v_result_info json;
v_result_line json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_psector := json_extract_path_text (p_data,'data','psectorId')::integer;
	v_state_obsolete_planified:= (SELECT value::json ->> 'obsolete_planified' FROM config_param_system WHERE parameter='plan_psector_status_action');

	-- delete previous logs
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = 354;
	DELETE FROM audit_check_data WHERE cur_user="current_user"() AND fid = 355;
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid = 354;
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND fid = 355;
	
	-- return el json. There are some topological inconsistences on this psector. Would you like to see the log (YES)  (LATER)
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (355, 4, concat('TOPOLOGICAL INCONSISTENCES'));
	INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (355, 4, '-------------------------------------------------------------');

	
	IF v_psector IS NOT NULL THEN

		-- control psector topology: find operative/planned arcs without operative nodes in this psector
		v_query = '
		select a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, concat(''Arc on service '',a.arc_id, '' has not node_1 ('', node_id, '') in this psector'') as descript,  a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0)n on node_1= node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1
		union
		select a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, concat(''Arc on service '',a.arc_id, '' has not node_2 ('', node_id, '') in this psector'') as descript, a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0 )n on node_2 = node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1';

		EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
		INTO v_count; 

		IF v_count > 0 THEN

			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 354, c.arc_id, c.arccat_id, concat(''Arc '', arc_id ,'' without some init/end operative nodes in this psector '',c.psector_id), c.the_geom, 1 FROM (', v_query,')c ');
			
			INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (354, '354', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' arcs without final nodes in this psector.'),v_count);
		
		END IF;		

		-- control psector topology: find planned arcs without planned nodes in this psector
		v_query = '
		select a.arc_id, arccat_id, a.the_geom FROM arc a
		join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') pa ON pa.arc_id = a.arc_id
		join node ON node_id = a.node_1
		left join (select * from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 1) pn ON pn.node_id = a.node_1
		where pn.node_id is null and a.state=2 and node.state = 2
		union
		select a.arc_id, arccat_id, a.the_geom FROM arc a
		join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') pa ON pa.arc_id = a.arc_id
		join node ON node_id = a.node_2
		left join (select * from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 1) pn ON pn.node_id = a.node_2
		where pn.node_id is null and a.state=2  and node.state = 2';

		EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
		INTO v_count; 

		IF v_count > 0 THEN

			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 355, c.arc_id, c.arccat_id, concat(''Planned arc  '', arc_id ,'' without some init/end planned nodes in this psector''), c.the_geom, 2 FROM (', v_query,')c ');
			
			INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (355, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' planned arcs without some init/end planed nodes in this psector.'),v_count);

		END IF;		

	END IF;

	 IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Process done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

	-- get uservalues
	PERFORM gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$);
	v_uservalues = (SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_vdefault', 'utils_workspace_vdefault')
	AND cur_user = current_user ORDER BY parameter)a);


	-- get results
	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, arccat_id, state, descript, node_1, node_2, expl_id, fid, st_length(the_geom) as length, the_geom
	  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (354,355)) row) features;

	v_result := COALESCE(v_result, '{}');
	v_result_line = concat ('{"geometryType":"LineString", "features":',v_result, '}');

	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (354, 355) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 

	--control nulls
	v_uservalues := COALESCE(v_uservalues, '{}');
		--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"userValues":'||v_uservalues||', "info":'||v_result_info||', "line":'||v_result_line||
			'}}'||
	    '}')::json, 3002, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;