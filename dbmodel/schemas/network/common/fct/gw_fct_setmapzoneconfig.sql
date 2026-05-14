/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3054

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setmapzoneconfig(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_setmapzoneconfig (p_data json)
RETURNS json AS
$BODY$

/*

SELECT SCHEMA_NAME.gw_fct_setmapzoneconfig($${"client":{"device":4, "infoType":1,"lang":"ES"}, "data":{"parameters":{"nodeIdOld":"1115","arcIdOld":"2220","arcIdNew":"114481","action":"updateArc"}}}$$);

SELECT SCHEMA_NAME.gw_fct_setmapzoneconfig($${"client":{"device":4, "infoType":1,"lang":"ES"}, "data":{"parameters":{"nodeIdOld":"23798", "nodeIdNew":"65835","action":"updateNode"}}}$$);


-- fid: XXX

*/

DECLARE

v_node_id_old integer;
v_node_id_new integer;
v_arc_id_old integer;
v_arc_id_new integer;
v_version  text;
v_mapzone_old text;
v_mapzone_new text;
v_config_length integer;
v_mapzone_id text;
v_config_mapzone json;
v_nodetype_old text;
v_nodetype_new text;
v_zonelist text[];
v_zone text;

v_project_type text;
v_result text;
v_result_info text;
v_result_point text;
v_result_line text;
v_result_polygon text;
v_error_context text;
v_audit_result text;
v_level integer;
v_status text;
v_message text;
v_array_addfields text[];
v_array_node_id json;
v_action text;
v_querytext text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	SELECT project_type, giswater INTO v_project_type, v_version FROM sys_version ORDER BY id DESC LIMIT 1;

	v_node_id_old = json_extract_path_text(p_data, 'data','parameters','nodeIdOld');
	v_node_id_new = json_extract_path_text(p_data, 'data','parameters','nodeIdNew');
	v_arc_id_old = json_extract_path_text(p_data, 'data','parameters','arcIdOld');
	v_arc_id_new = json_extract_path_text(p_data, 'data','parameters','arcIdNew');
	v_action = json_extract_path_text(p_data, 'data','parameters','action');

	IF v_action = 'updateArc' THEN

		IF v_project_type = 'WS' THEN

			-- mapzones
			FOREACH v_zone IN ARRAY '{sector, dma, presszone, dqa}'::text[]
			LOOP

				--update toArc value with newly created arc id
				v_querytext = 'UPDATE '||v_zone||' set graphconfig = replace(graphconfig::text,a.toarc,'||v_arc_id_new||'::text)::json FROM (
				select json_array_elements_text((elem->>''toArc'')::json) as toarc, elem->>''nodeParent'' as nodeparent
				from '||v_zone||'
				cross join json_array_elements((graphconfig->>''use'')::json) elem
				where elem->>''nodeParent'' = '||quote_literal(v_node_id_old)||' 
				AND (elem::json->>''toArc'') ilike ''%'||v_arc_id_old||'%'')a';
				EXECUTE v_querytext;

			END LOOP;

			-- man values
			UPDATE man_pump SET to_arc = v_arc_id_new WHERE to_arc = v_arc_id_old AND node_id = v_node_id_old;
			UPDATE man_valve SET to_arc = v_arc_id_new WHERE to_arc = v_arc_id_old AND node_id = v_node_id_old;

		ELSIF _project_type = 'UD' THEN

			-- mapzones


			-- man values


		END IF;


	ELSIF v_action = 'updateNode' THEN

		IF v_project_type='WS' THEN

			-- mapzones
			FOREACH v_zone IN ARRAY '{sector, dma, presszone, dqa}'::text[] LOOP

				--update nodeParent value with newly created node
				EXECUTE 'UPDATE '||v_zone||' set graphconfig = replace(graphconfig::text,a.nodeparent,'||v_node_id_new||'::text)::json FROM (
				select json_array_elements_text((elem->>''toArc'')::json) as toarc, elem->>''nodeParent'' as nodeparent
				from '||v_zone||'
				cross join json_array_elements((graphconfig->>''use'')::json) elem
				where elem->>''nodeParent'' = '||quote_literal(v_node_id_old)||')a';
			END LOOP;

		ELSIF  v_project_type='UD' THEN

				--update nodeParent value with newly created node
				EXECUTE 'UPDATE drainzone set graphconfig = replace(graphconfig::text,a.nodeparent,'||v_node_id_new||'::text)::json FROM (
				select json_array_elements_text((elem->>''toArc'')::json) as toarc, elem->>''nodeParent'' as nodeparent
				from drainzone
				cross join json_array_elements((graphconfig->>''use'')::json) elem
				where elem->>''nodeParent'' = '||quote_literal(v_node_id_old)||')a';
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

	v_result_info := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result_info, '}');

	v_result_point = '{}';
	v_result_line = '{}';
	v_result_polygon = '{}';

	v_status := COALESCE(v_status, '{}');
	v_level := COALESCE(v_level, '0');
	v_message := COALESCE(v_message, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
         ',"body":{"form":{}'||
         ',"data":{ "info":'||v_result_info||','||
        '"point":'||v_result_point||','||
        '"line":'||v_result_line||','||
        '"polygon":'||v_result_polygon||'}'||
       '}'
       '}')::json, 2112, null, null, null);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;