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

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_psector := json_extract_path_text (p_data,'data','psectorId')::integer;
	v_state_obsolete_planified:= (SELECT value::json ->> 'obsolete_planified' FROM config_param_system WHERE parameter='plan_psector_status_action');

	
	IF v_psector IS NOT NULL THEN

		--control psector topology: find arc, that on psector is defined as operative, on psector there are no nodes
		v_query = '
		select a.arc_id, node_id, concat(''Arc on service '',a.arc_id, '' has not node_1 ('', node_id, '') in this psector'') as descript,  a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0)n on node_1= node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1
		union
		select a.arc_id, node_id, concat(''Arc on service '',a.arc_id, '' has not node_2 ('', node_id, '') in this psector'') as descript, a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0 )n on node_2 = node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1';


		EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
		INTO v_count; 

		IF v_count > 0 THEN

			-- return el json. There are some topological inconsistences on this psector. Would you like to see the log (YES)  (LATER)
			/*
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (354, 4, concat('TOPOLOGICAL INCONSISTENCES'));
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (354, 4, '-------------------------------------------------------------');

			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 355, c.arc_id, c.arccat_id, concat(''Operative arc '', arc_id ,'' without final nodes in this psector '',c.psector_id), c.the_geom, 2 FROM (', v_query,')c ');
			
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (v_fid, '354', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' operative arcs without final nodes in this psector.'),v_count);
			*/
		
		END IF;		

		--control psector topology: find arc, that on inventory is defined as planified, but on psector there are no nodes
		v_query = '
		select a.arc_id, node_id, concat(''Arc planned '',a.arc_id, '' has not node_1 ('', node_id, '') in this psector'') as descript,  a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0)n on node_1= node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is not null and a.state=2
		union
		select a.arc_id, node_id, concat(''Arc planned '',a.arc_id, '' has not node_2 ('', node_id, '') in this psector'') as descript, a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0 )n on node_2 = node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is not null and a.state=2';

		EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
		INTO v_count; 

		IF v_count > 0 THEN

			-- return el json. There are some topological inconsistences on this psector. Would you like to see the log (YES)  (LATER)
			/*
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (355, 4, concat('TOPOLOGICAL INCONSISTENCES'));
			INSERT INTO audit_check_data (fid, criticity, error_message) VALUES (355, 4, '-------------------------------------------------------------');

			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 355, c.arc_id, c.arccat_id, concat(''Planned arc  '', arc_id ,'' without final nodes in this psector''), c.the_geom, 2 FROM (', v_query,')c ');
			
			INSERT INTO temp_audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (v_fid, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' planned arcs without final nodes in this psector.'),v_count);
			*/								 

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

	--control nulls
	v_uservalues := COALESCE(v_uservalues, '{}');
		--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"userValues":'||v_uservalues||', "info":{}'||
			'}}'||
	    '}')::json, 3002, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;