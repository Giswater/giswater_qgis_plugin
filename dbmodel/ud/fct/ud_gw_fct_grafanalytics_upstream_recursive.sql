/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2220

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace_recursive(character varying);
DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace_recursive(json);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_grafanalytics_upstream_recursive(p_data json) 
RETURNS json AS 
$BODY$

-- fid: 220

DECLARE

v_exists_id character varying;
v_node_id text;
v_node_json json;
v_audit_result text;
v_error_context text;
v_level integer;
v_status text;
v_message text;
v_version text;

rec_table record;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select version
	SELECT giswater INTO v_version FROM sys_version order by 1 desc limit 1;
	
	v_node_json = ((p_data ->>'feature')::json->>'id'::text);
	v_node_id = (SELECT json_array_elements_text(v_node_json)); 
	
	-- Check if the node is already computed
	SELECT node_id INTO v_exists_id FROM anl_node WHERE node_id = v_node_id AND cur_user="current_user"() AND fid = 220;

	-- Compute proceed
	IF NOT FOUND THEN
	
		-- Update value
		INSERT INTO anl_node (node_id, nodecat_id,state, expl_id, fid, the_geom)
		SELECT node_id, node_type, state, expl_id, 220, the_geom FROM v_edit_node WHERE node_id = v_node_id;

		-- Loop for all the upstream arcs
		FOR rec_table IN SELECT arc_id, arc_type, node_1, the_geom, expl_id FROM v_edit_arc WHERE node_2 = v_node_id
		LOOP
		
			-- Insert into tables
			INSERT INTO anl_arc (arc_id, arccat_id, expl_id, fid, the_geom) VALUES
			(rec_table.arc_id, rec_table.arc_type, rec_table.expl_id,220, rec_table.the_geom);

			-- Call recursive function weighting with the pipe capacity
			EXECUTE 'SELECT gw_fct_grafanalytics_upstream_recursive($${"client":{"device":4, "infoType":1, "lang":"ES"},"feature":{"id":["'||rec_table.node_1||'"]},"data":{}}$$);';
 
		END LOOP;

	END IF;

	IF v_audit_result is null THEN
		v_status = 'Accepted';
		v_level = 3;
		v_message = 'Arc fusion done successfully';
	ELSE

		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
		SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

	END IF;

	--Return
	RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"}')::json;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
