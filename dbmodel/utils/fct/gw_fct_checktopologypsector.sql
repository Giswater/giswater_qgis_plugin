/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version.
*/

--FUNCTION CODE: 3002

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_setplan(json);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_checktopologypsector(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_checktopologypsector(p_data json)
RETURNS json AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_checktopologypsector($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{}, "data":{"filterFields":{}, "pageInfo":{},"psectorId":"1"}}$$);
*/

DECLARE
v_version text;
v_psector integer;
v_query text;
v_count integer;
v_state_obsolete_planified integer;
v_uservalues json;

v_audit_result text;
v_level integer = 3;
v_status text = 'Accepted';
v_message text = 'Process done successfully';
v_error_context text;
v_result json;
v_result_info json;
v_result_line json;
v_result_point json;
v_project_type text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- select config values
	SELECT giswater INTO v_version FROM sys_version ORDER BY id DESC LIMIT 1;
	SELECT project_type INTO v_project_type FROM sys_version ORDER BY id DESC LIMIT 1;


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

		-- find links for connects state 0 and link null
		v_query = 'SELECT 355, c.connec_id, c.conneccat_id, c.the_geom, ''downgraded connecs without link_id informed in this psector.'', c.state 
		FROM plan_psector_x_connec p JOIN link l ON feature_id = connec_id 
		LEFT JOIN connec c USING (connec_id)
		WHERE p.state = 0 AND p.link_id IS NULL AND l.state = 1 AND psector_id = '||v_psector||'
		';

		EXECUTE 'SELECT count(*) FROM ('||v_query||')c' INTO v_count;

		IF v_count > 0 THEN

			INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (355, '355', 3, FALSE, concat('ERROR-354: There are ',v_count,' downgraded connecs without link_id informed in this psector.'),v_count);
			v_level = 1;

			EXECUTE 'INSERT INTO anl_connec (fid, connec_id, conneccat_id, descript, the_geom, state) '||v_query||'';
			v_level = 1;

		END IF;

		IF v_project_type = 'UD' THEN

			v_query = 'SELECT 355, g.gully_id, g.gullycat_id, ''downgraded gully without link_id informed in this psector.'', g.the_geom, g.state FROM plan_psector_x_gully p 
			JOIN link l ON feature_id = gully_id
			LEFT JOIN gully g USING (gully_id)
			WHERE p.state = 0 AND p.link_id IS NULL AND l.state = 1 AND psector_id = '||v_psector||'';

			EXECUTE 'SELECT count(*) FROM ('||v_query||')c' INTO v_count;

			IF v_count > 0 THEN

				INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
				VALUES (354, '354', 3, FALSE, concat('ERROR-354: There are ',v_count,' downgraded gullies without link_id informed in this psector.'),v_count);
				v_level = 1;


				EXECUTE 'INSERT INTO anl_gully (fid, gully_id, gullycat_id, descript, the_geom, state) '||v_query||'';
				v_level = 1;

			END IF;
		END IF;

		-- control psector topology: find operative/planned arcs without operative nodes in this psector
		v_query = '
		select 355, a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, concat(''Arc on service '',a.arc_id, '' has not node_1 ('', node_id, '') in this psector'') as descript,  a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0)n on node_1= node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1
		union
		select 355, a.arc_id, a.arccat_id, node_id, '|| v_psector ||' as psector_id, concat(''Arc on service '',a.arc_id, '' has not node_2 ('', node_id, '') in this psector'') as descript, a.the_geom FROM arc a
		join (select node_id from plan_psector_x_node where psector_id = '|| v_psector ||' and state = 0 )n on node_2 = node_id
		left join (select * from plan_psector_x_arc where psector_id = '|| v_psector ||') p ON p.arc_id = a.arc_id
		where p.arc_id is null and a.state=1';

		EXECUTE 'SELECT count(*) FROM ('||v_query||')c'
		INTO v_count;

		IF v_count > 0 THEN

			EXECUTE concat ('INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom,state)
			SELECT 355, c.arc_id, c.arccat_id, concat(''Arc '', arc_id ,'' without some init/end operative nodes in this psector '',c.psector_id), c.the_geom, 1 FROM (', v_query,')c ');

			INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
			VALUES (355, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' arcs without some init/end operative nodes in this psector.'),v_count);
			v_level = 1;

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
			v_level = 1;

		END IF;

	END IF;

	-- get uservalues
	PERFORM gw_fct_workspacemanager($${"client":{"device":4, "infoType":1, "lang":"ES"}, "form":{}, "feature":{},"data":{"filterFields":{}, "pageInfo":{}, "action":"CHECK"}}$$);
	v_uservalues = (SELECT to_json(array_agg(row_to_json(a))) FROM (SELECT parameter, value FROM config_param_user WHERE parameter IN ('plan_psector_current', 'utils_workspace_current')
	AND cur_user = current_user ORDER BY parameter)a);

	IF v_level = 1 THEN
		v_message = 'Proces done successfully but with some incosistency';
	END IF;

	v_query = '
		SELECT 355, a.arc_id, a.arccat_id, concat(''Planned arc  '', a.arc_id ,'' with wrong topology''), a.the_geom, a.state
	 	FROM arc a
	 	join plan_psector_x_arc px using (arc_id) 
	 	LEFT JOIN node n ON n.node_id = a.node_1
	 	LEFT JOIN node m ON m.node_id = a.node_2 
	 	WHERE psector_id = '||v_psector||'
		AND st_distance(st_startpoint(a.the_geom), st_endpoint(a.the_geom)) - st_distance(n.the_geom, m.the_geom) 
		NOT BETWEEN -0.05 AND 0.05';


	EXECUTE 'SELECT count(*) FROM ('||v_query||')c' INTO v_count;

	IF v_count > 0 THEN

		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (355, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' planned arcs with wrong topology.'),v_count);

		EXECUTE 'INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom, state) '||v_query||'';
		v_level = 1;

	END IF;


	v_query = 'SELECT 355, arc_id, arccat_id, concat(''Planned arc  '', arc_id ,'' with wrong topology''), the_geom, a.state 
	FROM arc a LEFT JOIN plan_psector_x_arc USING (arc_id) 
	WHERE (node_1 IS NULL OR node_2 IS NULL) AND psector_id = '||v_psector||' AND a.state=2';


	EXECUTE 'SELECT count(*) FROM ('||v_query||')c' INTO v_count;

	IF v_count > 0 THEN

		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (355, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' planned arcs with wrong topology.'),v_count);


		EXECUTE 'INSERT INTO anl_arc (fid, arc_id, arccat_id, descript, the_geom, state) '||v_query||'';
		v_level = 1;

	END IF;


	-- duplicated nodes
	v_query = '
	WITH mec AS ( -- operative nodes that ARE NOT inside the psector
	SELECT node_id, state, nodecat_id, expl_id, the_geom FROM node WHERE state=1 AND node_id NOT IN (SELECT node_id FROM plan_psector_x_node WHERE psector_id = '||v_psector||' AND state=0 AND NOT archived)
	), moc AS ( -- new planified nodes inside the psector 
	SELECT a.node_id, b.state, b.nodecat_id, b.expl_id, b.the_geom FROM plan_psector_x_node a JOIN node b USING (node_id) WHERE a.psector_id = '||v_psector||' AND a.state=1 AND NOT a.archived
	)
	SELECT 355 as fid, a.node_id, a.nodecat_id, ''duplicated nodes'' as descript, a.the_geom, a.expl_id, a.state FROM mec a JOIN moc b ON st_dwithin (a.the_geom, b.the_geom, 0.01)';


	EXECUTE 'SELECT count(*) FROM ('||v_query||')c' INTO v_count;


	IF v_count > 0 THEN

		INSERT INTO audit_check_data (fid, result_id,  criticity, enabled,  error_message, fcount)
		VALUES (355, '355', 3, FALSE, concat('ERROR-354 (anl_arc): There are ',v_count,' duplicated nodes'),v_count);


		EXECUTE 'INSERT INTO anl_node (fid, node_id, nodecat_id, descript, the_geom, expl_id, state) '||v_query||'';
		v_level = 1;

	END IF;

	-- get results
	--lines
	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (SELECT id, arc_id, arccat_id, state, descript, node_1, node_2, expl_id, fid, st_length(the_geom) as length, ST_Transform(the_geom, 4326) as the_geom
	  	FROM  anl_arc WHERE cur_user="current_user"() AND fid IN (354,355)) row) features;

	v_result_line := COALESCE(v_result, '{}');

	v_result = null;
	SELECT jsonb_build_object(
	    'type', 'FeatureCollection',
	    'features', COALESCE(jsonb_agg(features.feature), '[]'::jsonb)
	) INTO v_result
	FROM (
	  	SELECT jsonb_build_object(
	     'type',       'Feature',
	    'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	    'properties', to_jsonb(row) - 'the_geom'
	  	) AS feature
	  	FROM (
	  		SELECT node_id, nodecat_id, state, descript, expl_id, fid, ST_Transform(the_geom, 4326) as the_geom FROM anl_node WHERE cur_user="current_user"() AND fid IN (354,355) UNION
			SELECT connec_id, conneccat_id, state, descript, expl_id, fid, ST_Transform(the_geom, 4326) as the_geom FROM anl_connec WHERE cur_user="current_user"() AND fid IN (354,355)
	  		) row) features;

	v_result_point := COALESCE(v_result, '{}');



	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE cur_user="current_user"() AND fid IN (354, 355) order by criticity desc, id asc) row;
	v_result := COALESCE(v_result, '{}');
	v_result_info = concat ('{"values":',v_result, '}');

	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}');
	v_uservalues := COALESCE(v_uservalues, '{}');

	--  Return
	RETURN gw_fct_json_create_return(('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{"userValues":'||v_uservalues||', "info":'||v_result_info||', "line":'||v_result_line||', "point":'||v_result_point||
			'}}'||
	    '}')::json, 3002, null, null, null);

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN json_build_object('status', 'Failed', 'NOSQLERR', SQLERRM, 'message', json_build_object('level', right(SQLSTATE, 1), 'text', SQLERRM), 'SQLSTATE', SQLSTATE, 'SQLCONTEXT', v_error_context)::json;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;